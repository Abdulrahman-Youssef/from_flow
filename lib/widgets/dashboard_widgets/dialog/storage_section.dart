import 'package:flutter/material.dart';
import 'package:form_flow/models/storage_data.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/add_edit_dialog_controller.dart';
import 'package:get/get.dart';

import 'dropdown_search/dropdown_search2.dart';
Widget buildStorageSection(int index) {
  final controller = Get.find<AddEditDialogController>();

  // StorageModel storage = controller.selectedStorages[index]; // <-- Corrected

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
            if (controller.selectedStorages.length > 1)
              IconButton(
                onPressed: () => controller.removeStorage(index),
                icon: Icon(Icons.delete, color: Colors.red),
                constraints: BoxConstraints(),
                padding: EdgeInsets.all(4),
              ),
          ],
        ),
        SizedBox(height: 16),
        Obx( ()=> ReusableSearchableDropdown<StorageModel>(
          // <-- Corrected
          items: controller.storageOptions,
          selectedItem: controller.selectedStorages[index].name == null ? null : controller.selectedStorages[index],
          labelText: "Storage Name",
          hintText: "Select storage...",
          searchHint: "Search storage...",
          prefixIcon: Icon(Icons.warehouse),
          itemAsString: (StorageModel item) => item.name ?? '',
          // <-- Corrected
          // --- FIX: ADDED compareFn ---
          compareFn: (item1, item2) => item1 == item2,
          onChanged: (StorageModel? value) {
            // <-- Corrected
            if (value != null) {
              controller.selectedStorages[index] = value;
            }
          },
          validator: (StorageModel? value) => // <-- Corrected
          value == null || value.name == null
              ? 'Please select a storage'
              : null,
        )),
      ],
    ),
  );
}
