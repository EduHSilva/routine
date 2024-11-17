import 'package:flutter/cupertino.dart';

import '../config/app_config.dart';
import '../models/user/login_model.dart';
import '../models/user/user_model.dart';
import '../services/user_service.dart';

class UserViewModel {
  final UserService _userService = UserService();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<String?> errorMessage = ValueNotifier(null);

  Future<LoginResponse?> login(String email, String password) async {
    try {
      isLoading.value = true;
      LoginRequest authRequest = LoginRequest(email: email, password: password);
      LoginResponse? response = await _userService.login(authRequest);

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
      UserResponse? response = await _userService.register(createUserRequest);

      return response;
    } catch (e) {
      errorMessage.value = "Error on register";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }

  Future<UserResponse?> getUser(int id) async {
    try {
      isLoading.value = true;

      UserResponse? response = await _userService.getUser(id);

      if (response?.user == null) {
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

  Future<UserResponse?> updateUser(
      int id, String name, String email, String? photo) async {
    try {
      isLoading.value = true;

      UpdateUserRequest userRequest =
          UpdateUserRequest(name: name, email: email, photo: photo);
      UserResponse? response = await _userService.updateUser(userRequest, id);

      return response;
    } catch (e) {
      errorMessage.value = "Error on update user";
      AppConfig.getLogger().e(e);
    } finally {
      isLoading.value = false;
    }
    return null;
  }
}
