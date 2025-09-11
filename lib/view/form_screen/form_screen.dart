import 'package:flutter/material.dart';
import 'package:form_flow/view/form_screen/widgets/date_field.dart';
import 'package:form_flow/view/form_screen/widgets/drop_down_menu.dart';
import 'package:intl/intl.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  // Dropdown controllers
  String? _selectedOption1;
  String? _selectedOption2;
  String? _selectedOption3;
  String? _selectedOption4;
  String? _selectedOption5;

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
      setState(() {
        _fromDate = picked;
      });
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
      setState(() {
        _toDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Screen'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown 1
            buildDropdown(
              label: 'اسم المورد',
              value: _selectedOption1,
              options: _options1,
              onChanged: (value) {
                setState(() {
                  _selectedOption1 = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Dropdown 2
            buildDropdown(
              label: 'اسم المخزن',
              value: _selectedOption2,
              options: _options2,
              onChanged: (value) {
                setState(() {
                  _selectedOption2 = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Dropdown 3
            buildDropdown(
              label: 'رقم المركبه',
              value: _selectedOption3,
              options: _options3,
              onChanged: (value) {
                setState(() {
                  _selectedOption3 = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Dropdown 4
            buildDropdown(
              label: 'اخصائي المشتريات',
              value: _selectedOption4,
              options: _options4,
              onChanged: (value) {
                setState(() {
                  _selectedOption4 = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Dropdown 5
            buildDropdown(
              label: 'اسم المشرف',
              value: _selectedOption5,
              options: _options5,
              onChanged: (value) {
                setState(() {
                  _selectedOption5 = value;
                });
              },
            ),
            SizedBox(height: 24),
            // Date Range Picker
            Text(
              'Date Range',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: buildDateField(
                    label: 'From Date',
                    date: _fromDate,
                    onTap: () => _selectFromDate(context),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: buildDateField(
                    label: 'To Date',
                    date: _toDate,
                    onTap: () => _selectToDate(context),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Notes Text Field
            Text(
              'Notes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your notes here...',
                contentPadding: EdgeInsets.all(12),
              ),
            ),

            SizedBox(height: 32),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                _submitForm();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Submit',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    // Handle form submission here
    print('Selected Option 1: $_selectedOption1');
    print('Selected Option 2: $_selectedOption2');
    print('Selected Option 3: $_selectedOption3');
    print('Selected Option 4: $_selectedOption4');
    print('Selected Option 5: $_selectedOption5');
    print('From Date: $_fromDate');
    print('To Date: $_toDate');
    print('Notes: ${_notesController.text}');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Form submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
