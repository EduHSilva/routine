import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../config/app_config.dart';
import '../services/home_service.dart';

class HomeViewModel {
  final HomeService _homeService = HomeService();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String?> errorMessage = ValueNotifier(null);
  ValueNotifier<String> searchValue = ValueNotifier('welcomeMessage'.tr());

  Future<void> searchGPT(String search) async {
    try {
      searchValue.value = '';
      isLoading.value = true;
      String response = await _homeService.search(search);
      searchValue.value = response;
    } catch (e) {
      errorMessage.value = "Error fetching categories";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
  }
}
