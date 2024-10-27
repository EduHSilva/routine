import 'dart:convert';

import 'package:routine/models/health/workout_model.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/health/diet_model.dart';


class DietService {
  Future<List<Food>> fetchFoods(search) async {
    http.Client client = await AppConfig.getHttpClient();
    final response = await client.get(Uri.parse(
        '${AppConfig.apiUrl}diet/meal/food?query=$search'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);


      List<Food> foods = [];

      if (data['data'] != null) {
        foods = List<Food>.from(data['data'].map((food) => Food.fromJson(food)));
      }

      return foods;
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<List<Meal>> fetchMeals() async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
        await client.get(Uri.parse('${AppConfig.apiUrl}diet/meals'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      List<Meal> diets = [];

      if (data['data'] != null) {
        diets =
            List<Meal>.from(data['data'].map((meal) => Meal.fromJson(meal)));
      }

      return diets;
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<MealResponse> getMeal(int id) async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
        await client.get(Uri.parse('${AppConfig.apiUrl}diet/meal?id=$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      MealResponse? dietResponse = MealResponse.fromJson(jsonResponse);

      return dietResponse;
    } else {
      throw Exception('Failed to load meal');
    }
  }

  Future<MealResponse?> addMeal(CreateMealRequest request) async {
    final String apiUrl = '${AppConfig.apiUrl}diet/meal';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.post(Uri.parse(apiUrl),
          body: jsonEncode(<String, dynamic>{
            'name': request.name,
            'foods': request.foods,
            'user_id': request.userID
          }));

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
    final String apiUrl = '${AppConfig.apiUrl}diet/meal';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.put(Uri.parse("$apiUrl?id=$id"),
          body: jsonEncode(<String, dynamic>{
            'name': request.name,
            'foods': request.foods,
          }));

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
    final String apiUrl = '${AppConfig.apiUrl}diet/meal';
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
