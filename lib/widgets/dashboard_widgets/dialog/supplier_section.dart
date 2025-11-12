import 'package:flutter/material.dart';
import 'package:form_flow/models/supplier_data.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/add_edit_dialog_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dropdown_search/dropdown_search2.dart';

Widget buildSupplierSection(int index) {
  final controller = Get.find<AddEditDialogController>();

  return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(
        () {
          SupplierModel supplier =
              controller.selectedSuppliers[index]; // <-- Corrected

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Supplier ${index + 1}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                  if (controller.selectedSuppliers.length > 1)
                    IconButton(
                      onPressed: () => controller.removeSupplier(index),
                      icon: Icon(Icons.delete, color: Colors.red),
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(4),
                    ),
                ],
              ),
              SizedBox(height: 16),
              ReusableSearchableDropdown<SupplierModel>(
                // <-- Corrected

                items: controller.supplierOptions,
                selectedItem: supplier.supplierName == null ? null : supplier,
                labelText: "Supplier Name",
                hintText: "Select supplier...",
                searchHint: "Search supplier...",
                prefixIcon: Icon(Icons.business),
                itemAsString: (SupplierModel item) => item.supplierName ?? '',
                compareFn: (item1, item2) => item1 == item2,
                onChanged: (SupplierModel? value) {
                  if (value != null) {
                    controller.selectedSuppliers[index] =
                        controller.selectedSuppliers[index].copyWith(
                      id: value.id,
                      supplierName: value.supplierName,
                    );
                  }
                },
                validator: (SupplierModel? value) => // <-- Corrected
                    value == null || value.supplierName == null
                        ? 'Please select a supplier'
                        : null,
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () =>
                    controller.selectDateTime(index, DateType.planArrive),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Plan Arrive Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    supplier.planArriveDate != null
                        ? DateFormat('dd-MM-yyyy HH:mm')
                            .format(supplier.planArriveDate!)
                        : 'Select date and time',
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.selectDateTime(
                          index, DateType.actualArrive),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Actual Arrive Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          supplier.actualArriveDate != null
                              ? DateFormat('dd-MM-yyyy HH:mm')
                                  .format(supplier.actualArriveDate!)
                              : 'Select date and time',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => controller.selectDateTime(
                          index, DateType.actualDeparture),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Actual Departure Date',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          supplier.actualDepartureDate != null
                              ? DateFormat('dd-MM-yyyy HH:mm')
                                  .format(supplier.actualDepartureDate!)
                              : 'Select date and time',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ));
}
