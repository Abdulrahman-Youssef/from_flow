import 'package:flutter/material.dart';
import 'package:form_flow/controller/home_controller.dart';
import 'package:form_flow/core/data/constant/app_routes.dart';
import 'package:form_flow/repositories/auth_repository.dart';
import 'package:get/get.dart';

class LoginScreenController extends GetxController {
  // --- Dependencies ---
  // Get.find() will get the AuthRepository you defined in your Bindings
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  // --- State Variables ---
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // 1. ADD STATE: Use .obs to make these observable by the UI
  var isLoading = false.obs;
  var errorMessage = ''.obs; // To store and display errors

  // --- Logic ---
  // 2. MAKE IT ASYNC
  Future<void> handleLogin() async {
    // 3. VALIDATE FIRST
    if (!formKey.currentState!.validate()) {
      return; // If form is invalid, stop here
    }

    // 4. USE TRY/CATCH/FINALLY
    try {
      // 5. SET LOADING STATE
      isLoading.value = true;
      errorMessage.value = ''; // Clear any previous errors

      // 6. AWAIT THE LOGIN
      // This will 'pause' the function until the API call is done
      await _authRepository.login(
        usernameController.text,
        passwordController.text,
      );

      // 7. HANDLE SUCCESS
      // This code only runs if the 'await' line does NOT throw an error
      Get.lazyPut<HomeController>(() => HomeController());
      // Use offAllNamed to clear the login screen from the stack
      Get.offAllNamed(AppRoutes.homePage);

    } catch (e) {
      // 8. HANDLE FAILURE
      // The repository will throw a clean error message
      errorMessage.value = e.toString();
      Get.snackbar(
        'Login Failed',
        e.toString(), // This is the clean error from _handleDioException
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      // 9. ALWAYS STOP LOADING
      // This runs whether the login succeeded or failed
      isLoading.value = false;
    }
  }

  // --- Cleanup ---
  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}