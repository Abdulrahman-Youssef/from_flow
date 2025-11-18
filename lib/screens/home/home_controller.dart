import 'package:flutter/material.dart';
import 'package:form_flow/controllers/delivery_controller.dart';
import 'package:form_flow/core/data/constant/app_routes.dart';
import 'package:form_flow/models/responses/delivery_summary_response.dart';
import 'package:form_flow/models/user_model.dart';
import 'package:form_flow/service/user_service.dart';
import 'package:form_flow/screens/Dashboard/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final deliveryController = Get.find<DeliveryController>();

  final userService = Get.find<UserService>();

  late final UserModel user = userService.user!;

  // Observable variables
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'date'.obs; // 'date', 'name', 'trips'
  // final RxList<SupplyDeliveryData> deliveries = <SupplyDeliveryData>[].obs;
  // final RxList<DeliveryData> deliveries = homeScreenList.obs;
  final RxList<DeliverySummary> deliveries = <DeliverySummary>[].obs;

  // Getters
  List<DeliverySummary> get filteredDeliveries {
    List<DeliverySummary> filtered = deliveries.where((delivery) {
      bool matchesSearch = false;
      switch (sortBy.value) {
        case 'name':
          return matchesSearch = delivery.deliveryName
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());
        case 'date':
        default:
          return matchesSearch = DateFormat('dd/MM/yyyy')
              .format(delivery.deliveryDate)
              .contains(searchQuery.value); // Most recent first
      }

      return matchesSearch;
    }).toList();

    // Sort deliveries
    filtered.sort((a, b) {
      switch (sortBy.value) {
        case 'name':
          return a.deliveryName.compareTo(b.deliveryName);
        case 'trips':
          return b.tripsCount.compareTo(a.tripsCount);
        case 'date':
        default:
          return b.deliveryDate.compareTo(a.deliveryDate); // Most recent first
      }
    });

    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    loadDeliveries(); // call async method
    // loadUserInfo();
  }

  Future<void> loadDeliveries() async {
    deliveries.value = await deliveryController.handleDeliveriesSummary();
  }

  Future<void> _loadUserInfo() async {
    if (userService.user != null) {
      // user = userService.user!;
    } else {
      throw "user is empty";
    }
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

  // void setDeliveries(List<DeliveryData> newDeliveries) {
  //   deliveries.assignAll(newDeliveries);
  // }

  // void addDelivery(DeliveryData delivery) {
  //   Get.toNamed("Dashboard");
  //   deliveries.add(delivery);
  // }

  void removeDelivery(int deliveryID) async {
    if (await deliveryController.removeDelivery(deliveryID)) {
      deliveries.removeWhere((delivery) => delivery.deliveryId == deliveryID);
      Get.snackbar(
        'Success',
        'Delivery has been deleted "${deliveryID}" saved successfully!',
        // 'Delivery "{finalDelivery.name}" saved successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      throw "the delivery has problem in deleting";
    }
  }

  // put the edited
  void updateDelivery(int index, DeliverySummary delivery) {
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
    // to get the added delivery
    loadDeliveries();


  }

  // ✨ THIS IS THE METHOD TO CHANGE ✨
  Future<void> onEditeDelivery(int deliveryID) async {
    final deliveryController = Get.find<DeliveryController>();
    final deliveryData = await deliveryController.fetchDelivery(deliveryID);
    // 1. Await the result from the dashboard screen
    final result = await Get.toNamed(
      AppRoutes.dashboard,
      arguments: {
        "deliveryData": deliveryData,
        "mode": DashboardControllerMode.edit,
      },
    );
    // get the delivery and update that one
    loadDeliveries();

  }

  int getCrossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }
}
