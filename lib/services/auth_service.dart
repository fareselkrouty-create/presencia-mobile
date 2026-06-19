import 'package:get/get.dart';
import '../config/api_config.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final _api     = Get.find<ApiService>();
  final _storage = Get.find<StorageService>();

  Future<UserModel> login(String matricule, String password) async {
    final data = await _api.post(ApiConfig.login, {
      'matricule': matricule,
      'password':  password,
    });

    final response = AuthResponseModel.fromJson(data);
    _storage.saveToken(response.accessToken);
    if (response.refreshToken != null) {
      _storage.saveRefreshToken(response.refreshToken!);
    }
    _storage.saveUser(response.user.toJson());
    return response.user;
  }

  Future<void> logout() async {
    try {
      await _api.post(ApiConfig.logout, {});
    } finally {
      _storage.clearSession();
    }
  }

  bool get isLoggedIn => _storage.getToken() != null;

  UserModel? get cachedUser {
    final json = _storage.getUser();
    return json != null ? UserModel.fromJson(json) : null;
  }
}