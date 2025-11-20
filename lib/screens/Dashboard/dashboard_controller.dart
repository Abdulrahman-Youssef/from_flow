import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_flow/controllers/delivery_controller.dart';
import 'package:form_flow/models/API/delivery_api_model.dart';
import 'package:form_flow/models/API/supplier_api_model.dart';
import 'package:form_flow/models/API/trip_api_model.dart';
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
  late int deliveryID;

  RxString deliveryName = ''.obs;
  final Rx<DateTime> selectedDeliveryDate = DateTime(0).obs;

  // related to table header
  final totalSuppliers = 0.obs;

  final totalStorages = 0.obs;

  // DateTime? selectedDeliveryDate;
  late DashboardControllerMode mode;
  late DeliveryData? editDelivery;

  DashboardController({this.editDelivery, required this.mode});

  @override
  void onInit() {
    super.onInit();
    // for testing
    // if(editDelivery == null ){
    //   throw "edited is empty bro";
    // }


    if (mode == DashboardControllerMode.edit) {
      trips.assignAll(editDelivery!.trips);
      // 2. Assign to .value
      deliveryName.value = editDelivery!.name;
      selectedDeliveryDate.value = editDelivery!.date;
      deliveryID = editDelivery!.id!;
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
        if (editDelivery != null) {
          editDelivery = editDelivery!.copyWith(name: textController.text);
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
      })} with Car ID ${record.vehicle}. This action cannot be undone.',
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
      duration: 600.milliseconds,
      'Success',
      'Record copied successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

// In DashboardController
// In DashboardController.dart

  void saveAndExit() async {
    if (trips.isEmpty) {
      print("Error: No trips to save.");
      return;
    }
    final deliveryController = Get.find<DeliveryController>();
    late final DeliveryApiModel deliveryApi;

    // Map UI trips to API trips
    List<TripApiModel> apiTrips = trips.map((t) {
      return TripApiModel(
        vehicleId: t.vehicle.id,
        // assuming all IDs are non-null
        procurementSpecialistId: t.procurementSpecialist.id,
        fleetSupervisorId: t.fleetSupervisor.id,
        note: t.note,
        storages: t.storages.map((s) => s.id!).toList(),
        suppliers: t.suppliers.map((s) {
          return SupplierApiModel(
            supplierId: s.id!,
            planArriveDate: s.planArriveDate.toString(),
            actualArriveDate: s.actualArriveDate.toString(),
            actualDepartureDate: s.actualDepartureDate.toString(),
          );
        }).toList(),
      );
    }).toList();

    if (mode == DashboardControllerMode.addedNew) {
      deliveryApi = DeliveryApiModel(
        name: deliveryName.value,
        date: selectedDeliveryDate.value.toIso8601String(),
        trips: apiTrips,
      );
      deliveryID = await deliveryController.handleCreateUpdateDelivery(deliveryApi);

      if (deliveryID != -1) {
        mode = DashboardControllerMode.edit;

        Get.snackbar(
          'Success',
          'Delivery "$deliveryName" saved successfully!',
          // 'Delivery "{finalDelivery.name}" saved successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } else {
      deliveryApi = DeliveryApiModel(
        id: deliveryID,
        name: deliveryName.value,
        date: selectedDeliveryDate.value.toIso8601String(),
        trips: apiTrips,
      );

      if (await deliveryController.handleCreateUpdateDelivery(deliveryApi) != -1) {
        Get.snackbar(
          'Success',
          'Delivery "$deliveryName" updated successfully!',
          // 'Delivery "{finalDelivery.name}" saved successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw "save delivery is failed";
      }
    }

    // Return the API model ready to send
    // Get.back(result: deliveryApi, closeOverlays: true);

    // Get.back(closeOverlays: true);
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
      vehicle: record.vehicle,
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
        '${deliveryName.value}-${DateFormat('yyyy-MM-dd').format(selectedDeliveryDate.value)}.csv',
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
        'CSV file exported successfully to: ${file.path}',
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
    final csvContent = StringBuffer();

    // Add delivery name header as a title row
    csvContent.writeln('"${deliveryName.value}"');
    csvContent.writeln('"Date: ${DateFormat('dd/MM/yyyy').format(selectedDeliveryDate.value)}"');
    csvContent.writeln(''); // Empty row for spacing

    // Column headers
    final headers = [
      'Trip #',
      'Vehicle',
      'Storages Names',
      'Suppliers Names',
      'Procurement Specialist',
      'Fleet Supervisor',
      'Total Trip Time',
      'Notes'
    ];

    csvContent.writeln(headers.join(','));

    // Data rows
    for (int i = 0; i < trips.length; i++) {
      final trip = trips[i];

      // Safely access vehicle name/number
      final vehicleNo = trip.vehicle.vehicleCode ?? trip.vehicle.id.toString();

      // Get all storage names
      final storagesNames = trip.storages
          .map((s) => s.name ?? 'Unknown')
          .join('; ');

      // Get all supplier names
      final suppliersNames = trip.suppliers
          .map((s) => s.supplierName)
          .join('; ');

      final row = [
        (i + 1).toString(),
        '"$vehicleNo"',
        '"$storagesNames"',
        '"$suppliersNames"',
        '"${trip.procurementSpecialist.name ?? 'Unknown'}"',
        '"${trip.fleetSupervisor.name ?? 'Unknown'}"',
        '"${trip.totalWaitingTime ?? 'N/A'}"',
        '"${trip.note ?? ''}"'
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
