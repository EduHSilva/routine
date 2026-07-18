import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user/user_model.dart';

class AppConfig {
  static User? user;
  static Future<void> Function()? onUnauthorized;
  static final ValueNotifier<bool> isOffline = ValueNotifier(false);

  static String get apiUrl =>
      dotenv.env['URL_API'] ?? 'http://default-url.com/';

  static String? get googleClientId => dotenv.env['GOOGLE_CLIENT_ID'];

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  static Future<http.Client> getHttpClient() async {
    final token = await getToken();

    return _HttpClientWithBearerToken(token);
  }

  static Logger getLogger() {
    var logger = Logger();
    return logger;
  }

  static Future<void> saveToken(String? token) async {
    if (token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_token', token);
    }
  }

  static Future<void> saveUser(User? userSave) async {
    if (userSave != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userJson = jsonEncode(userSave.toJson());
      user = userSave;
      await prefs.setString('user', userJson);
    }
  }

  static Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson == null || userJson.isEmpty) {
      throw const FormatException('Usuário salvo não encontrado.');
    }
    final decoded = jsonDecode(userJson);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Usuário salvo possui formato inválido.');
    }
    user = User.fromJson(decoded);
  }

  static Future<void> cleanStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user');
    user = null;
  }

  static Future<void> logout() => cleanStorage();
}

class _HttpClientWithBearerToken extends http.BaseClient {
  final String? token;
  final http.Client _client = http.Client();

  _HttpClientWithBearerToken(this.token);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    request.headers['Content-Type'] = 'application/json; charset=UTF-8';
    request.headers['Accept-Language'] = Platform.localeName;

    final response = await _client.send(request);
    if (response.statusCode == 401) {
      await AppConfig.logout();
      await AppConfig.onUnauthorized?.call();
    }
    return response;
  }
}
