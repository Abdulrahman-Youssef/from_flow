import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../widgets/data_table_widget.dart';
import '../widgets/add_edit_dialog.dart';
import '../models/supplier_data.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEditDialog(mode: DialogMode.add),
    );
  }

  void _showEditDialog(SupplierData record) {
    showDialog(
      context: context,
      builder: (context) => AddEditDialog(
        mode: DialogMode.edit,
        editData: record,
      ),
    );
  }

  void _showDeleteDialog(SupplierData record) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure you want to delete this record?'),
        content: Text(
          'This will permanently delete the record for ${record.supplierName} with Car ID ${record.carId}. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<AppState>(context, listen: false).deleteRecord(record.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Record for ${record.supplierName} deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _handleCopy(int id) {
    Provider.of<AppState>(context, listen: false).copyRecord(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Record copied successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All records saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Supply Chain Management System'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Icon(Icons.person, size: 20),
                SizedBox(width: 8),
                Text('Admin User'),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Provider.of<AppState>(context, listen: false).logout();
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Container(
        color: Color(0xFFF9FAFB),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Consumer<AppState>(
            builder: (context, appState, child) {
              return DataTableWidget(
                data: appState.data,
                selectedDate: appState.selectedDate,
                onDateChange: appState.setSelectedDate,
                onAddNew: _showAddDialog,
                onEdit: _showEditDialog,
                onCopy: _handleCopy,
                onDelete: _showDeleteDialog,
                onSave: _handleSave,
              );
            },
          ),
        ),
      ),
    );
  }
}