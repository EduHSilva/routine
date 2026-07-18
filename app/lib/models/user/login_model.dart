import '../response.dart';
import 'user_model.dart';

class LoginResponse extends DefaultResponse {
  final User? user;
  final String? token;

  LoginResponse({
    this.user,
    this.token,
    required super.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final payload = data is Map<String, dynamic> ? data : <String, dynamic>{};
    final userData = payload['user'] is Map<String, dynamic>
        ? payload['user'] as Map<String, dynamic>
        : payload;
    return LoginResponse(
      user: userData.isNotEmpty ? User.fromJson(userData) : null,
      token: (payload['token'] ?? json['token'])?.toString(),
      message: json['message']?.toString() ?? '',
    );
  }
}

class LoginRequest {
  final String email;
  final String? password;
  final String? idContaGoogle;

  LoginRequest({required this.email, this.password, this.idContaGoogle});

  Map<String, String> toJson() {
    final data = <String, String>{'email': email};
    if (password != null) data['password'] = password!;
    if (idContaGoogle != null) data['idContaGoogle'] = idContaGoogle!;
    return data;
  }
}
