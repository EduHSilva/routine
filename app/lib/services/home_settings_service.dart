import 'dart:convert';

import '../config/app_config.dart';
import '../models/home_settings.dart';

class HomeSettingsService {
  Future<HomeSettings> fetch() async {
    final client = await AppConfig.getHttpClient();
    final response = await client.get(Uri.parse('${AppConfig.apiUrl}/fitness/config/user'));
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('Unable to load fitness settings');
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return HomeSettings.fromJson((body['data'] ?? body) as Map<String, dynamic>);
  }

  Future<void> save(HomeSettings settings) async {
    final client = await AppConfig.getHttpClient();
    final response = await client.put(
      Uri.parse('${AppConfig.apiUrl}/fitness/config/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(settings.toApiJson()),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) throw Exception('Unable to save fitness settings');
  }

  Future<void> saveTodayHistory({
    required bool creatine,
    required int cardio,
  }) async {
    final client = await AppConfig.getHttpClient();
    final response = await client.put(
      Uri.parse('${AppConfig.apiUrl}/fitness/config/history'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'creatine': creatine, 'cardio': cardio}),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Unable to save daily history');
    }
  }
}
