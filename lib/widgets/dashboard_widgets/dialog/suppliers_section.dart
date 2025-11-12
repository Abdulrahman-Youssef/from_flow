import 'package:flutter/material.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/add_edit_dialog_controller.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/supplier_section.dart';
import 'package:get/get.dart';

Widget buildSuppliersSection() {
  final controller = Get.find<AddEditDialogController>();

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
      Obx(() => Column(
        mainAxisSize: MainAxisSize.min, // Prevents layout errors
        children: [
          ...List.generate(
              controller.suppliers.length, // This is now reactive
                  (index) => buildSupplierSection(index)
          ),
        ],
      )),
      SizedBox(height: 8),
      Center(
        child: OutlinedButton.icon(
          onPressed: controller.addAnotherSupplier,
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
