import 'package:form_flow/models/user_model.dart'; // Your User model
import 'package:get/get.dart';
import 'package:form_flow/repositories/auth_repository.dart'; // Your Repo

class AuthController extends GetxController {

  // --- DEPENDENCIES ---
  final AuthRepository _authRepository = Get.find();

  // --- STATE VARIABLES (The Data You Want Access To) ---

  /// Holds the app's initialization status for the splash screen.
  final RxBool isInitialized = false.obs;

  /// Holds the app's current login state.
  final RxBool isLoggedIn = false.obs;

  /// Holds the logged-in user's data.
  final Rx<UserModel?> user = Rx(null);

  // --- HELPER STATE (For UI) ---

  /// Holds the loading state for login/register functions.
  final RxBool isLoading = false.obs;

  // --- LIFECYCLE METHOD ---
  @override
  void onInit() {
    super.onInit();
    // Check if user is already logged in when the app starts
    _checkLoginStatus();
  }

  // --- PRIVATE METHODS ---

  /// Validates the stored token by fetching the user.
  void _checkLoginStatus() async {
    try {
      // Ask the "Kitchen" (Repo) to get the user
      // The ApiService interceptor automatically sends the saved token
      final userData = await _authRepository.getUser();

      // The repo returns the user map. We parse it.
      // Your repo's 'getUser' returns the user data directly.
      user.value = UserModel.fromJson(userData);
      isLoggedIn.value = true;

    } catch (e) {
      // If getUser fails (401 error, etc.), we are logged out.
      user.value = null;
      isLoggedIn.value = false;
      print("CheckLoginStatus Failed: $e");
    } finally {
      // Tell the splash screen it can stop spinning
      isInitialized.value = true;
    }
  }

  // --- PUBLIC METHODS (Called by the UI) ---

  /// Attempts to log in a user.
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      // 1. Call the "Kitchen" (Repo)
      final response = await _authRepository.login(email, password);

      // 2. The repo returns {'access_token': '...', 'user': {...}}
      //    We parse the 'user' part. (Adjust 'user' key if yours is different)
      user.value = UserModel.fromJson(response['user']);
      isLoggedIn.value = true;

      isLoading.value = false;
      // Get.offAll(() => HomeScreen()); // Navigate to home

    } catch (e) {
      isLoading.value = false;
      // 'e' is the clean error string from your repo's _handleDioException
      Get.snackbar("Login Failed", e.toString());
    }
  }

  /// Logs the user out.
  Future<void> logout() async {
    try {
      await _authRepository.logout(); // Tell "Kitchen" to log out
    } catch (e) {
      print("Error during server logout: $e");
    } finally {
      // ALWAYS clear the UI state
      user.value = null;
      isLoggedIn.value = false;
      // Get.offAll(() => LoginScreen()); // Navigate to login
    }
  }
}