import 'package:flutter/material.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/add_edit_dialog_controller.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/storage_section.dart';
import 'package:get/get.dart';

Widget buildStoragesSection() {
  final controller = Get.find<AddEditDialogController>();

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
      Obx(() => Column(
        // mainAxisSize: MainAxisSize.min, // Prevents layout errors
        children: [
          ...List.generate(
              controller.selectedStorages.length, // This is now reactive
                  (index) => buildStorageSection(index)
          ),
        ],
      )),
      SizedBox(height: 8),
      Center(
        child: OutlinedButton.icon(
          onPressed: controller.addAnotherStorage,
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
