import 'package:form_flow/models/API/delivery_api_model.dart';
import 'package:form_flow/models/delivery_model.dart';
import 'package:form_flow/models/responses/delivery_summary_response.dart';
import 'package:form_flow/repositories/delivery_repository.dart';
import 'package:get/get.dart';

class DeliveryController extends GetxController {
  final DeliveryRepository _deliveryRepository = Get.find<DeliveryRepository>();

  Future<List<DeliverySummary>> handleDeliveriesSummary() async {
    final data = await _deliveryRepository.fetchDeliveriesSummaryData();

    return data
        .map<DeliverySummary>((item) => DeliverySummary.fromJson(item))
        .toList();
  }

  Future<int> handleCreateUpdateDelivery(DeliveryApiModel delivery) async {
    // check if create or update
    if (delivery.id == null) {
    print("creating new delivery");
      final response = await _deliveryRepository.createDelivery(delivery);
      if (response.containsKey("delivery_id")) {
        return response["delivery_id"];
      } else {
        return -1; // failed
      }
    } else {
      print("update new delivery");
      final response = await _deliveryRepository.updateDelivery(delivery);
      if (response.containsKey("delivery_id")) {
        return response["delivery_id"];
      } else {
        return -1; // failed
      }
    }
  }

  Future<DeliveryData> fetchDelivery(int deliveryID) async {
    return DeliveryData.fromJson(await _deliveryRepository.fetchDelivery(deliveryID));
  }


  Future<int> updateDelivery(DeliveryApiModel delivery)async{
    final  response = await _deliveryRepository.updateDelivery(delivery);
    if (response.containsKey("delivery_id")) {
      return response["delivery_id"];
    } else {
      return -1; // failed
    }
  }








  Future<bool> removeDelivery(int deliveryID) async {
    return await _deliveryRepository.removeDelivery(deliveryID);
  }
}
