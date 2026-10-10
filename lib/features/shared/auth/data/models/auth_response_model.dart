import 'package:sanad_app/features/shared/auth/data/models/user_model.dart';

class AuthResponseModel {
  final String? access;
  final String? refresh;
  final UserModel? user;
  final String? accessExpiration;
  final String? refreshExpiration;

  AuthResponseModel({
    this.access,
    this.refresh,
    this.user,
    this.accessExpiration,
    this.refreshExpiration,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      access: json['access'],
      refresh: json['refresh'],
      accessExpiration: json['access_expiration'],
      refreshExpiration: json['refresh_expiration'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
