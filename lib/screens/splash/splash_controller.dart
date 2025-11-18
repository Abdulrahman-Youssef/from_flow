import 'package:form_flow/core/data/constant/app_routes.dart';
import 'package:form_flow/repositories/auth_repository.dart';
import 'package:form_flow/service/auth_service.dart';
import 'package:get/get.dart';


class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  // This function runs as soon as the controllers is ready
  @override
  void onReady() {
    super.onReady();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    // 1. Check if a token exists in secure storage
    String? token = await _authService.getToken();

    if (token == null) {
      print("there is no token");

      // NO TOKEN: User has never logged in. Send to Login.
      Get.offAllNamed(AppRoutes.login); // Use your login route name
      return;
    }
    print("there is token");
    // 2. TOKEN EXISTS: Now we must verify it.
    try {
      // Try to get the user data using the token
      await _authRepository.getUser();

      // SUCCESS: Token is valid. Send to Home.
      Get.offAllNamed(AppRoutes.homePage); // Use your home route name
    } catch (e) {
      // FAILURE: Token is expired or invalid (e.g., 401 error).
      print("Token verification failed: $e");

      // Just in case, delete the bad token
      await _authService.logout();

      // Send to Login
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
