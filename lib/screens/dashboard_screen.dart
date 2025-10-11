import 'package:flutter/material.dart';
import 'package:form_flow/controller/dashboard_controller.dart';
import 'package:get/get.dart';
import '../app_state.dart';
import '../widgets/data_table_widget.dart';



class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${controller.deliveryName}"),
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
          child: GetX<DashboardController>(
            builder: (controller) {
              return DataTableWidget(
                data: controller.trips.toList(),
                selectedDate: controller.selectedDate.value,
                onDateChange: controller.setSelectedDate,
                onAddNew: () => controller.showAddDialog(context),
                onEdit: controller.showEditDialog,
                onCopy: controller.handleCopy,
                onDelete: controller.showDeleteDialog,
                onSave: controller.handleSave,
              );
            },
          ),
        ),
      ),
    );
  }
}
