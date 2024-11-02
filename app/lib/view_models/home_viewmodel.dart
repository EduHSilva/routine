import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../config/app_config.dart';
import '../models/health/diet_model.dart';
import '../models/response.dart';
import '../models/tasks/task_model.dart';
import '../services/home_service.dart';

class HomeViewModel {
  final HomeService _homeService = HomeService();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String?> errorMessage = ValueNotifier(null);
  ValueNotifier<String> searchValue = ValueNotifier('welcomeMessage'.tr());
  ValueNotifier<List<Task>> tasks = ValueNotifier([]);
  ValueNotifier<Meal?> nextMeal = ValueNotifier(null);


  Future<void> searchGPT(String search) async {
    try {
      searchValue.value = '';
      isLoading.value = true;
      String response = await _homeService.search(search);
      searchValue.value = response;
    } catch (e) {
      errorMessage.value = "Error fetching gpt response";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getDailyData() async {
    try {
      tasks.value = [];
      nextMeal.value = null;
      isLoading.value = true;
      HomeDailyResponse response = await _homeService.getDailyData();

      tasks.value = response.tasks!;

      nextMeal.value = response.nextMeal;
    } catch (e) {
      errorMessage.value = "Error fetching daily data";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
  }
}
