import 'package:flutter/material.dart';
import 'package:form_flow/core/data/constant/trips_data_dashboard_temp.dart';
import 'package:form_flow/models/shipment_model.dart';
import 'package:form_flow/models/trip_data.dart';
import 'package:form_flow/widgets/add_edit_dialog.dart';
import 'package:get/get.dart';
enum DashboardControllerMode {
  addedNew,
  edit,
}

class DashboardController extends GetxController {
  // var trips = TripsTempData.tripsTempData.obs;
  var trips = <TripData >[].obs;
  String? deliveryName;
  DateTime? deliveryDate;
  final DashboardControllerMode mode;
  final SupplyDeliveryData? data ;
  DashboardController({this.data, required this.mode});

  @override
  void onInit() {
    super.onInit();
    if (mode == DashboardControllerMode.edit){
      trips.assignAll(data!.trips);
      deliveryName = data!.name;
      deliveryDate = data!.date;
    }
    deliveryName = "delivery Name";
    deliveryDate = DateTime.now();

  }

  var selectedDate = DateTime
      .now()
      .add(Duration(days: 1))
      .obs;

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  void showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEditDialog(mode: DialogMode.add),
    );
  }

  void showEditDialog(TripData record, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AddEditDialog(
            mode: DialogMode.edit,
            editData: record,
          ),
    );
  }

  // when delete too fast teh dialog glitching and do not disappear
  void showDeleteDialog(TripData record) {
    Get.defaultDialog(
      title: 'Delete Record',
      middleText:
      'This will permanently delete the record for suppliers ${record.suppliers
          .map((sup) {
        return " ${sup.supplierName} ";
      })} with Car ID ${record.vehicleCode}. This action cannot be undone.',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        deleteRecord(record.id!);
        Get.back();
        Get.snackbar(
          'Success',
          'Record for suppliers ${record.suppliers.map((sup) {
            return " ${sup.supplierName} ";
          })} deleted successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      },
    );
  }

  void handleCopy(int id) {
    copyRecord(id);
    Get.snackbar(
      'Success',
      'Record copied successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void handleSave() {
    Get.snackbar(
      'Success',
      'All records saved successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void deleteRecord(int id) {
    trips.removeWhere((item) => item.id == id);
  }

  void copyRecord(int id) {
    final record = trips.firstWhere((item) => item.id == id);
    final newId = trips.isEmpty
        ? 1
        : trips.map((e) => e.id).reduce((a, b) => a! > b! ? a : b)! + 1;
    final copiedRecord = record.copyWith(
      id: newId,
      vehicleCode: record.vehicleCode,
    );
    trips.add(copiedRecord);
  }

  void addRecord(TripData record) {
    final newId = trips.isEmpty
        ? 1
        : trips.map((tripData) => tripData.id).reduce(
            (maximumValue, nextValue) =>
        maximumValue! > nextValue! ? maximumValue : nextValue)! +
        1;
    trips.add(record.copyWith(id: newId));
  }

  void updateRecord(TripData record) {
    final index = trips.indexWhere((item) => item.id == record.id);
    if (index != -1) {
      trips[index] = record;
    }
  }
}
