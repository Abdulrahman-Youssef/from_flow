import 'package:form_flow/controllers/dropdown_data_controller.dart';
import 'package:form_flow/service/auth_service.dart';
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

    // this will be once because the data in no changing and its a waste of requests to
    // get the data every time we open the screen
    Get.put(DropDownDataController());
    // Get.lazyPut(() => DropDownDataController(), fenix: true);

    // 'fenix: true' ensures they are re-initialized
    // if they are ever removed from memory.
  }
}