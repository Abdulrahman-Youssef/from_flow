import 'package:flutter/material.dart';
import 'package:form_flow/app_state.dart';
import 'package:get/get.dart';

import '../models/supplier_data.dart';
import '../widgets/add_edit_dialog.dart';

class DashboardController extends GetxController {
  var data = <SupplierData>[
    SupplierData(
      id: 1,
      supplierName: "ABC Logistics Co.",
      storageName: "Warehouse A",
      carId: "CAR-001",
      procurementSpecialist: "John Smith",
      supervisorName: "Sarah Johnson",
      actualArriveDate: DateTime(2024, 1, 15, 8, 30),
      actualLeaveDate: DateTime(2024, 1, 18, 14, 45),
    ),
    SupplierData(
      id: 2,
      supplierName: "Global Supply Ltd.",
      storageName: "Storage Facility B",
      carId: "CAR-002",
      procurementSpecialist: "Emily Davis",
      supervisorName: "Michael Brown",
      actualArriveDate: DateTime(2024, 1, 20, 9, 15),
      actualLeaveDate: DateTime(2024, 1, 25, 16, 20),
    ),
    SupplierData(
      id: 3,
      supplierName: "Quick Transport Inc.",
      storageName: "Warehouse C",
      carId: "CAR-003",
      procurementSpecialist: "Robert Wilson",
      supervisorName: "Lisa Anderson",
      actualArriveDate: DateTime(2024, 1, 22, 10, 0),
      actualLeaveDate: DateTime(2024, 1, 24, 13, 30),
    ),
    SupplierData(
      id: 4,
      supplierName: "Reliable Freight",
      storageName: "Storage Unit D",
      carId: "CAR-004",
      procurementSpecialist: "David Martinez",
      supervisorName: "Jennifer Taylor",
      actualArriveDate: DateTime(2024, 1, 25, 7, 45),
      actualLeaveDate: DateTime(2024, 1, 30, 15, 10),
    ),
    SupplierData(
      id: 5,
      supplierName: "Express Delivery Co.",
      storageName: "Warehouse E",
      carId: "CAR-005",
      procurementSpecialist: "Amanda White",
      supervisorName: "Kevin Miller",
      actualArriveDate: DateTime(2024, 1, 28, 11, 20),
      actualLeaveDate: DateTime(2024, 2, 2, 17, 0),
    ),
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
          'This will permanently delete the record for ${record.supplierName} with Car ID ${record.carId}. This action cannot be undone.',
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
      carId: record.carId,
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
