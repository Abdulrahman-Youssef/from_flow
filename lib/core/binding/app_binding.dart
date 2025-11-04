import 'package:form_flow/service/AuthenticationService.dart';
import 'package:form_flow/service/api_service.dart';
import 'package:get/get.dart';
import 'package:form_flow/repositories/auth_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Use lazyPut for global singletons
    Get.lazyPut(() => ApiService(), fenix: true);
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => AuthRepository(), fenix: true);

    // 'fenix: true' ensures they are re-initialized
    // if they are ever removed from memory.
  }
}