import 'package:flutter/material.dart';
import 'package:form_flow/core/data/constant/data_lists.dart';
import 'package:form_flow/models/storage_data.dart';
import 'package:form_flow/models/supplier_data.dart';
import 'package:form_flow/models/trip_data.dart';
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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController noteController ;

  // Section 1: Trip Information
  String? _vehicleCode;
  String? _procurementSpecialist;
  String? _supervisorName;
  String? _note;

  // Section 2: Storage Information
  List<StorageData> _storages = [StorageData()];

  // Section 3: Suppliers List
  List<SupplierData> _suppliers = [SupplierData()];

  final List<String> _supplierOptions = DataLists.suppliers;
  final List<String> _storageOptions = DataLists.warehouses;
  final List<String> _vehicleNOOptions = DataLists.vehicleCodes;
  final List<String> _procurementSpecialists = [
    "John Smith",
    "Emily Davis",
    "Robert Wilson",
    "David Martinez",
    "Amanda White",
    "Michael Johnson",
    "Sarah Brown"
  ];
  final List<String> _fleetSupervisors = DataLists.fleetSupervisors;

  @override
  void initState() {
    super.initState();
    if (widget.mode == DialogMode.edit && widget.editData != null) {
      _vehicleCode = widget.editData!.vehicleCode;
      _procurementSpecialist = widget.editData!.procurementSpecialist;
      _supervisorName = widget.editData!.fleetSupervisor;
      _supervisorName = widget.editData!.fleetSupervisor;
      noteController = TextEditingController(text: widget.editData!.note);

      // Initialize with existing suppliers data
      _suppliers = widget.editData!.suppliers;
      // Initialize with existing storages data
      _storages = widget.editData!.storages;
    }else {
       noteController = TextEditingController();
    }
  }

  Future<void> _selectDateTime(
      BuildContext context, int supplierIndex, DateType dateType) async {
    final DateTime now = DateTime.now();
    final SupplierData supplier = _suppliers[supplierIndex];

    DateTime? initialDate;
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

  void _addAnotherSupplier() {
    setState(() {
      _suppliers.add(SupplierData());
    });
  }

  void _removeSupplier(int index) {
    if (_suppliers.length > 1) {
      setState(() {
        _suppliers.removeAt(index);
      });
    }
  }

  void _addAnotherStorage() {
    setState(() {
      _storages.add(StorageData());
    });
  }

  void _removeStorage(int index) {
    if (_storages.length > 1) {
      setState(() {
        _storages.removeAt(index);
      });
    }
  }

  bool _validateSupplier(SupplierData supplier, int index) {
    if (supplier.supplierName == null) {
      Get.snackbar(
        'Error',
        'Please select supplier name for supplier ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

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

  bool _validateStorage(StorageData storage, int index) {
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

    // Validate Section 1 (Vehicle Information)
    if (_vehicleCode == null ||
        _procurementSpecialist == null ||
        _supervisorName == null) {
      Get.snackbar(
        'Error',
        'Please fill in all vehicle information fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Validate Section 2 (Storages)
    for (int i = 0; i < _storages.length; i++) {
      if (!_validateStorage(_storages[i], i)) {
        return;
      }
    }

    // Validate Section 3 (Suppliers)
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
              Navigator.of(context).pop(); // Close confirm dialog
              if (isSave) {
                _performSave();
              }
              Navigator.of(context).pop(); // Close main dialog
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
        vehicleCode: _vehicleCode!,
        procurementSpecialist: _procurementSpecialist!,
        fleetSupervisor: _supervisorName!,
        storages: _storages,
        suppliers: _suppliers,
        note: _note);

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
                child: ReusableSearchableDropdown(
                  items: _vehicleNOOptions,
                  selectedItem: _vehicleCode,
                  labelText: "Vehicle Number",
                  hintText: "Select vehicle...",
                  searchHint: "Search vehicle...",
                  prefixIcon: Icon(Icons.local_shipping),
                  onChanged: (String? value) {
                    setState(() {
                      _vehicleCode = value;
                    });
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select a vehicle number'
                      : null,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ReusableSearchableDropdown(
                  items: _fleetSupervisors,
                  selectedItem: _supervisorName,
                  labelText: "Fleet Supervisor",
                  hintText: "Select supervisor...",
                  searchHint: "Search supervisor...",
                  prefixIcon: Icon(Icons.supervised_user_circle),
                  onChanged: (String? value) {
                    setState(() {
                      _supervisorName = value;
                    });
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select a supervisor'
                      : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ReusableSearchableDropdown(
            items: _procurementSpecialists,
            selectedItem: _procurementSpecialist,
            labelText: "Procurement Specialist",
            hintText: "Select specialist...",
            searchHint: "Search specialist...",
            prefixIcon: Icon(Icons.person),
            onChanged: (String? value) {
              setState(() {
                _procurementSpecialist = value;
              });
            },
            validator: (value) => value == null || value.isEmpty
                ? 'Please select a specialist'
                : null,
          ),
          SizedBox(height: 16),
          // Note
          TextField(
            controller: noteController,
            decoration: InputDecoration(
              labelText: 'Note',
              hintText: 'Write your note here...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            onTapOutside: (tap){
              _note = noteController.text.toString();
              print("tabped out side $_note");
            },
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }

  Widget _buildStorageSection(int index) {
    StorageData storage = _storages[index];

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
          ReusableSearchableDropdown(
            items: _storageOptions,
            selectedItem: storage.name,
            labelText: "Storage Name",
            hintText: "Select storage...",
            searchHint: "Search storage...",
            prefixIcon: Icon(Icons.warehouse),
            onChanged: (String? value) {
              setState(() {
                _storages[index] = StorageData(name: value);
              });
            },
            validator: (value) => value == null || value.isEmpty
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

  Widget _buildSupplierSection(int index) {
    SupplierData supplier = _suppliers[index];

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
          ReusableSearchableDropdown(
            items: _supplierOptions,
            selectedItem: supplier.supplierName,
            labelText: "Supplier Name",
            hintText: "Select supplier...",
            searchHint: "Search supplier...",
            prefixIcon: Icon(Icons.business),
            onChanged: (String? value) {
              setState(() {
                _suppliers[index] =
                    _suppliers[index].copyWith(supplierName: value);
              });
            },
            validator: (value) => value == null || value.isEmpty
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
                      // Section 1: Vehicle Information
                      _buildTripInformationSection(),
                      SizedBox(height: 24),
                      // Section 2: Storages
                      _buildStoragesSection(),
                      SizedBox(height: 24),
                      // Section 3: Suppliers
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
