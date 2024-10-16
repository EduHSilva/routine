import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:routine/config/app_config.dart';
import '../models/user/login_model.dart';
import '../models/user/user_model.dart';

class AuthService {
  Future<LoginResponse?> login(LoginRequest loginRequest) async {
    final String apiUrl = '${AppConfig.apiUrl}login';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': loginRequest.email,
          'password': loginRequest.password,
        }),
      );
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonResponse);
      } else {
        return LoginResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
    }
    return null;
  }

    Future<UserResponse?> register(CreateUserRequest createUserRequest) async {
    final String apiUrl = '${AppConfig.apiUrl}user';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': createUserRequest.email,
          'password': createUserRequest.password,
          'name': createUserRequest.name
        }),
      );
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return UserResponse.fromJson(jsonResponse);
      } else {
        return UserResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }
}
