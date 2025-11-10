import 'package:flutter/material.dart';
import 'package:form_flow/controllers/dropdown_data_controller.dart';

// Make sure you import the correct models
import 'package:form_flow/models/fleet_supervisors_model.dart';
import 'package:form_flow/models/procurement_specialists_model.dart';
import 'package:form_flow/models/storage_data.dart'; // <-- CORRECTED
import 'package:form_flow/models/supplier_data.dart'; // <-- CORRECTED
import 'package:form_flow/models/trip_data.dart';
import 'package:form_flow/models/vehicle_model.dart';
import 'package:form_flow/widgets/dashboard_widgets/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'dashboard_widgets/dialog/dropdown_search/dropdown_search2.dart';

enum DialogMode { add, edit }

class AddEditDialog extends StatefulWidget {
  final DialogMode mode;
  final TripData? editData;

  const AddEditDialog({
    super.key,
    required this.mode,
    this.editData,
  });

  @override
  _AddEditDialogState createState() => _AddEditDialogState();
}

class _AddEditDialogState extends State<AddEditDialog> {
  final DropDownDataController controller = Get.find<DropDownDataController>();

  final _formKey = GlobalKey<FormState>();
  late TextEditingController noteController;

  VehicleModel? _selectedVehicle;
  ProcurementSpecialistsModel? _selectedProcurementSpecialist;
  FleetSupervisorsModel? _selectedSupervisor;
  String? _note;

  // --- CORRECTED MODEL NAMES ---
  List<StorageModel> _storages = [StorageModel()];
  List<SupplierModel> _suppliers = [SupplierModel()];

  // --- CORRECTED MODEL NAMES ---
  late final List<SupplierModel> _supplierOptions;
  late final List<StorageModel> _storageOptions;
  late final List<VehicleModel> _vehicleNOOptions;
  late final List<ProcurementSpecialistsModel> _procurementSpecialists;
  late final List<FleetSupervisorsModel> _fleetSupervisors;

  @override
  void initState() {
    super.initState();

    // Load all options from the controller
    // --- CORRECTED LIST NAMES ---
    _supplierOptions = controller.suppliers;
    _storageOptions = controller.storages;
    _vehicleNOOptions = controller.vehicles;
    _procurementSpecialists = controller.procurementSpecialists;
    _fleetSupervisors = controller.fleetSupervisors;

    print(_vehicleNOOptions.length);

    if (widget.mode == DialogMode.edit && widget.editData != null) {
      final data = widget.editData!;
      noteController = TextEditingController(text: data.note);

      _selectedVehicle = _vehicleNOOptions.firstWhereOrNull(
        (v) => v.vehicleCode == data.vehicleCode,
      );
      _selectedProcurementSpecialist = _procurementSpecialists.firstWhereOrNull(
        (p) => p.name == data.procurementSpecialist,
      );
      _selectedSupervisor = _fleetSupervisors.firstWhereOrNull(
        (f) => f.name == data.fleetSupervisor,
      );

      _suppliers = data.suppliers;
      _storages = data.storages;
    } else {
      noteController = TextEditingController();
    }
  }

