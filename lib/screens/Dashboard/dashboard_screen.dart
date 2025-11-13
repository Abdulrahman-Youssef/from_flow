import 'package:flutter/material.dart';
import 'package:form_flow/widgets/dashboard_widgets/dashboard_controller.dart';
import 'package:get/get.dart';
import '../../widgets/data_table/data_table_widget.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                  onPressed: controller.showEditNameDialog,
                  icon: Icon(
                    Icons.mode_edit_outline_outlined,
                    size: 25,
                  )),
              SizedBox(
                width: 5,
              ),
              Obx(() => Text("${controller.deliveryName}")),
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  // Icon(Icons.person, size: 20),
                  // SizedBox(width: 8),
                  // Text('Admin User'),
                ],
              ),
            ),
            // IconButton(
            //   icon: Icon(Icons.settings),
            //   onPressed: () {},
            // ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Get.back();
              },
            ),
            SizedBox(width: 8),
          ],
        ),
        body: Container(
            color: Color(0xFFF9FAFB),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child:
                  // GetX<DashboardController>(
                  //   builder:
                  //       (controller) {
                  //     return
                  DataTableWidget(),
            )));
  }

// ),
}
