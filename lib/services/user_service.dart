import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/user/login_model.dart';
import '../models/user/user_model.dart';

class UserService {
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

  Future<UserResponse?> getUser(int id) async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
    await client.get(Uri.parse('${AppConfig.apiUrl}user?id=$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      UserResponse? task = UserResponse.fromJson(jsonResponse);

      return task;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<UserResponse?> updateUser(UpdateUserRequest updateUserRequest, int id) async {
    final String apiUrl = '${AppConfig.apiUrl}user?id=$id';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': updateUserRequest.email,
          'photo': updateUserRequest.photo == null ? "" : updateUserRequest.photo!,
          'name': updateUserRequest.name
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
