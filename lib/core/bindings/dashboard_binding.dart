import 'package:form_flow/models/delivery_model.dart';
import 'package:form_flow/repositories/delivery_repository.dart';
import 'package:form_flow/screens/Dashboard/dashboard_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Get the arguments passed from Get.toNamed()
    final Map<String, dynamic> args = Get.arguments;

    // 2. Extract your data from the arguments map
    final DeliveryData? deliveryData = args['deliveryData'];
    final DashboardControllerMode mode = args['mode'];

    // 3. Create and register your controllers with the dynamic data
    Get.put<DashboardController>(
      DashboardController(editDelivery: deliveryData, mode: mode),
    );

  }
}
