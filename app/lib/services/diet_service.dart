import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import '../models/health/diet_model.dart';

class DietService {
  String get _mealsCacheKey => 'cached_meals_${AppConfig.user?.id ?? 'guest'}';

  Future<List<Meal>> _cachedMeals() async {
    final saved = (await SharedPreferences.getInstance()).getString(_mealsCacheKey);
    if (saved == null) return [];
    final data = jsonDecode(saved) as Map<String, dynamic>;
    final meals = data['data'] as List? ?? [];
    return meals.map((meal) => Meal.fromJson(meal as Map<String, dynamic>)).toList();
  }

  Future<List<Food>> fetchFoods(search) async {
    http.Client client = await AppConfig.getHttpClient();
    final response = await client.get(
        Uri.parse('${AppConfig.apiUrl}/fitness/diet/meal/food?query=$search'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      List<Food> foods = [];

      if (data['data'] != null) {
        foods =
            List<Food>.from(data['data'].map((food) => Food.fromJson(food)));
      }

      return foods;
    } else {
      throw Exception('Failed to load foods');
    }
  }

  Future<List<Meal>> fetchMeals() async {
    try {
      final client = await AppConfig.getHttpClient();
      final response = await client.get(Uri.parse('${AppConfig.apiUrl}/fitness/diet/meals'));
      if (response.statusCode != 200) throw Exception('Failed to load meals');
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      await (await SharedPreferences.getInstance()).setString(_mealsCacheKey, response.body);
      AppConfig.isOffline.value = false;
      final meals = data['data'] as List? ?? [];
      return meals.map((meal) => Meal.fromJson(meal as Map<String, dynamic>)).toList();
    } catch (_) {
      final cached = await _cachedMeals();
      if (cached.isNotEmpty) {
        AppConfig.isOffline.value = true;
        return cached;
      }
      rethrow;
    }
  }

  Future<MealResponse> getMeal(int id) async {
    http.Client client = await AppConfig.getHttpClient();
    final response = await client
        .get(Uri.parse('${AppConfig.apiUrl}/fitness/diet/meal?id=$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      MealResponse? dietResponse = MealResponse.fromJson(jsonResponse);

      return dietResponse;
    } else {
      throw Exception('Failed to load meal');
    }
  }

  Future<MealResponse?> addMeal(CreateMealRequest request) async {
    final String apiUrl = '${AppConfig.apiUrl}/fitness/diet/meal';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.post(Uri.parse(apiUrl),
          body: jsonEncode(request.toJson()));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return MealResponse.fromJson(jsonResponse);
      } else {
        return MealResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }

  Future<MealResponse?> editMeal(int id, UpdateMealRequest request) async {
    final String apiUrl = '${AppConfig.apiUrl}/fitness/diet/meal';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.put(Uri.parse("$apiUrl?id=$id"),
          body: jsonEncode(request.toJson()));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return MealResponse.fromJson(jsonResponse);
      } else {
        return MealResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }

  Future<MealResponse?> deleteMeal(int id) async {
    final String apiUrl = '${AppConfig.apiUrl}/fitness/diet/meal';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.delete(Uri.parse("$apiUrl?id=$id"));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return MealResponse.fromJson(jsonResponse);
      } else {
        return MealResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }
}
