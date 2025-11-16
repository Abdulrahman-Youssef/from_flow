import 'package:form_flow/models/user_model.dart';
import 'package:form_flow/service/auth_service.dart';
import 'package:get/get.dart';
import 'models/supplier_data.dart';

class AppController extends GetxController {
  static late UserModel user;
  var isLoggedIn = false.obs;
  AuthService authService = AuthService();
  void login() {
    isLoggedIn.value = true;
  }

  void logout() {
  authService.logout();
  }
}
