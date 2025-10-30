import "package:get/get.dart";

import '../routes/app_routes.dart';
import '../services/api_service.dart';


class AuthController extends GetxController {
  AuthController({ApiService? apiService}) : _api = apiService ?? ApiService();

  final ApiService _api;
  final RxBool isLoading = false.obs;
  final RxnString token = RxnString();

  
  Future<void> login(String username, String password) async {
    isLoading.value = true;
    try {
      final String t = await _api.login(username: username, password: password);
      token.value = t;
      Get.offAllNamed(AppRoutes.products);
    } catch (e) {
      Get.snackbar('Login failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  
  Future<void> signup({required String email, required String username, required String password}) async {
    isLoading.value = true;
    try {
      final bool ok = await _api.signup(email: email, username: username, password: password);
      if (ok) {
        Get.snackbar('Signup successful', 'You can now login.');
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.snackbar('Signup failed', 'Please try again later.');
      }
    } catch (e) {
      Get.snackbar('Signup failed', '$e');
    } finally {
      isLoading.value = false;
    }
  }

  
  void logout() {
    token.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

  
  Future<void> forgotPassword(String email) async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.snackbar('Email sent', 'If $email exists, instructions were sent.');
    Get.toNamed(AppRoutes.resetPassword);
  }

  Future<void> resetPassword({required String email, required String newPassword}) async {
    isLoading.value = true;
    await Future<void>.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    Get.snackbar('Password reset', 'You can now login with the new password.');
    Get.offAllNamed(AppRoutes.login);
  }
}


