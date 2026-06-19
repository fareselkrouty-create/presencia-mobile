import 'user_model.dart';

class AuthResponseModel {
  final String accessToken;
  final String? refreshToken;
  final String tokenType;
  final UserModel user;

  AuthResponseModel({
    required this.accessToken,
    required this.user,
    this.refreshToken,
    this.tokenType = 'Bearer',
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      AuthResponseModel(
        accessToken:  json['accessToken'] ?? json['token'],
        refreshToken: json['refreshToken'],
        tokenType:    json['tokenType'] ?? 'Bearer',
        user:         UserModel.fromJson(json['user']),
      );
}