import 'package:flutter/material.dart';
import 'package:form_flow/controller/dashboard_controller.dart';
import 'package:form_flow/core/data/constant/data_lists.dart';
import 'package:form_flow/models/supplier_data.dart';
import 'package:form_flow/models/trip_data.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  // Section 1: Vehicle Information
  String? _storageName;
  String? _vehicleCode;
  String? _procurementSpecialist;
  String? _supervisorName;

  // Section 2: Suppliers List
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
  final List<String> _fleetSupervisor = DataLists.fleetSupervisors;

  @override
  void initState() {
    super.initState();
    if (widget.mode == DialogMode.edit && widget.editData != null) {
      _storageName = widget.editData!.storageName;
      _vehicleCode = widget.editData!.vehicleCode;
      _procurementSpecialist = widget.editData!.procurementSpecialist;
      _supervisorName = widget.editData!.fleetSupervisor;


      // Initialize with existing supplier data
     _suppliers = widget.editData!.suppliers;
    }
  }

  Future<void> _selectDateTime(BuildContext context, int supplierIndex, bool isArriveDate) async {
    final DateTime now = DateTime.now();
    final SupplierData supplier = _suppliers[supplierIndex];

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: isArriveDate
          ? supplier.actualArriveDate ?? now
          : supplier.actualDepartureDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          isArriveDate
              ? supplier.actualArriveDate ?? now
              : supplier.actualDepartureDate ?? now,
        ),
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
          if (isArriveDate) {
            _suppliers[supplierIndex].actualArriveDate  =selectedDateTime ;
          } else {
            _suppliers[supplierIndex].actualDepartureDate =selectedDateTime;
          }
        });
      }
    }
  }

  void _addAnotherSupplier(){
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

    if (supplier.actualArriveDate == null) {
      Get.snackbar(
        'Error',
        'Please select arrival date for supplier ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (supplier.actualDepartureDate == null) {
      Get.snackbar(
        'Error',
        'Please select leave date for supplier ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    final now = DateTime.now();
    if (supplier.actualArriveDate!.isBefore(now)) {
      Get.snackbar(
        'Error',
        'Arrival date cannot be in the past for supplier ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (supplier.actualDepartureDate!.isBefore(now)) {
      Get.snackbar(
        'Error',
        'Leave date cannot be in the past for supplier ${index + 1}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (supplier.actualDepartureDate!.isBefore(supplier.actualArriveDate!) ||
        supplier.actualDepartureDate!.isAtSameMomentAs(supplier.actualArriveDate!)) {
      Get.snackbar(
        'Error',
        'Leave date must be after arrival date for supplier ${index + 1}',
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
    if (_storageName == null ||
        _vehicleCode == null ||
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

    // Validate Section 2 (Suppliers)
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
            ? 'This will save the current data with ${_suppliers.length} supplier(s) to the temp_table.'
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

    // Create a record for each supplier
    for (int i = 0; i < _suppliers.length; i++) {
      final supplier = _suppliers[i];
      final record = TripData(
        id: widget.editData?.id ?? 0, // Will be set by AppState
        storageName: _storageName!,
        vehicleCode: _vehicleCode!,
        procurementSpecialist: _procurementSpecialist!,
        fleetSupervisor: _supervisorName!,
        suppliers: _suppliers
      );

      if (widget.mode == DialogMode.add) {
        controller.addRecord(record);
      } else {
        controller.updateRecord(record);
      }
    }

    Get.snackbar(
      'Success',
      '${_suppliers.length} record(s) ${widget.mode == DialogMode.add ? 'added' : 'updated'} successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Widget _buildVehicleInformationSection() {
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
            'Vehicle Information',
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
                child: DropdownButtonFormField<String>(
                  initialValue: _vehicleCode,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Number',
                    border: OutlineInputBorder(),
                  ),
                  items: _vehicleNOOptions.map((String vehicleNO) {
                    return DropdownMenuItem<String>(
                      value: vehicleNO,
                      child: Text(vehicleNO),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _vehicleCode = value;
                    });
                  },
                  validator: (value) => value == null
                      ? 'Please select a vehicle number'
                      : null,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _storageName,
                  decoration: InputDecoration(
                    labelText: 'Storage Name',
                    border: OutlineInputBorder(),
                  ),
                  items: _storageOptions.map((String storage) {
                    return DropdownMenuItem<String>(
                      value: storage,
                      child: Text(storage),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _storageName = value;
                    });
                  },
                  validator: (value) => value == null
                      ? 'Please select a storage'
                      : null,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _supervisorName,
                  decoration: InputDecoration(
                    labelText: 'Fleet Supervisor',
                    border: OutlineInputBorder(),
                  ),
                  items: _fleetSupervisor.map((String supervisor) {
                    return DropdownMenuItem<String>(
                      value: supervisor,
                      child: Text(supervisor),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _supervisorName = value;
                    });
                  },
                  validator: (value) => value == null
                      ? 'Please select a supervisor'
                      : null,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _procurementSpecialist,
                  decoration: InputDecoration(
                    labelText: 'Procurement Specialist',
                    border: OutlineInputBorder(),
                  ),
                  items: _procurementSpecialists.map((String specialist) {
                    return DropdownMenuItem<String>(
                      value: specialist,
                      child: Text(specialist),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _procurementSpecialist = value;
                    });
                  },
                  validator: (value) => value == null
                      ? 'Please select a specialist'
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
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
          DropdownButtonFormField<String>(
            initialValue: supplier.supplierName,
            decoration: InputDecoration(
              labelText: 'Supplier Name',
              border: OutlineInputBorder(),
            ),
            items: _supplierOptions.map((String supplierName) {
              return DropdownMenuItem<String>(
                value: supplierName,
                child: Text(supplierName),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                //--------------------------------------------------------------------------------------
                _suppliers[index].supplierName = value;
              });
            },
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _selectDateTime(context, index, true),
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
                  onTap: () => _selectDateTime(context, index, false),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Actual Leave Date',
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
        ...List.generate(_suppliers.length, (index) => _buildSupplierSection(index)),
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
                  ? 'Fill in vehicle information and add one or more suppliers.'
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
                      _buildVehicleInformationSection(),
                      SizedBox(height: 24),
                      // Section 2: Suppliers
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