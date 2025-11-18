import 'package:form_flow/controllers/dropdown_data_controller.dart';
import 'package:form_flow/service/auth_service.dart';
import 'package:form_flow/repositories/api_repository.dart';
import 'package:form_flow/service/shared_pref_service.dart';
import 'package:form_flow/service/user_service.dart';
import 'package:get/get.dart';
import 'package:form_flow/repositories/auth_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Use lazyPut for global singletons
    Get.lazyPut(() => ApiRepository(), fenix: true);
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => AuthRepository(), fenix: true);

    // this will be once because the data in no changing and its a waste of requests to
    // get the data every time we open the screen
    Get.put(DropDownDataController());
    // Get.lazyPut(() => DropDownDataController(), fenix: true);

    Get.lazyPut(()=>UserService());

    // 'fenix: true' ensures they are re-initialized
    // if they are ever removed from memory.
  }
}
