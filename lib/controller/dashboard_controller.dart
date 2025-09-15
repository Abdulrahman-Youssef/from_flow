import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/supplier_data.dart';
import '../widgets/add_edit_dialog.dart' hide DialogMode;
import '../widgets/temp_dialogs/try1.dart';

class DashboardController extends GetxController {
  var data = <SupplierData>[
    // SupplierData(
    //   id: 1,
    //   supplierName: "ABC Logistics Co.",
    //   storageName: "Warehouse A",
    //   vehicleCode: "CAR-001",
    //   procurementSpecialist: "John Smith",
    //   fleetSupervisor: "Sarah Johnson",
    //   actualArriveDate: DateTime(2024, 1, 18, 8, 30),
    //   actualDepartureDate: DateTime(2024, 1, 18, 10, 45),
    // ),
  ].obs;

  var selectedDate = DateTime.now().add(Duration(days: 1)).obs;

  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  void showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEditDialog(mode: DialogMode.add),
    );
  }

  void showEditDialog(SupplierData record, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEditDialog(
        mode: DialogMode.edit,
        editData: record,
      ),
    );
  }

  // when delete too fast teh dialog glitching and do not disappear
  void showDeleteDialog(SupplierData record) {
    Get.defaultDialog(
      title: 'Delete Record',
      middleText:
          'This will permanently delete the record for ${record.supplierName} with Car ID ${record.vehicleCode}. This action cannot be undone.',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        deleteRecord(record.id);
        Get.back();
        Get.snackbar(
          'Success',
          'Record for ${record.supplierName} deleted successfully',
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
    data.removeWhere((item) => item.id == id);
  }

  void copyRecord(int id) {
    final record = data.firstWhere((item) => item.id == id);
    final newId = data.isEmpty
        ? 1
        : data.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    final copiedRecord = record.copyWith(
      id: newId,
      carId: record.vehicleCode,
    );
    data.add(copiedRecord);
  }

  void addRecord(SupplierData record) {
    final newId = data.isEmpty
        ? 1
        : data.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    data.add(record.copyWith(id: newId));
  }

  void updateRecord(SupplierData record) {
    final index = data.indexWhere((item) => item.id == record.id);
    if (index != -1) {
      data[index] = record;
    }
  }
}
