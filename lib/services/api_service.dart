import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../config/api_config.dart';
import 'storage_service.dart';

class ApiService extends GetxService {
  late final Dio _dio;
  final _storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl:        ApiConfig.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConfig.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConfig.receiveTimeout),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(_AuthInterceptor(_storage, _dio));

    // Log uniquement en debug
    assert(() {
      _dio.interceptors.add(LogInterceptor(
        requestBody:  true,
        responseBody: true,
        logPrint: (o) => print(o),
      ));
      return true;
    }());
  }

  Future<dynamic> get(
      String endpoint, {
        Map<String, dynamic>? queryParams,
      }) async {
    final res = await _dio.get(endpoint, queryParameters: queryParams);
    return res.data;
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final res = await _dio.post(endpoint, data: body);
    return res.data;
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final res = await _dio.put(endpoint, data: body);
    return res.data;
  }

  Future<dynamic> delete(String endpoint) async {
    final res = await _dio.delete(endpoint);
    return res.data;
  }
}

// Interceptor : injecte le JWT + gère le 401
class _AuthInterceptor extends Interceptor {
  final StorageService _storage;
  final Dio _dio;

  _AuthInterceptor(this._storage, this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Token expiré → tentative de refresh
    if (err.response?.statusCode == 401) {
      final refreshed = await _tryRefresh();
      if (refreshed) {
        // Rejoue la requête originale avec le nouveau token
        final opts    = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer ${_storage.getToken()}';
        final response = await _dio.fetch(opts);
        return handler.resolve(response);
      } else {
        _storage.clearSession();
        Get.offAllNamed('/login');
      }
    }
    handler.next(_parseError(err));
  }

  Future<bool> _tryRefresh() async {
    try {
      final refreshToken = _storage.getRefreshToken();
      if (refreshToken == null) return false;
      final res = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      _storage.saveToken(res.data['accessToken']);
      return true;
    } catch (_) {
      return false;
    }
  }

  DioException _parseError(DioException err) {
    String message;
    switch (err.response?.statusCode) {
      case 400: message = err.response?.data['message'] ?? 'Requête invalide.';
      case 403: message = 'Accès refusé.';
      case 404: message = 'Ressource introuvable.';
      case 500: message = 'Erreur serveur. Réessayez plus tard.';
      default:  message = 'Erreur réseau. Vérifiez votre connexion.';
    }
    return DioException(
      requestOptions: err.requestOptions,
      response:       err.response,
      message:        message,
      type:           err.type,
    );
  }
}