  // --- CORRECTED MODEL NAME ---
  Future<void> _selectDateTime(
      BuildContext context, int supplierIndex, DateType dateType) async {
    final DateTime now = DateTime.now();
    final SupplierModel supplier = _suppliers[supplierIndex]; // <-- Corrected

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
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
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

        setState(() {
          switch (dateType) {
            case DateType.planArrive:
              _suppliers[supplierIndex] = _suppliers[supplierIndex]
                  .copyWith(planArriveDate: selectedDateTime);
              break;
            case DateType.actualArrive:
              _suppliers[supplierIndex] = _suppliers[supplierIndex]
                  .copyWith(actualArriveDate: selectedDateTime);
              break;
            case DateType.actualDeparture:
              _suppliers[supplierIndex] = _suppliers[supplierIndex]
                  .copyWith(actualDepartureDate: selectedDateTime);
              break;
          }
        });
      }
    }
  }

  // --- CORRECTED MODEL NAME ---
  void _addAnotherSupplier() {
    setState(() {
      _suppliers.add(SupplierModel()); // <-- Corrected
    });
  }

  void _removeSupplier(int index) {
    if (_suppliers.length > 1) {
      setState(() {
        _suppliers.removeAt(index);
      });
    }
  }

  // --- CORRECTED MODEL NAME ---
  void _addAnotherStorage() {
    setState(() {
      _storages.add(StorageModel()); // <-- Corrected
    });
  }

  void _removeStorage(int index) {
    if (_storages.length > 1) {
      setState(() {
        _storages.removeAt(index);
      });
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

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _note = noteController.text.toString();

    if (_selectedVehicle == null ||
        _selectedProcurementSpecialist == null ||
        _selectedSupervisor == null) {
      Get.snackbar(
        'Error',
        'Please fill in all vehicle information fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    for (int i = 0; i < _storages.length; i++) {
      if (!_validateStorage(_storages[i], i)) {
        return;
      }
    }

    for (int i = 0; i < _suppliers.length; i++) {
      if (!_validateSupplier(_suppliers[i], i)) {
        return;
      }
    }

    _showConfirmDialog(true);
  }

  void _handleCancel() {
    _showConfirmDialog(false);
  }

  void _showConfirmDialog(bool isSave) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isSave
            ? 'Are you sure you want to save?'
            : 'Are you sure you want to cancel?'),
        content: Text(isSave
            ? 'This will save the current data with ${_storages.length} storage(s) and ${_suppliers.length} supplier(s) to the temp_table.'
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
      id: widget.editData?.id ?? 0,
      vehicleCode: _selectedVehicle!.vehicleCode,
      procurementSpecialist: _selectedProcurementSpecialist!.name,
      fleetSupervisor: _selectedSupervisor!.name,
      storages: _storages,
      suppliers: _suppliers,
      note: _note,
    );

    if (widget.mode == DialogMode.add) {
      controller.addRecord(record);
    } else {
      controller.updateRecord(record);
    }

    Get.snackbar(
      'Success',
      'Record ${widget.mode == DialogMode.add ? 'added' : 'updated'} successfully with ${_storages.length} storage(s) and ${_suppliers.length} supplier(s)',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Widget _buildTripInformationSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ReusableSearchableDropdown<VehicleModel>(
                  items: _vehicleNOOptions,
                  selectedItem: _selectedVehicle,
                  labelText: "Vehicle Number",
                  hintText: "Select vehicle...",
                  searchHint: "Search vehicle...",
                  prefixIcon: Icon(Icons.local_shipping),
                  itemAsString: (VehicleModel item) => item.vehicleCode,
                  // --- FIX: ADDED compareFn ---
                  compareFn: (item1, item2) => item1 == item2,
                  onChanged: (VehicleModel? value) {
                    setState(() {
                      _selectedVehicle = value;
                    });
                  },
                  validator: (VehicleModel? value) =>
                      value == null ? 'Please select a vehicle number' : null,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ReusableSearchableDropdown<FleetSupervisorsModel>(
                  items: _fleetSupervisors,
                  selectedItem: _selectedSupervisor,
                  labelText: "Fleet Supervisor",
                  hintText: "Select supervisor...",
                  searchHint: "Search supervisor...",
                  prefixIcon: Icon(Icons.supervised_user_circle),
                  itemAsString: (FleetSupervisorsModel item) => item.name,
                  // --- FIX: ADDED compareFn ---
                  compareFn: (item1, item2) => item1 == item2,
                  onChanged: (FleetSupervisorsModel? value) {
                    setState(() {
                      _selectedSupervisor = value;
                    });
                  },
                  validator: (FleetSupervisorsModel? value) =>
                      value == null ? 'Please select a supervisor' : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ReusableSearchableDropdown<ProcurementSpecialistsModel>(
            items: _procurementSpecialists,
            selectedItem: _selectedProcurementSpecialist,
            labelText: "Procurement Specialist",
            hintText: "Select specialist...",
            searchHint: "Search specialist...",
            prefixIcon: Icon(Icons.person),
            itemAsString: (ProcurementSpecialistsModel item) => item.name,
            // --- FIX: ADDED compareFn ---
            compareFn: (item1, item2) => item1 == item2,
            onChanged: (ProcurementSpecialistsModel? value) {
              setState(() {
                _selectedProcurementSpecialist = value;
              });
            },
            validator: (ProcurementSpecialistsModel? value) =>
                value == null ? 'Please select a specialist' : null,
          ),
          SizedBox(height: 16),
          TextField(
            controller: noteController,
            decoration: InputDecoration(
              labelText: 'Note',
              hintText: 'Write your note here...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            onTapOutside: (tap) {
              _note = noteController.text.toString();
              print("tapped out side $_note");
            },
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }

  // --- CORRECTED MODEL NAME ---
  Widget _buildStorageSection(int index) {
    StorageModel storage = _storages[index]; // <-- Corrected

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Storage ${index + 1}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple.shade700,
                ),
              ),
              if (_storages.length > 1)
                IconButton(
                  onPressed: () => _removeStorage(index),
                  icon: Icon(Icons.delete, color: Colors.red),
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(4),
                ),
            ],
          ),
          SizedBox(height: 16),
          ReusableSearchableDropdown<StorageModel>(
            // <-- Corrected
            items: _storageOptions,
            selectedItem: storage.name == null ? null : storage,
            labelText: "Storage Name",
            hintText: "Select storage...",
            searchHint: "Search storage...",
            prefixIcon: Icon(Icons.warehouse),
            itemAsString: (StorageModel item) => item.name ?? '',
            // <-- Corrected
            // --- FIX: ADDED compareFn ---
            compareFn: (item1, item2) => item1 == item2,
            onChanged: (StorageModel? value) {
              // <-- Corrected
              if (value != null) {
                setState(() {
                  _storages[index] = value;
                });
              }
            },
            validator: (StorageModel? value) => // <-- Corrected
                value == null || value.name == null
                    ? 'Please select a storage'
                    : null,
          ),
        ],
      ),
    );
  }

  Widget _buildStoragesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Storage Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.purple.shade700,
          ),
        ),
        SizedBox(height: 16),
        ...List.generate(
            _storages.length, (index) => _buildStorageSection(index)),
        SizedBox(height: 8),
        Center(
          child: OutlinedButton.icon(
            onPressed: _addAnotherStorage,
            icon: Icon(Icons.add),
            label: Text('Add Another Storage'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.purple,
              side: BorderSide(color: Colors.purple),
            ),
          ),
        ),
      ],
    );
  }

  // --- CORRECTED MODEL NAME ---
  Widget _buildSupplierSection(int index) {
    SupplierModel supplier = _suppliers[index]; // <-- Corrected

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Supplier ${index + 1}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade700,
                ),
              ),
              if (_suppliers.length > 1)
                IconButton(
                  onPressed: () => _removeSupplier(index),
                  icon: Icon(Icons.delete, color: Colors.red),
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(4),
                ),
            ],
          ),
          SizedBox(height: 16),
          ReusableSearchableDropdown<SupplierModel>(
            // <-- Corrected
            items: _supplierOptions,
            selectedItem: supplier.supplierName == null ? null : supplier,
            labelText: "Supplier Name",
            hintText: "Select supplier...",
            searchHint: "Search supplier...",
            prefixIcon: Icon(Icons.business),
            itemAsString: (SupplierModel item) => item.supplierName ?? '',
            // <-- CorrectObserved
            // --- FIX: ADDED compareFn ---
            compareFn: (item1, item2) => item1 == item2,
            onChanged: (SupplierModel? value) {
              // <-- Corrected
              if (value != null) {
                setState(() {
                  _suppliers[index] = _suppliers[index].copyWith(
                    id: value.id,
                    supplierName: value.supplierName,
                  );
                });
              }
            },
            validator: (SupplierModel? value) => // <-- Corrected
                value == null || value.supplierName == null
                    ? 'Please select a supplier'
                    : null,
          ),
          SizedBox(height: 16),
          InkWell(
            onTap: () => _selectDateTime(context, index, DateType.planArrive),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: 'Plan Arrive Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              child: Text(
                supplier.planArriveDate != null
                    ? DateFormat('dd-MM-yyyy HH:mm')
                        .format(supplier.planArriveDate!)
                    : 'Select date and time',
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () =>
                      _selectDateTime(context, index, DateType.actualArrive),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Actual Arrive Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      supplier.actualArriveDate != null
                          ? DateFormat('dd-MM-yyyy HH:mm')
                              .format(supplier.actualArriveDate!)
                          : 'Select date and time',
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () =>
                      _selectDateTime(context, index, DateType.actualDeparture),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Actual Departure Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      supplier.actualDepartureDate != null
                          ? DateFormat('dd-MM-yyyy HH:mm')
                              .format(supplier.actualDepartureDate!)
                          : 'Select date and time',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuppliersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Supplier Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.green.shade700,
          ),
        ),
        SizedBox(height: 16),
        ...List.generate(
            _suppliers.length, (index) => _buildSupplierSection(index)),
        SizedBox(height: 8),
        Center(
          child: OutlinedButton.icon(
            onPressed: _addAnotherSupplier,
            icon: Icon(Icons.add),
            label: Text('Add Another Supplier'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
              side: BorderSide(color: Colors.green),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              widget.mode == DialogMode.add ? 'Add New Record' : 'Edit Record',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.mode == DialogMode.add
                  ? 'Fill in vehicle information, add storages, and add one or more suppliers.'
                  : 'Update the fields below to modify the existing record.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 24),
            // Form
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTripInformationSection(),
                      SizedBox(height: 24),
                      _buildStoragesSection(),
                      SizedBox(height: 24),
                      _buildSuppliersSection(),
                    ],
                  ),
                ),
              ),
            ),
            // Actions
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: _handleCancel,
                  child: Text('Cancel'),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _handleSave,
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum DateType { planArrive, actualArrive, actualDeparture }
