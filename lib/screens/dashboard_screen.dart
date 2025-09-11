import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    Get.defaultDialog(
      title: 'Delete Record',
      middleText: 'This will permanently delete the record for ${record.supplierName} with Car ID ${record.carId}. This action cannot be undone.',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.find<AppController>().deleteRecord(record.id);
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

  void _handleCopy(int id) {
    Get.find<AppController>().copyRecord(id);
    Get.snackbar(
      'Success',
      'Record copied successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _handleSave() {
    Get.snackbar(
      'Success',
      'All records saved successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
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
              Get.find<AppController>().logout();
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Container(
        color: Color(0xFFF9FAFB),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: GetX<AppController>(
            builder: (controller) {
              return DataTableWidget(
                data: controller.data.toList(),
                selectedDate: controller.selectedDate.value,
                onDateChange: controller.setSelectedDate,
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