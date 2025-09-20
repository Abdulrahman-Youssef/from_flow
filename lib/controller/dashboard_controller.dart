import 'package:flutter/material.dart';
import 'package:form_flow/models/trip_data.dart';
import 'package:form_flow/widgets/add_edit_dialog.dart';
import 'package:get/get.dart';
import '../models/supplier_data.dart';

class DashboardController extends GetxController {
  var data = <TripData>[
    TripData(
      id: 1,
        vehicleCode: "0081",
        storageName: "MAIN EXP. WAREHOUSE",
        procurementSpecialist: "procurementSpecialist",
        fleetSupervisor: "Ahmed Fouad",
        suppliers: [
          SupplierData(
              actualArriveDate: DateTime(2025, 10, 23),
              actualDepartureDate: DateTime(2025, 10, 24),
              supplierName: "HIKMA PHARMA COMPANY")
        ]),
    TripData(
      id: 2,
        vehicleCode: "2081",
        storageName: "MAIN EXP. WAREHOUSE",
        procurementSpecialist: "procurementSpecialist",
        fleetSupervisor: "Ahmed Fouad",
        suppliers: [
          SupplierData(
              actualArriveDate: DateTime(2025, 10, 23),
              actualDepartureDate: DateTime(2025, 10, 24),
              supplierName: "HIKMA PHARMA COMPANY")
        ]),
    TripData(
        id: 3,
        vehicleCode: "3081",
        storageName: "MAIN EXP. WAREHOUSE",
        procurementSpecialist: "procurementSpecialist",
        fleetSupervisor: "Ahmed Fouad",
        suppliers: [
          SupplierData(
              actualArriveDate: DateTime(2025, 10, 23),
              actualDepartureDate: DateTime(2025, 10, 24),
              supplierName: "HIKMA PHARMA COMPANY")
        ]),
    TripData(
        id: 4,
        vehicleCode: "4081",
        storageName: "MAIN EXP. WAREHOUSE",
        procurementSpecialist: "procurementSpecialist",
        fleetSupervisor: "Ahmed Fouad",
        suppliers: [
          SupplierData(
              actualArriveDate: DateTime(2025, 10, 23),
              actualDepartureDate: DateTime(2025, 10, 24),
              supplierName: "HIKMA PHARMA COMPANY")
        ]),
    TripData(
        id: 5,
        vehicleCode: "5081",
        storageName: "MAIN EXP. WAREHOUSE",
        procurementSpecialist: "procurementSpecialist",
        fleetSupervisor: "Ahmed Fouad",
        suppliers: [
          SupplierData(
              actualArriveDate: DateTime(2025, 10, 23),
              actualDepartureDate: DateTime(2025, 10, 24),
              supplierName: "HIKMA PHARMA COMPANY")
        ]),
    TripData(
        id: 6,
        vehicleCode: "6081",
        storageName: "MAIN EXP. WAREHOUSE",
        procurementSpecialist: "procurementSpecialist",
        fleetSupervisor: "Ahmed Fouad",
        suppliers: [
          SupplierData(
              actualArriveDate: DateTime(2025, 10, 23),
              actualDepartureDate: DateTime(2025, 10, 24),
              supplierName: "HIKMA PHARMA COMPANY")
        ]),
    TripData(
        id: 7,
        vehicleCode: "7081",
        storageName: "MAIN EXP. WAREHOUSE",
        procurementSpecialist: "procurementSpecialist",
        fleetSupervisor: "Ahmed Fouad",
        suppliers: [
          SupplierData(
              actualArriveDate: DateTime(2025, 10, 23),
              actualDepartureDate: DateTime(2025, 10, 24),
              supplierName: "HIKMA PHARMA COMPANY")
        ]),
    TripData(
        id: 8,
        vehicleCode: "8081",
        storageName: "MAIN EXP. WAREHOUSE",
        procurementSpecialist: "procurementSpecialist",
        fleetSupervisor: "Ahmed Fouad",
        suppliers: [
          SupplierData(
              actualArriveDate: DateTime(2025, 10, 23),
              actualDepartureDate: DateTime(2025, 10, 24),
              supplierName: "HIKMA PHARMA COMPANY")
        ]),
    TripData(
      id: 9,
        vehicleCode: "9081",
        storageName: "MAIN EXP. WAREHOUSE",
        procurementSpecialist: "procurementSpecialist",
        fleetSupervisor: "Ahmed Fouad",
        suppliers: [
          SupplierData(
              actualArriveDate: DateTime(2025, 10, 23),
              actualDepartureDate: DateTime(2025, 10, 24),
              supplierName: "HIKMA PHARMA COMPANY"),
          SupplierData(
              actualArriveDate: DateTime(2025, 10, 23),
              actualDepartureDate: DateTime(2025, 10, 24),
              supplierName: "HIKMA1 PHARMA COMPANY"),
        ]),
    TripData(
        id: 10,
        vehicleCode: "90181",
        storageName: "MAIN EXP. WAREHOUSE",
        procurementSpecialist: "procurementSpecialist",
        fleetSupervisor: "Ahmed Fouad",
        suppliers: [
          SupplierData(
              actualArriveDate: DateTime(2025, 10, 23),
              actualDepartureDate: DateTime(2025, 10, 24),
              supplierName: "HIKMA PHARMA COMPANY")
        ]),
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

  void showEditDialog(TripData record, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEditDialog(
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
          'This will permanently delete the record for suppliers ${record.suppliers.map((sup) {
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
    data.removeWhere((item) => item.id == id);
  }

  void copyRecord(int id) {
    final record = data.firstWhere((item) => item.id == id);
    final newId = data.isEmpty
        ? 1
        : data.map((e) => e.id).reduce((a, b) => a! > b! ? a : b)! + 1;
    final copiedRecord = record.copyWith(
      id: newId,
      vehicleCode: record.vehicleCode,
    );
    data.add(copiedRecord);
  }

  void addRecord(TripData record) {
    final newId = data.isEmpty
        ? 1
        : data.map((tripData) => tripData.id).reduce(
                (maximumValue, nextValue) =>
                    maximumValue! > nextValue! ? maximumValue : nextValue)! +
            1;
    data.add(record.copyWith(id: newId));
  }

  void updateRecord(TripData record) {
    final index = data.indexWhere((item) => item.id == record.id);
    if (index != -1) {
      data[index] = record;
    }
  }
}
