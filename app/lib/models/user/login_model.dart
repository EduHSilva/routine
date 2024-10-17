
import 'package:app/models/user/user_model.dart';

import '../response.dart';

class LoginResponse extends DefaultResponse {
  final User? user;
  final String? token;

  LoginResponse({
    this.user,
    this.token,
    required super.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: User.fromJson(json['data']['user']),
      token: json['data']['token'],
      message: json['message'],
    );
  }
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});
}