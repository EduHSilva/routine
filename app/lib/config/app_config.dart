import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user/user_model.dart';

class AppConfig {
  static User? user;
  static String get apiUrl =>
      dotenv.env['URL_API'] ?? 'http://default-url.com/';

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

  if (userJson != null) {
    user = User.fromJson(jsonDecode(userJson));
  }
}

  static Future<void> cleanStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user');
  }
}

class _HttpClientWithBearerToken extends http.BaseClient {
  final String? token;
  final http.Client _client = http.Client();

  _HttpClientWithBearerToken(this.token);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (token != null) {
      request.headers['x-access-token'] = '$token';
    }

    request.headers['Content-Type'] = 'application/json; charset=UTF-8';

    return _client.send(request);
  }
}
