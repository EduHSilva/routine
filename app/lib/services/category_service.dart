import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/tasks/category_model.dart';

class CategoryService {
  Future<CategoryResponse?> createCategory(
      CreateCategoryRequest createCategoryRequest) async {
    final String apiUrl = '${AppConfig.apiUrl}category';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.post(
        Uri.parse(apiUrl),
        body: jsonEncode(<String, dynamic>{
          'title': createCategoryRequest.title,
          'user_id': createCategoryRequest.userID,
          'color': createCategoryRequest.color,
          'type': createCategoryRequest.type
        }),
      );

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return CategoryResponse.fromJson(jsonResponse);
      } else {
        return CategoryResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }

  Future<List<Category>> fetchCategories(String? type) async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
        await client.get(Uri.parse('${AppConfig.apiUrl}categories?type=$type'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      List<Category> categories = [];

      if (data['data'] != null) {
        categories = List<Category>.from(data['data']
            .map((categoryData) => Category.fromJson(categoryData)));
      }

      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<CategoryResponse> getCategory(int id) async {
    http.Client client = await AppConfig.getHttpClient();
    final response =
        await client.get(Uri.parse('${AppConfig.apiUrl}category?id=$id'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      CategoryResponse? category = CategoryResponse.fromJson(jsonResponse);

      return category;
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<CategoryResponse?> deleteCategory(int id) async {
    final String apiUrl = '${AppConfig.apiUrl}category';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.delete(Uri.parse("$apiUrl?id=$id"));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return CategoryResponse.fromJson(jsonResponse);
      } else {
        return CategoryResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }

  Future<CategoryResponse?> editCategory(
      int id, String title, String color) async {
    final String apiUrl = '${AppConfig.apiUrl}category';
    http.Client client = await AppConfig.getHttpClient();

    try {
      final response = await client.put(Uri.parse("$apiUrl?id=$id"),
          body: jsonEncode(<String, dynamic>{
            'title': title,
            'color': color,
          }));

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        return CategoryResponse.fromJson(jsonResponse);
      } else {
        return CategoryResponse(message: jsonResponse['message']);
      }
    } catch (e) {
      AppConfig.getLogger().e(e);
      return null;
    }
  }
}
