import 'package:get/get.dart';
import 'models/supplier_data.dart';

class AppController extends GetxController {
  var isLoggedIn = false.obs;

  var selectedDate = DateTime.now().add(Duration(days: 1)).obs;

  void login() {
    isLoggedIn.value = true;
  }

  void logout() {
    isLoggedIn.value = false;
  }
}
