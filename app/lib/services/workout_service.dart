import 'dart:convert';

import 'package:app/models/health/workout_model.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/tasks/task_model.dart';


class WorkoutService {
  Future<List<Exercise>> fetchExercises() async {
    http.Client client = await AppConfig.getHttpClient();
    final response = await client.get(Uri.parse(
        '${AppConfig.apiUrl}workout/exercises'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);


      List<Exercise> exercises = [];

      if (data['data'] != null) {
        exercises = List<Exercise>.from(data['data'].map((task) => Exercise.fromJson(task)));
      }

      return exercises;
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<List<Workout>> fetchWorkouts() async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
        await client.get(Uri.parse('${AppConfig.apiUrl}workouts'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      List<Workout> workouts = [];

      if (data['data'] != null) {
        workouts =
            List<Workout>.from(data['data'].map((task) => Workout.fromJson(task)));
      }

      return workouts;
    } else {
      throw Exception('Failed to load workouts');
    }
  }

  Future<WorkoutResponse> getWorkout(int id) async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
        await client.get(Uri.parse('${AppConfig.apiUrl}workout?id=$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      WorkoutResponse? workoutResponse = WorkoutResponse.fromJson(jsonResponse);

      return workoutResponse;
    } else {
      throw Exception('Failed to load workout');
    }
  }

  Future<WorkoutResponse?> addWorkout(CreateWorkoutRequest request) async {
    final String apiUrl = '${AppConfig.apiUrl}workout';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.post(Uri.parse(apiUrl),
          body: jsonEncode(<String, dynamic>{
            'name': request.name,
            'exercises': request.exercises,
            'user_id': request.userID
          }));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return WorkoutResponse.fromJson(jsonResponse);
      } else {
        return WorkoutResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }

  Future<WorkoutResponse?> editWorkout(int id, UpdateWorkoutRequest request) async {
    final String apiUrl = '${AppConfig.apiUrl}workout';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.put(Uri.parse("$apiUrl?id=$id"),
          body: jsonEncode(<String, dynamic>{
            'name': request.name,
            'exercises': request.exercises,
          }));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return WorkoutResponse.fromJson(jsonResponse);
      } else {
        return WorkoutResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }

  Future<WorkoutResponse?> deleteWorkout(int id) async {
    final String apiUrl = '${AppConfig.apiUrl}workout';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.delete(Uri.parse("$apiUrl?id=$id"));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return WorkoutResponse.fromJson(jsonResponse);
      } else {
        return WorkoutResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }
}
