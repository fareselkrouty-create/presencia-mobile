class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'http://192.168.1.1:8080/api'; // à changer

  // Auth
  static const String login  = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refresh = '/auth/refresh';

  // Pointage
  static const String checkIn      = '/pointage/check-in';
  static const String checkOut     = '/pointage/check-out';
  static const String historique   = '/pointage/historique';
  static const String pointageById = '/pointage'; // + /{id}

  // Profil
  static const String profil       = '/employe/profil';
  static const String updateProfil = '/employe/profil/update';

  // Timeouts
  static const int connectTimeout = 10000; // ms
  static const int receiveTimeout = 15000;
}