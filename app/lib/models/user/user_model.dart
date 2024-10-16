
import 'package:routine/models/response.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String lastLogin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      lastLogin: json['lastLogin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'lastLogin': lastLogin,
    };
  }
}

class UserResponse extends DefaultResponse{
  User? user;
  
  UserResponse({
    this.user,
    required message,
  }) : super(message: '');

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      user: User?.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class CreateUserRequest {
  final String name;
  final String email;
  final String password;

  CreateUserRequest({required this.name, required this.email, required this.password});
}