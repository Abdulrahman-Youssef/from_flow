import 'package:flutter/material.dart';
import 'package:form_flow/core/data/constant/app_routes.dart';
import 'package:form_flow/widgets/dashboard_widgets/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:form_flow/models/shipment_model.dart';
import 'package:intl/intl.dart';
import '../../core/data/constant/Deliveries.dart';

class HomeController extends GetxController {
  // Observable variables
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'date'.obs; // 'date', 'name', 'trips'
  // final RxList<SupplyDeliveryData> deliveries = <SupplyDeliveryData>[].obs;
  final RxList<SupplyDeliveryData> deliveries = homeScreenList.obs;

  // Getters
  List<SupplyDeliveryData> get filteredDeliveries {
    List<SupplyDeliveryData> filtered = deliveries.where((delivery) {
      bool matchesSearch = false;
      switch (sortBy.value) {
        case 'name':
          return matchesSearch = delivery.name
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());
        case 'trips':
          return matchesSearch =
              delivery.trips.length.toString() == searchQuery.value;
        case 'date':
        default:
          return matchesSearch = DateFormat('dd/MM/yyyy')
              .format(delivery.date)
              .contains(searchQuery.value); // Most recent first
      }

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
    Get.toNamed("Dashboard");
    deliveries.add(delivery);
  }

  void removeDelivery(int deliveryID) {
    deliveries.removeWhere((delivery) => delivery.id == deliveryID);
  }

  // put the edited
  void updateDelivery(int index, SupplyDeliveryData delivery) {
    if (index >= 0 && index < deliveries.length) {
      deliveries[index] = delivery;
    }
  }

  Future<void> onAddNewDelivery() async {
    var result = await Get.toNamed(AppRoutes.dashboard, arguments: {
      // cuz it added new
      "data": null,
      "mode": DashboardControllerMode.addedNew,
    });
    if (result != null) {
      deliveries.add(result);

      Get.snackbar(
        'Success',
        'Delivery "${result.name}" saved successfully!',
        // 'Delivery "{finalDelivery.name}" saved successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // ✨ THIS IS THE METHOD TO CHANGE ✨
  Future<void> onEditeDelivery(SupplyDeliveryData data) async {
    // 1. Await the result from the dashboard screen
    final result = await Get.toNamed(
      AppRoutes.dashboard,
      arguments: {
        "data": data,
        "mode": DashboardControllerMode.edit,
      },
    );

    // 2. Check if the result is valid and update the list
    if (result != null && result is SupplyDeliveryData) {
      // Find the index of the old delivery data using its unique ID
      final index = deliveries.indexWhere((d) => d.id == result.id);

      // If found, update it in the list
      if (index != -1) {
        // This will automatically refresh your UI because `deliveries` is an .obs list!
        updateDelivery(index, result);
      }

      Get.snackbar(
        'Success',
        'Delivery "${result.name}" saved successfully!',
        // 'Delivery "{finalDelivery.name}" saved successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  int getCrossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }
}
