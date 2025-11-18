import 'package:form_flow/controllers/delivery_controller.dart';
import 'package:form_flow/repositories/delivery_repository.dart';
import 'package:form_flow/screens/home/home_controller.dart';
import 'package:get/get.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=>DeliveryRepository() , fenix: true);
    Get.lazyPut(()=>DeliveryController());
    Get.lazyPut(() => HomeController());

  }
}
