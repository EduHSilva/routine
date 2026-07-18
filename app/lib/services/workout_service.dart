import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../models/health/workout_model.dart';


class WorkoutService {
  String get _workoutsCacheKey => 'cached_workouts_${AppConfig.user?.id ?? 'guest'}';

  Future<List<Workout>> _cachedWorkouts() async {
    final saved = (await SharedPreferences.getInstance()).getString(_workoutsCacheKey);
    if (saved == null) return [];
    final data = jsonDecode(saved) as Map<String, dynamic>;
    final workouts = data['data'] as List? ?? [];
    return workouts.map((workout) => Workout.fromJson(workout as Map<String, dynamic>)).toList();
  }

  Future<List<Exercise>> fetchExercises() async {
    http.Client client = await AppConfig.getHttpClient();
    final response = await client.get(Uri.parse(
        '${AppConfig.apiUrl}/fitness/workout/exercises'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);


      List<Exercise> exercises = [];

      if (data['data'] != null) {
        exercises = List<Exercise>.from(data['data'].map((exe) => Exercise.fromJson(exe)));
      }

      return exercises;
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<List<Workout>> fetchWorkouts() async {
    try {
      final client = await AppConfig.getHttpClient();
      final response = await client.get(Uri.parse('${AppConfig.apiUrl}/fitness/workouts'));
      if (response.statusCode != 200) throw Exception('Failed to load workouts');
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      await (await SharedPreferences.getInstance()).setString(_workoutsCacheKey, response.body);
      AppConfig.isOffline.value = false;
      final workouts = data['data'] as List? ?? [];
      return workouts.map((workout) => Workout.fromJson(workout as Map<String, dynamic>)).toList();
    } catch (_) {
      final cached = await _cachedWorkouts();
      if (cached.isNotEmpty) {
        AppConfig.isOffline.value = true;
        return cached;
      }
      rethrow;
    }
  }

  Future<WorkoutResponse> getWorkout(int id) async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
        await client.get(Uri.parse('${AppConfig.apiUrl}/fitness/workout?id=$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      WorkoutResponse? workoutResponse = WorkoutResponse.fromJson(jsonResponse);

      return workoutResponse;
    } else {
      throw Exception('Failed to load workout');
    }
  }

  Future<WorkoutResponse?> addWorkout(CreateWorkoutRequest request) async {
    final String apiUrl = '${AppConfig.apiUrl}/fitness/workout';
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
    final String apiUrl = '${AppConfig.apiUrl}/fitness/workout';
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
    final String apiUrl = '${AppConfig.apiUrl}/fitness/workout';
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
