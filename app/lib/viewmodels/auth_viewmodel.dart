import 'package:flutter/cupertino.dart';

import '../config/app_config.dart';
import '../models/user/login_model.dart';
import '../models/user/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel {
  final AuthService _authService = AuthService();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String?> errorMessage = ValueNotifier(null);

  Future<LoginResponse?> login(String email, String password) async {
    try {
      isLoading.value = true;
      LoginRequest authRequest = LoginRequest(email: email, password: password);
      LoginResponse? response = await _authService.login(authRequest);

      AppConfig.saveToken(response?.token);
      AppConfig.saveUser(response?.user);

      return response;
    } catch (e) {
      errorMessage.value = "Error on login";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<UserResponse?> register(
      String name, String email, String password) async {
    try {
      isLoading.value = true;

      CreateUserRequest createUserRequest =
          CreateUserRequest(name: name, email: email, password: password);
      UserResponse? response = await _authService.register(createUserRequest);

      return response;
    } catch (e) {
      errorMessage.value = "Error on register";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }
}
