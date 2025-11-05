import 'package:form_flow/screens/login/login_controller.dart';
import 'package:get/get.dart';

class LoginBinding extends Bindings{


  @override
  void dependencies() {
    Get.lazyPut(()=>LoginScreenController());
  }

}