import 'package:flutter/material.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/add_edit_dialog_controller.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/storages_section.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/suppliers_section.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/trip_information_section.dart';
import 'package:get/get.dart';

class AddEditDialog extends GetView<AddEditDialogController> {
  const AddEditDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.8,
        height: MediaQuery
            .of(context)
            .size
            .height * 0.9,
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        // Header
        Text(
        controller.dialogTitle,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 8),
      Text(
        controller.dialogSupTitle,
        style: TextStyle(
          color: Colors.grey.shade600,
        ),
      ),
      SizedBox(height: 24),
      // Form
      Expanded(
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildTripInformationSection(),
                SizedBox(height: 24),
                buildStoragesSection(),
                SizedBox(height: 24),
                buildSuppliersSection(),
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
            onPressed: () => controller.handleCancel(context),
            child: Text('Cancel'),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => controller.handleSave(context),
            child: Text('Save'),
          ),
        ],
      ),
      ],
    ),)
    ,
    );
  }
}
