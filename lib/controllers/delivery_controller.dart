import 'package:form_flow/models/responses/delivery_summary_response.dart';
import 'package:form_flow/repositories/delivery_repository.dart';
import 'package:get/get.dart';

class DeliveryController extends GetxController {
  final DeliveryRepository deliveryRepository = DeliveryRepository();

  Future<List<DeliverySummary>> handleDeliveriesSummary() async {
    // 1) Fetch raw JSON list
    final data = await deliveryRepository.fetchDeliveriesSummaryData();

    // 2) Convert List<dynamic> → List<DeliverySummary>
    List<DeliverySummary> deliveries = data
        .map<DeliverySummary>((item) => DeliverySummary.fromJson(item))
        .toList();

    return deliveries;
  }
}

