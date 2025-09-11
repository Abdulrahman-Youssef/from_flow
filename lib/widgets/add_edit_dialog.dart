import 'package:flutter/material.dart';
import 'package:form_flow/controller/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../app_state.dart';
import '../models/supplier_data.dart';

enum DialogMode { add, edit }

class AddEditDialog extends StatefulWidget {
  final DialogMode mode;
  final SupplierData? editData;

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

  String? _supplierName;
  String? _storageName;
  final _carIdController = TextEditingController();
  String? _procurementSpecialist;
  String? _supervisorName;
  DateTime? _actualArriveDate;
  DateTime? _actualLeaveDate;

  final List<String> _supplierOptions = [
    "ABC Logistics Co.",
    "Global Supply Ltd.",
    "Quick Transport Inc.",
    "Reliable Freight",
    "Express Delivery Co.",
    "Prime Logistics",
    "Swift Transport"
  ];

  final List<String> _storageOptions = [
    "Warehouse A",
    "Storage Facility B",
    "Warehouse C",
    "Storage Unit D",
    "Warehouse E",
    "Central Storage",
    "Distribution Center"
  ];

  final List<String> _procurementSpecialists = [
    "John Smith",
    "Emily Davis",
    "Robert Wilson",
    "David Martinez",
    "Amanda White",
    "Michael Johnson",
    "Sarah Brown"
  ];

  final List<String> _supervisors = [
    "Sarah Johnson",
    "Michael Brown",
    "Lisa Anderson",
    "Jennifer Taylor",
    "Kevin Miller",
    "Rachel Davis",
    "Thomas Wilson"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.mode == DialogMode.edit && widget.editData != null) {
      _supplierName = widget.editData!.supplierName;
      _storageName = widget.editData!.storageName;
      _carIdController.text = widget.editData!.carId;
      _procurementSpecialist = widget.editData!.procurementSpecialist;
      _supervisorName = widget.editData!.supervisorName;
      _actualArriveDate = widget.editData!.actualArriveDate;
      _actualLeaveDate = widget.editData!.actualLeaveDate;
    }
  }

  @override
  void dispose() {
    _carIdController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context, bool isArriveDate) async {
    final DateTime now = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate:
          isArriveDate ? _actualArriveDate ?? now : _actualLeaveDate ?? now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(
          isArriveDate ? _actualArriveDate ?? now : _actualLeaveDate ?? now,
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
            _actualArriveDate = selectedDateTime;
          } else {
            _actualLeaveDate = selectedDateTime;
          }
        });
      }
    }
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_supplierName == null ||
        _storageName == null ||
        _procurementSpecialist == null ||
        _supervisorName == null ||
        _actualArriveDate == null ||
        _actualLeaveDate == null) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final now = DateTime.now();
    if (_actualArriveDate!.isBefore(now)) {
      Get.snackbar(
        'Error',
        'Arrival date cannot be in the past',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_actualLeaveDate!.isBefore(now)) {
      Get.snackbar(
        'Error',
        'Leave date cannot be in the past',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (_actualLeaveDate!.isBefore(_actualArriveDate!) ||
        _actualLeaveDate!.isAtSameMomentAs(_actualArriveDate!)) {
      Get.snackbar(
        'Error',
        'Leave date must be after arrival date',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
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
            ? 'This will save the current data to the table.'
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
    final record = SupplierData(
      id: widget.editData?.id ?? 0,
      // Will be set by AppState
      supplierName: _supplierName!,
      storageName: _storageName!,
      carId: _carIdController.text,
      procurementSpecialist: _procurementSpecialist!,
      supervisorName: _supervisorName!,
      actualArriveDate: _actualArriveDate!,
      actualLeaveDate: _actualLeaveDate!,
    );

    final controller = Get.find<DashboardController>();
    if (widget.mode == DialogMode.add) {
      controller.addRecord(record);
    } else {
      controller.updateRecord(record);
    }

    Get.snackbar(
      'Success',
      'Record ${widget.mode == DialogMode.add ? 'added' : 'updated'} successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
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
                  ? 'Fill in all fields to create a new supply chain record.'
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
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _supplierName,
                              decoration: InputDecoration(
                                labelText: 'Supplier Name',
                                border: OutlineInputBorder(),
                              ),
                              items: _supplierOptions.map((String supplier) {
                                return DropdownMenuItem<String>(
                                  value: supplier,
                                  child: Text(supplier),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  _supplierName = value;
                                });
                              },
                              validator: (value) => value == null
                                  ? 'Please select a supplier'
                                  : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _storageName,
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
                            child: TextFormField(
                              controller: _carIdController,
                              decoration: InputDecoration(
                                labelText: 'Car ID',
                                hintText: 'Enter Car ID',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Car ID';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _procurementSpecialist,
                              decoration: InputDecoration(
                                labelText: 'Procurement Specialist',
                                border: OutlineInputBorder(),
                              ),
                              items: _procurementSpecialists
                                  .map((String specialist) {
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
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _supervisorName,
                              decoration: InputDecoration(
                                labelText: 'Supervisor\'s Name',
                                border: OutlineInputBorder(),
                              ),
                              items: _supervisors.map((String supervisor) {
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
                          Expanded(child: Container()),
                          // Empty space for alignment
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDateTime(context, true),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Actual Arrive Date',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  _actualArriveDate != null
                                      ? DateFormat('yyyy-MM-dd HH:mm')
                                          .format(_actualArriveDate!)
                                      : 'Select date and time',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDateTime(context, false),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Actual Leave Date',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  _actualLeaveDate != null
                                      ? DateFormat('yyyy-MM-dd HH:mm')
                                          .format(_actualLeaveDate!)
                                      : 'Select date and time',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
