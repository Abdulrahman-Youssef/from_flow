import 'package:get/get.dart';
import 'package:form_flow/models/shipment_model.dart';
import 'package:intl/intl.dart';

import '../core/data/constant/Deliveries.dart';

class HomeController extends GetxController {
  // Observable variables
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'date'.obs; // 'date', 'name', 'trips'
  // final RxList<SupplyDeliveryData> deliveries = <SupplyDeliveryData>[].obs;
  final RxList<SupplyDeliveryData> deliveries = homeScreenList.obs;

  // Getters
  List<SupplyDeliveryData> get filteredDeliveries {
    var filtered = deliveries.where((delivery) {
      final matchesSearch = delivery.name
          .toLowerCase()
          .contains(searchQuery.value.toLowerCase()) ||
          DateFormat('dd/MM/yyyy')
              .format(delivery.date)
              .contains(searchQuery.value);
      return matchesSearch;
    }).toList();

    // Sort deliveries
    filtered.sort((a, b) {
      switch (sortBy.value) {
        case 'name':
          return a.name.compareTo(b.name);
        case 'trips':
          return b.tripsCount.compareTo(a.tripsCount);
        case 'date':
        default:
          return b.date.compareTo(a.date); // Most recent first
      }
    });

    return filtered;
  }

  // Methods
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateSortBy(String? value) {
    if (value != null) {
      sortBy.value = value;
    }
  }

  void setDeliveries(List<SupplyDeliveryData> newDeliveries) {
    deliveries.assignAll(newDeliveries);
  }

  void addDelivery(SupplyDeliveryData delivery) {
    deliveries.add(delivery);
  }

  void removeDelivery(SupplyDeliveryData delivery) {
    deliveries.remove(delivery);
  }

  void updateDelivery(int index, SupplyDeliveryData delivery) {
    if (index >= 0 && index < deliveries.length) {
      deliveries[index] = delivery;
    }
  }

  int getCrossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }
}