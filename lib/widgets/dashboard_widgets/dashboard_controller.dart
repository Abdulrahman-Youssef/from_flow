import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:form_flow/models/delivery_model.dart';
import 'package:form_flow/models/trip_data.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/add_edit_dialog.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/add_edit_dialog_controller.dart';
import 'package:get/get.dart';

enum DashboardControllerMode {
  addedNew,
  edit,
}

class DashboardController extends GetxController {
  var trips = <TripData>[].obs;

  // 1. Make deliveryName reactive
  RxString deliveryName = ''.obs;

  DateTime? deliveryDate;
  final DashboardControllerMode mode;
  late SupplyDeliveryData? delivery;

  DashboardController({this.delivery, required this.mode});

  var selectedDate = DateTime.now().add(Duration(days: 1)).obs;

  @override
  void onInit() {
    super.onInit();
    if (mode == DashboardControllerMode.edit) {
      trips.assignAll(delivery!.trips);
      // 2. Assign to .value
      deliveryName.value = delivery!.name;
      deliveryDate = delivery!.date;
    } else {
      // 2. Assign to .value
      deliveryName.value = "Delivery Name";
      deliveryDate = DateTime.now();
    }
  }

  // 3. Add this new method to show the edit dialog
  void showEditNameDialog() {
    // A controllers to manage the text field's state
    final textController = TextEditingController(text: deliveryName.value);

    Get.defaultDialog(
      title: 'Edit Delivery Name',
      content: TextField(
        controller: textController,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'New Name',
          border: OutlineInputBorder(),
        ),
      ),
      textCancel: 'Cancel',
      textConfirm: 'Save',
      confirmTextColor: Colors.white,
      onConfirm: () {
        // Update the deliveryName with the text from the TextField
        if (textController.text.isNotEmpty) {
          deliveryName.value = textController.text;
          // delivery?.name =   textController.text;
        }
        if (delivery != null) {
          delivery = delivery!.copyWith(name: textController.text);
        }

        Get.back(closeOverlays: false); // Close the dialog
      },
    );
  }

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  void showAddDialog(BuildContext context)async {

    Get.put(AddEditDialogController(mode: DialogMode.add));

   await  Get.dialog(
      const AddEditDialog(),
    );
    Get.delete<AddEditDialogController>();

  }

  void showEditDialog(TripData record, BuildContext context)async {

    Get.put(AddEditDialogController(mode: DialogMode.edit ,editData: record ));

   await Get.dialog(
      const AddEditDialog(),
    );

   Get.delete<AddEditDialogController>();
  }

  // ... (the rest of your controllers code remains the same)
  void showDeleteDialog(TripData record) {
    Get.defaultDialog(
      title: 'Delete Record',
      middleText:
          'This will permanently delete the record for suppliers ${record.suppliers.map((sup) {
        return " ${sup.supplierName} ";
      })} with Car ID ${record.vehicleCode}. This action cannot be undone.',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        deleteRecord(record.id!);
        Get.back(closeOverlays: false);
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
      duration: 650.milliseconds,
      'Success',
      'Record copied successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

// In DashboardController
// In DashboardController.dart

  void saveAndExit() {
    SupplyDeliveryData finalDelivery;

    // Check which mode we are in
    if (mode == DashboardControllerMode.edit) {
      // EDIT MODE: Use the existing logic with the original delivery object
      if (delivery == null) {
        print("Error: In Edit Mode but no delivery data was provided.");
        return; // Safety check
      }
      finalDelivery = delivery!.copyWith(
        name: deliveryName.value,
        date: deliveryDate,
        // Make sure this is updated, e.g., selectedDate.value
        trips: trips.toList(),
      );
    } else {
      // ADD NEW MODE: Create a brand new SupplyDeliveryData object
      finalDelivery = SupplyDeliveryData(
        // Generate a unique ID for the new delivery
        id: DateTime.now().millisecondsSinceEpoch,
        name: deliveryName.value,
        date: deliveryDate!,
        // Make sure this is set
        trips: trips.toList(),
        createdBy: 'Ahmed',
      );
    }

    // Return the new or updated object to the previous screen
    Get.back(
      result: finalDelivery,
      closeOverlays: true,
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
