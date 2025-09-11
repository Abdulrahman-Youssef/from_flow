import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class FormController extends GetxController {
  // Dropdown controllers
  String? supplierName;
  String? storageName;
  String? procurementSpecialist;
  String? supervisorName;
  String? carNumber;

  // Date controllers
  DateTime? _fromDate;
  DateTime? _toDate;

  // Notes controller
  final TextEditingController _notesController = TextEditingController();

  // Sample dropdown options
  final List<String> _options1 = ['مورد 1', 'مورد 2', 'مورد 3'];
  final List<String> _options2 = ['المخزن 1', 'المخزن 2', 'Option 2C'];
  final List<String> _options3 = ['Option 3A', 'Option 3B', 'Option 3C'];
  final List<String> _options4 = ['Option 4A', 'Option 4B', 'Option 4C'];
  final List<String> _options5 = ['Option 5A', 'Option 5B', 'Option 5C'];

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 100),
    );
    if (picked != null && picked != _fromDate) {
      // setState(() {
      _fromDate = picked;
      // });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? (_fromDate ?? DateTime.now()),
      firstDate: _fromDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _toDate) {
      // setState(() {
      _toDate = picked;
      // });
    }
  }
}
