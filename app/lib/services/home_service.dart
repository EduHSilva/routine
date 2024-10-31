import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';

class HomeService {
  Future<String> search(search) async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
        await client.get(Uri.parse('${AppConfig.apiUrl}search?search=$search'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);


      return data['data'];
    } else {
      throw Exception('Failed to load search');
    }
  }
}
