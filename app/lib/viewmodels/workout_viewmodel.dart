import 'package:app/models/health/workout_model.dart';
import 'package:app/services/workout_service.dart';
import 'package:flutter/cupertino.dart';

import '../config/app_config.dart';
import '../models/tasks/task_model.dart';

class WorkoutViewModel {
  final WorkoutService _workoutService = WorkoutService();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String?> errorMessage = ValueNotifier(null);
  ValueNotifier<List<Exercise>> exercises = ValueNotifier([]);
  ValueNotifier<List<Workout>> workouts = ValueNotifier([]);

  Future<void> fetchExercises() async {
    try {
      exercises.value = [];
      isLoading.value = true;
      List<Exercise> response = await _workoutService.fetchExercises();
      exercises.value = response;
    } catch (e) {
      errorMessage.value = "Error fetching exercises";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<WorkoutResponse?> deleteWorkout(int id) async {
    try {
      isLoading.value = true;
      WorkoutResponse? response = await _workoutService.deleteWorkout(id);
      if (response?.workout != null) {
        await fetchWorkouts();
      } else {
        errorMessage.value = response?.message;
      }
      return response;
    } catch (e) {
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<void> fetchWorkouts() async {
    workouts.value = [];
    try {
      isLoading.value = true;
      List<Workout> response = await _workoutService.fetchWorkouts();
      workouts.value = response;
    } catch (e) {
      errorMessage.value = "Error fetching workoutss";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<WorkoutResponse?> getWorkout(int id) async {
    try {
      isLoading.value = true;

      WorkoutResponse? response = await _workoutService.getWorkout(id);

      if (response.workout == null) {
        errorMessage.value = response.message;
      }

      return response;
    } catch (e) {
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<WorkoutResponse?> editWorkout(
      int id, UpdateTaskRequest request) async {
    try {
      isLoading.value = true;
      WorkoutResponse? response =
          await _workoutService.editWorkout(id, request);
      if (response?.workout != null) {
        await fetchWorkouts();
      } else {
        errorMessage.value = errorMessage.value = response?.message;
      }
      return response;
    } catch (e) {
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }
}
