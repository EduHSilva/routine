import 'package:flutter/cupertino.dart';
import '../config/app_config.dart';
import '../models/tasks/category_model.dart';
import '../services/category_service.dart';

class CategoryViewModel {
  final CategoryService _categoryService = CategoryService();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String?> errorMessage = ValueNotifier(null);
  ValueNotifier<List<Category>> categories = ValueNotifier([]);

  Future<void> fetchCategories(String? type) async {
    try {
      categories.value = [];
      isLoading.value = true;
      List<Category> response = await _categoryService.fetchCategories(type);
      categories.value = response;
    } catch (e) {
      errorMessage.value = "Error fetching categories";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<CategoryResponse?> createCategory(String title, String color, String type) async {
    try {
      isLoading.value = true;
      CreateCategoryRequest categoryRequest =
          CreateCategoryRequest(title: title, color: color, type: type);
      CategoryResponse? response =
          await _categoryService.createCategory(categoryRequest);
      if (response?.category != null) {
        await fetchCategories('all');
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

  Future<CategoryResponse?> deleteCategory(int id) async {
    try {
      isLoading.value = true;
      CategoryResponse? response = await _categoryService.deleteCategory(id);
      if (response?.category != null) {
        await fetchCategories('all');
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

  Future<CategoryResponse?> editCategory(
      int id, String title, String color) async {
    try {
      isLoading.value = true;
      CategoryResponse? response =
          await _categoryService.editCategory(id, title, color);
      if (response?.category != null) {
        await fetchCategories('all');
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

  Future<CategoryResponse?> getCategory(int id) async {
    try {
      isLoading.value = true;

      CategoryResponse? response = await _categoryService.getCategory(id);

      if (response.category == null) {
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
}
