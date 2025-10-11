import 'package:form_flow/controller/dashboard_controller.dart';
import 'package:form_flow/models/shipment_model.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Get the arguments passed from Get.toNamed()
    final Map<String, dynamic> args = Get.arguments;

    // 2. Extract your data from the arguments map
    final SupplyDeliveryData? data = args['data'];
    final DashboardControllerMode mode = args['mode'];

    // 3. Create and register your controller with the dynamic data
    Get.put<DashboardController>(
      DashboardController(data: data, mode: mode),
    );
  }
}
