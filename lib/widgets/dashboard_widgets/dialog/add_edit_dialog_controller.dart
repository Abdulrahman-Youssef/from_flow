import 'package:flutter/material.dart';
import 'package:form_flow/controllers/dropdown_data_controller.dart';
import 'package:form_flow/models/fleet_supervisors_model.dart';
import 'package:form_flow/models/procurement_specialists_model.dart';
import 'package:form_flow/models/storage_data.dart';
import 'package:form_flow/models/supplier_data.dart';
import 'package:form_flow/models/trip_data.dart';
import 'package:form_flow/models/vehicle_model.dart';
import 'package:form_flow/widgets/dashboard_widgets/dashboard_controller.dart';
import 'package:get/get.dart';

enum DialogMode { add, edit }

enum DateType { planArrive, actualArrive, actualDeparture }

class AddEditDialogController extends GetxController {
  final DropDownDataController controller = Get.find<DropDownDataController>();

  final DialogMode mode;
  final TripData? editData;

  AddEditDialogController({required this.mode, this.editData});

  final formKey = GlobalKey<FormState>();
  late TextEditingController noteController;

// selected data
  final Rxn<VehicleModel> selectedVehicle = Rxn<VehicleModel>();
  final Rxn<ProcurementSpecialistsModel> selectedProcurementSpecialist =
      Rxn<ProcurementSpecialistsModel>();
  final Rxn<FleetSupervisorsModel> selectedSupervisor =
      Rxn<FleetSupervisorsModel>();
  final Rxn<String> note = Rxn<String>();

  // --- CORRECTED MODEL NAMES ---
  final selectedStorages = <StorageModel>[].obs;
  final selectedSuppliers = <SupplierModel>[].obs;

  // --- CORRECTED MODEL NAMES ---
  late final List<SupplierModel> supplierOptions;
  late final List<StorageModel> storageOptions;
  late final List<VehicleModel> vehicleNOOptions;
  late final List<ProcurementSpecialistsModel> procurementSpecialists;
  late final List<FleetSupervisorsModel> fleetSupervisors;

  @override
  void onInit() {
    super.onInit();

    // Load all options from the controller
    // --- CORRECTED LIST NAMES ---
    supplierOptions = controller.suppliers;
    storageOptions = controller.storages;
    vehicleNOOptions = controller.vehicles;
    procurementSpecialists = controller.procurementSpecialists;
    fleetSupervisors = controller.fleetSupervisors;

    if (mode == DialogMode.edit && editData != null) {
      final data = editData!;
      noteController = TextEditingController(text: data.note);

      selectedVehicle.value = vehicleNOOptions.firstWhereOrNull(
        (v) => v.vehicleCode == data.vehicleCode,
      );
      selectedProcurementSpecialist.value =
          procurementSpecialists.firstWhereOrNull(
        (p) => p.name == data.procurementSpecialist,
      );
      selectedSupervisor.value = fleetSupervisors.firstWhereOrNull(
        (f) => f.name == data.fleetSupervisor,
      );

      selectedSuppliers.value = data.suppliers;
      selectedStorages.value = data.storages;
    } else {
      noteController = TextEditingController();
    }
  }

  Future<void> selectDateTime(int supplierIndex, DateType dateType) async {
    final DateTime now = DateTime.now();
    final SupplierModel supplier = selectedSuppliers[supplierIndex]; // <-- Corrected

    DateTime? initialDate;
    // ... (rest of function is fine)
    switch (dateType) {
      case DateType.planArrive:
        initialDate = supplier.planArriveDate ?? now;
        break;
      case DateType.actualArrive:
        initialDate = supplier.actualArriveDate ?? now;
        break;
      case DateType.actualDeparture:
        initialDate = supplier.actualDepartureDate ?? now;
        break;
    }

    final DateTime? date = await showDatePicker(
      context: Get.context!,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (time != null) {
        final DateTime selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        switch (dateType) {
          case DateType.planArrive:
            selectedSuppliers[supplierIndex] = selectedSuppliers[supplierIndex]
                .copyWith(planArriveDate: selectedDateTime);
            break;
          case DateType.actualArrive:
            selectedSuppliers[supplierIndex] = selectedSuppliers[supplierIndex]
                .copyWith(actualArriveDate: selectedDateTime);
            break;
          case DateType.actualDeparture:
            selectedSuppliers[supplierIndex] = selectedSuppliers[supplierIndex]
                .copyWith(actualDepartureDate: selectedDateTime);
            break;
        }
        update();
      }
    }
  }

