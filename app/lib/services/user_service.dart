import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/user/login_model.dart';
import '../models/user/user_model.dart';

class UserService {
  Map<String, dynamic> _decodeBody(http.Response response) {
    if (response.body.isEmpty) return <String, dynamic>{};
    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('A resposta da API não é um objeto JSON.');
    }
    return decoded;
  }

  String _message(Map<String, dynamic> body,
          [String fallback = 'Não foi possível concluir a solicitação.']) =>
      body['message']?.toString() ?? fallback;

  void _logFailure(String operation, Object error, StackTrace stackTrace) {
    AppConfig.getLogger()
        .e('Falha em $operation: $error', error: error, stackTrace: stackTrace);
  }

  Future<LoginResponse?> login(LoginRequest loginRequest) async {
    final String apiUrl = '${AppConfig.apiUrl}/users/auth/login';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(loginRequest.toJson()),
      );
      final jsonResponse = _decodeBody(response);
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(jsonResponse);
      } else {
        return LoginResponse(message: _message(jsonResponse));
      }
    } catch (error, stackTrace) {
      _logFailure('login', error, stackTrace);
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
        body: jsonEncode(createUserRequest.toJson()),
      );
      final jsonResponse = _decodeBody(response);

      if (response.statusCode == 200) {
        return UserResponse.fromJson(jsonResponse);
      } else {
        return UserResponse(message: _message(jsonResponse));
      }
    } catch (error, stackTrace) {
      _logFailure('cadastro', error, stackTrace);
      return null;
    }
  }

  Future<UserResponse?> getUser(String id) async {
    try {
      http.Client client = await AppConfig.getHttpClient();
      final response =
          await client.get(Uri.parse('${AppConfig.apiUrl}user?id=$id'));
      final jsonResponse = _decodeBody(response);
      if (response.statusCode == 200) {
        return UserResponse.fromJson(jsonResponse);
      }
      return UserResponse(message: _message(jsonResponse));
    } catch (error, stackTrace) {
      _logFailure('consulta de usuário', error, stackTrace);
      return null;
    }
  }

  Future<UserResponse?> updateUser(
      UpdateUserRequest updateUserRequest, String id) async {
    final String apiUrl = '${AppConfig.apiUrl}user?id=$id';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.put(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updateUserRequest.toJson()),
      );
      final jsonResponse = _decodeBody(response);

      if (response.statusCode == 200) {
        return UserResponse.fromJson(jsonResponse);
      } else {
        return UserResponse(message: _message(jsonResponse));
      }
    } catch (error, stackTrace) {
      _logFailure('atualização de usuário', error, stackTrace);
      return null;
    }
  }
}
