import '../response.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String lastLogin;
  final String? photo;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.lastLogin,
      this.photo});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id']?.toString() ?? '',
        name: (json['username'] ?? json['name'])?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        lastLogin: json['lastLogin']?.toString() ?? '',
        photo: json['photo']?.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'lastLogin': lastLogin,
      'photo': photo
    };
  }
}

class UserResponse extends DefaultResponse {
  final User? user;

  UserResponse({
    this.user,
    required super.message,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return UserResponse(
      user: data is Map<String, dynamic> ? User.fromJson(data) : null,
      message: json['message']?.toString() ?? '',
    );
  }
}

class CreateUserRequest {
  final String name;
  final String email;
  final String password;

  CreateUserRequest(
      {required this.name, required this.email, required this.password});

  Map<String, String> toJson() =>
      {'name': name, 'email': email, 'password': password};
}

class UpdateUserRequest {
  final String name;
  final String email;
  final String? photo;

  UpdateUserRequest({required this.name, required this.email, this.photo});

  Map<String, String?> toJson() =>
      {'name': name, 'email': email, 'photo': photo};
}
