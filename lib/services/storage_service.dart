import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  final _box = GetStorage();

  static const _tokenKey        = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userKey         = 'user';
  static const _themeModeKey    = 'theme_mode';

  // Token
  String? getToken()                   => _box.read(_tokenKey);
  void    saveToken(String token)      => _box.write(_tokenKey, token);
  void    removeToken()                => _box.remove(_tokenKey);

  // Refresh token
  String? getRefreshToken()            => _box.read(_refreshTokenKey);
  void    saveRefreshToken(String t)   => _box.write(_refreshTokenKey, t);
  void    removeRefreshToken()         => _box.remove(_refreshTokenKey);

  // User (stocké en JSON)
  Map<String, dynamic>? getUser()      => _box.read(_userKey);
  void saveUser(Map<String, dynamic> u)=> _box.write(_userKey, u);
  void removeUser()                    => _box.remove(_userKey);

  // Thème
  String getThemeMode()                => _box.read(_themeModeKey) ?? 'system';
  void   saveThemeMode(String mode)    => _box.write(_themeModeKey, mode);

  // Tout effacer à la déconnexion
  void clearSession() {
    removeToken();
    removeRefreshToken();
    removeUser();
  }
}