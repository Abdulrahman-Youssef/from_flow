import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_flow/models/delivery_model.dart';
import 'package:form_flow/models/trip_data.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/add_edit_dialog.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/add_edit_dialog_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

enum DashboardControllerMode {
  addedNew,
  edit,
}

class DashboardController extends GetxController {
  final trips = <TripData>[].obs;

  // 1. Make deliveryName reactive
  RxString deliveryName = ''.obs;

  // related to table header
  final totalSuppliers = 0.obs;

  final totalStorages = 0.obs;

  // DateTime? selectedDeliveryDate;
  final DashboardControllerMode mode;
  late DeliveryData? delivery;

  DashboardController({this.delivery, required this.mode});

   final Rx<DateTime> selectedDeliveryDate = DateTime(0).obs;


  @override
  void onInit() {
    super.onInit();
    if (mode == DashboardControllerMode.edit) {
      trips.assignAll(delivery!.trips);
      // 2. Assign to .value
      deliveryName.value = delivery!.name;
      selectedDeliveryDate.value = delivery!.date;
    } else {
      // 2. Assign to .value
      deliveryName.value = "Delivery Name";
      selectedDeliveryDate.value = DateTime.now().add(Duration(days: 1));
    }
    // will run any way anyway
    getTotalSuppliers();
    getTotalStorages();
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

  void setSelectedDeliveryDate(DateTime date) {
    selectedDeliveryDate.value = date;
  }

  void showAddDialog(BuildContext context) async {
    Get.put(AddEditDialogController(mode: DialogMode.add));

    await Get.dialog(
      const AddEditDialog(),
    );
    Get.delete<AddEditDialogController>();
  }

  void showEditDialog(TripData record, BuildContext context) async {
    Get.put(AddEditDialogController(mode: DialogMode.edit, editData: record));

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
    DeliveryData finalDelivery;

    // Check which mode we are in
    if (mode == DashboardControllerMode.edit) {
      // EDIT MODE: Use the existing logic with the original delivery object
      if (delivery == null) {
        print("Error: In Edit Mode but no delivery data was provided.");
        return; // Safety check
      }
      finalDelivery = delivery!.copyWith(
        name: deliveryName.value,
        date: selectedDeliveryDate.value,
        // Make sure this is updated, e.g., selectedDate.value
        trips: trips.toList(),
      );
    } else {
      // ADD NEW MODE: Create a brand new SupplyDeliveryData object
      finalDelivery = DeliveryData(
        // Generate a unique ID for the new delivery
        id: DateTime.now().millisecondsSinceEpoch,
        name: deliveryName.value,
        date: selectedDeliveryDate.value ,
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

  // ----------------------------- table logic ----------------------------

  void sortTripsByDateInSupplier() {
    // he may not know the actual arrive date so plan arrive date is always there and more efficient
    trips.sort((a, b) => a.suppliers.first.planArriveDate!
        .compareTo(b.suppliers.first.planArriveDate!));
    // setState(() {});
  }

  void getTotalSuppliers() {
    int totalCount = 0;

    if (trips.isEmpty) return;

    for (var trip in trips) {
      totalCount += trip.suppliers.length;
    }
    totalSuppliers.value = totalCount;
  }

  void getTotalStorages() {
    int totalCount = 0;

    if (trips.isEmpty) return;

    for (var trip in trips) {
      totalCount += trip.storages.length;
    }
    totalStorages.value = totalCount;
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  Future<void> handleExport(BuildContext context) async {
    try {
      final String csvContent = generateCsvContent();

      String? savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save CSV Export',
        fileName:
        'supply-chain-trips-${DateFormat('yyyy-MM-dd').format(selectedDeliveryDate.value)}.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (savePath == null || savePath.isEmpty) {
        return;
      }

      if (!savePath.endsWith('.csv')) {
        savePath = '$savePath.csv';
      }

      final file = File(savePath);
      await file.writeAsString(csvContent);

      Get.snackbar(
        'Success',
        'Excel file exported successfully to: ${file.path}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error exporting file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String generateCsvContent() {
    final headers = [
      'Trip #',
      'Vehicle NO',
      'Storage Name',
      'Procurement Specialist',
      'Fleet Supervisor',
      'Suppliers Count',
      'Earliest Arrival',
      'Latest Departure',
      'Total Trip Time',
      'Supplier Details'
    ];

    final csvContent = StringBuffer();
    csvContent.writeln(headers.join(','));

    for (int i = 0; i < trips.length; i++) {
      final trip = trips[i];
      final supplierDetails = trip.suppliers
          .map((s) =>
      '${s.supplierName} (${formatDateTime(s.actualArriveDate!)} - ${formatDateTime(s.actualDepartureDate!)})')
          .join('; ');
      final storageDetails = trip.storages.map((s) => '${s.name}').join('; ');

      final row = [
        (i + 1).toString(),
        trip.vehicleCode,
        '"$storageDetails"',
        '"${trip.procurementSpecialist}"',
        '"${trip.fleetSupervisor}"',
        trip.suppliers.length.toString(),
        '"${formatDateTime(trip.earliestArrival!)}"',
        '"${formatDateTime(trip.latestDeparture!)}"',
        trip.totalWaitingTime,
        '"$supplierDetails"'
      ];
      csvContent.writeln(row.join(','));
    }

    return csvContent.toString();
  }

  void toggleExpansion(int index) {
      trips[index].isExpanded = !trips[index].isExpanded;

      trips.refresh();
  }




}
