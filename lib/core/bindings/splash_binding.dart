import 'package:form_flow/screens/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // We use lazyPut because the controllers will be created by the GetPage
    Get.put<SplashController>(SplashController());
  }
}

