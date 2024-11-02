import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/health/diet_model.dart';
import '../models/response.dart';
import '../models/tasks/task_model.dart';

class HomeDailyResponse extends DefaultResponse {
  HomeDailyResponse({required super.message, required this.tasks, required this.nextMeal});

  List<Task>? tasks;
  Meal? nextMeal;
}

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

  Future<HomeDailyResponse> getDailyData() async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
    await client.get(Uri.parse('${AppConfig.apiUrl}daily'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      List<Task> tasks = [];
      if (data['data']['tasks'] != null) {
        tasks = List<Task>.from(data['data']['tasks'].map((task) => Task.fromJson(task)));
      }


      return HomeDailyResponse(message: data['message'], tasks: tasks, nextMeal: Meal.fromJson(data['data']['meal']));
    } else {
      throw Exception('Failed to load daily data');
    }
  }
}
