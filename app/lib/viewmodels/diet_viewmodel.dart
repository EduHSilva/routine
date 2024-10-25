import 'package:routine/models/health/workout_model.dart';
import 'package:routine/services/diet_service.dart';
import 'package:routine/services/workout_service.dart';
import 'package:flutter/cupertino.dart';

import '../config/app_config.dart';
import '../models/health/diet_model.dart';

class DietViewModel {
  final DietService _dietService = DietService();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String?> errorMessage = ValueNotifier(null);
  ValueNotifier<List<Food>> foods = ValueNotifier([]);
  ValueNotifier<List<Meal>> meals = ValueNotifier([]);

  Future<void> fetchFoods(search) async {
    try {
      foods.value = [];
      isLoading.value = true;
      List<Food> response = await _dietService.fetchFoods(search);
      foods.value = response;
    } catch (e) {
      errorMessage.value = "Error fetching foods";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<MealResponse?> deleteMeal(int id) async {
    try {
      isLoading.value = true;
      MealResponse? response = await _dietService.deleteMeal(id);
      if (response?.meal != null) {
        await fetchMeals();
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

  Future<void> fetchMeals() async {
    meals.value = [];
    try {
      isLoading.value = true;
      List<Meal> response = await _dietService.fetchMeals();
      meals.value = response;
    } catch (e) {
      errorMessage.value = "Error fetching meals";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<MealResponse?> getMeal(int id) async {
    try {
      isLoading.value = true;

      MealResponse? response = await _dietService.getMeal(id);

      if (response.meal == null) {
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

  Future<MealResponse?> addMeal(CreateMealRequest request) async {
    try {
      isLoading.value = true;
      MealResponse? response =
      await _dietService.addMeal(request);
      if (response?.meal != null) {
        await fetchMeals();
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

  Future<MealResponse?> editMeal(
      int id, UpdateMealRequest request) async {
    try {
      isLoading.value = true;
      MealResponse? response =
          await _dietService.editMeal(id, request);
      if (response?.meal != null) {
        await fetchMeals();
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
