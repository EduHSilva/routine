import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/tasks/task_model.dart';


class TasksService {
  Future<Map<String, List<Task>>> fetchWeekTasks(DateTime date) async {
    http.Client client = await AppConfig.getHttpClient();
    String formatedDate =  DateFormat('yyyy-MM-dd').format(date);
    final response = await client.get(Uri.parse(
        '${AppConfig.apiUrl}tasks/week?currentDate=$formatedDate'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      Map<String, List<Task>> tasksByDay = {};

      data['data'].forEach((key, value) {
        if (value['tasks'] != null) {
          tasksByDay[key] = (value['tasks'] as List).map((taskJson) {
            return Task.fromJson(taskJson);
          }).toList();
        }
      });

      return tasksByDay;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<List<Task>> fetchTasksRules() async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
        await client.get(Uri.parse('${AppConfig.apiUrl}tasks/rules'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      List<Task> tasks = [];

      if (data['data'] != null) {
        tasks =
            List<Task>.from(data['data'].map((task) => Task.fromJson(task)));
      }

      return tasks;
    } else {
      throw Exception('Failed to load tasks rules');
    }
  }

  Future<TaskResponse?> addRule(CreateTaskRequest createRequest) async {
    final String apiUrl = '${AppConfig.apiUrl}task/rule';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.post(
        Uri.parse(apiUrl),
        body: jsonEncode(<String, dynamic>{
          "category_id": createRequest.categoryID,
          "date_end": formatDate(createRequest.dateEnd),
          "date_start": formatDate(createRequest.dateStart),
          "end_time": createRequest.endTime,
          "frequency": createRequest.frequency,
          "priority": createRequest.priority,
          "start_time": createRequest.startTime,
          "title": createRequest.title,
          "user_id": createRequest.userID
        }),
      );


      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return TaskResponse.fromJson(jsonResponse);
      } else {
        return TaskResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }

  Future<TaskResponse> getTask(int id) async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
        await client.get(Uri.parse('${AppConfig.apiUrl}task/rule?id=$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      TaskResponse? task = TaskResponse.fromJson(jsonResponse);

      return task;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<TaskResponse?> editTaskRule(int id, UpdateTaskRequest request) async {
    final String apiUrl = '${AppConfig.apiUrl}task/rule';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.put(Uri.parse("$apiUrl?id=$id"),
          body: jsonEncode(<String, dynamic>{
            'title': request.title,
            'priority': request.priority,
            'category_id': request.categoryID,
          }));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return TaskResponse.fromJson(jsonResponse);
      } else {
        return TaskResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }

  Future<TaskResponse?> deleteTask(int id) async {
    final String apiUrl = '${AppConfig.apiUrl}task/rule';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.delete(Uri.parse("$apiUrl?id=$id"));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return TaskResponse.fromJson(jsonResponse);
      } else {
        return TaskResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }

  String? formatDate(String date) {
    try {
      return DateTime.parse(date).toUtc().toIso8601String();
    } catch (e) {
      return null;
    }
  }

  Future<TaskResponse?> changeTaskStatus(int id) async {
    final String apiUrl = '${AppConfig.apiUrl}task';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.put(Uri.parse("$apiUrl?id=$id"));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return TaskResponse.fromJson(jsonResponse);
      } else {
        return TaskResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }
}