  // --- CORRECTED MODEL NAME ---
  void addAnotherSupplier() {
    selectedSuppliers.add(SupplierModel()); // <-- Corrected
    update();
  }

  void removeSupplier(int index) {
    if (selectedSuppliers.length > 1) {
      selectedSuppliers.removeAt(index);
    }
  }

  // --- CORRECTED MODEL NAME ---
  void addAnotherStorage() {
    selectedStorages.add(StorageModel()); // <-- Corrected
  }

  void removeStorage(int index) {
    if (selectedStorages.length > 1) {
      selectedStorages.removeAt(index);
    }
  }

  // --- CORRECTED MODEL NAME ---
  bool _validateSupplier(SupplierModel supplier, int index) {
    // <-- Corrected
    if (supplier.supplierName == null) {
      Get.snackbar(
        'Error',
        'Please select supplier name for supplier ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      update();
      return false;
    }
    // ... (rest of validation logic is fine)
    if (supplier.planArriveDate == null) {
      Get.snackbar(
        'Error',
        'Please select plan arrival date for supplier ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (supplier.actualArriveDate == null) {
      Get.snackbar(
        'Error',
        'Please select actual arrival date for supplier ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (supplier.actualDepartureDate == null) {
      Get.snackbar(
        'Error',
        'Please select departure date for supplier ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    final now = DateTime.now();
    if (supplier.planArriveDate!.isBefore(now)) {
      Get.snackbar(
        'Error',
        'Plan arrival date cannot be in the past for supplier ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (supplier.actualArriveDate!.isBefore(now)) {
      Get.snackbar(
        'Error',
        'Actual arrival date cannot be in the past for supplier ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (supplier.actualDepartureDate!.isBefore(now)) {
      Get.snackbar(
        'Error',
        'Departure date cannot be in the past for supplier ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (supplier.actualDepartureDate!.isBefore(supplier.actualArriveDate!) ||
        supplier.actualDepartureDate!
            .isAtSameMomentAs(supplier.actualArriveDate!)) {
      Get.snackbar(
        'Error',
        'Departure date must be after actual arrival date for supplier ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  // --- CORRECTED MODEL NAME ---
  bool _validateStorage(StorageModel storage, int index) {
    // <-- Corrected
    if (storage.name == null || storage.name!.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select storage name for storage ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    return true;
  }

  void handleSave(BuildContext context) {
    print("im  working 1");
    if (!formKey.currentState!.validate()) {
      print("im not working 1");
      return;
    }

    print("im  working 2");

    note.value = noteController.text.toString();

    if (selectedVehicle.value == null ||
        selectedProcurementSpecialist.value == null ||
        selectedSupervisor.value == null) {
      Get.snackbar(
        'Error',
        'Please fill in all vehicle information fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    for (int i = 0; i < selectedStorages.length; i++) {
      if (!_validateStorage(selectedStorages[i], i)) {
        return;
      }
    }

    for (int i = 0; i < selectedSuppliers.length; i++) {
      if (!_validateSupplier(selectedSuppliers[i], i)) {
        return;
      }
    }

    _showConfirmDialog(true, context);
  }

  void handleCancel(BuildContext context) {
    _showConfirmDialog(false, context);
  }

  void _showConfirmDialog(bool isSave, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isSave
            ? 'Are you sure you want to save?'
            : 'Are you sure you want to cancel?'),
        content: Text(isSave
            ? 'This will save the current data with ${selectedStorages.length} storage(s) and ${selectedSuppliers.length} supplier(s) to the temp_table.'
            : 'Any unsaved changes will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (isSave) {
                _performSave();
              }
              Navigator.of(context).pop();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _performSave() {
    final controller = Get.find<DashboardController>();

    final record = TripData(
      id: editData?.id ?? 0,
      vehicleCode: selectedVehicle.value!.vehicleCode,
      procurementSpecialist: selectedProcurementSpecialist.value!.name,
      fleetSupervisor: selectedSupervisor.value!.name,
      storages: selectedStorages,
      suppliers: selectedSuppliers,
      note: note.value,
    );

    if (mode == DialogMode.add) {
      controller.addRecord(record);
    } else {
      controller.updateRecord(record);
    }

    Get.snackbar(
      'Success',
      'Record ${mode == DialogMode.add ? 'added' : 'updated'} successfully with ${selectedStorages.length} storage(s) and ${selectedSuppliers.length} supplier(s)',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
