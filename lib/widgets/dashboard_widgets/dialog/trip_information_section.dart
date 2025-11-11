import 'package:flutter/material.dart';
import 'package:form_flow/models/vehicle_model.dart';
import 'package:form_flow/widgets/dashboard_widgets/dialog/add_edit_dialog_controller.dart';
import 'package:get/get.dart';

import '../../../models/fleet_supervisors_model.dart';
import '../../../models/procurement_specialists_model.dart';
import 'dropdown_search/dropdown_search2.dart';

Widget buildTripInformationSection() {
  final controller = Get.find<AddEditDialogController>();
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade700,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ReusableSearchableDropdown<VehicleModel>(
                items: controller.vehicleNOOptions,
                selectedItem: controller.selectedVehicle.value,
                labelText: "Vehicle Number",
                hintText: "Select vehicle...",
                searchHint: "Search vehicle...",
                prefixIcon: Icon(Icons.local_shipping),
                itemAsString: (VehicleModel item) => item.vehicleCode,
                // --- FIX: ADDED compareFn ---
                compareFn: (item1, item2) => item1 == item2,
                onChanged: (VehicleModel? value) {
                  controller.selectedVehicle.value = value;
                },
                validator: (VehicleModel? value) =>
                value == null ? 'Please select a vehicle number' : null,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ReusableSearchableDropdown<FleetSupervisorsModel>(
                items: controller.fleetSupervisors,
                selectedItem: controller.selectedSupervisor.value,
                labelText: "Fleet Supervisor",
                hintText: "Select supervisor...",
                searchHint: "Search supervisor...",
                prefixIcon: Icon(Icons.supervised_user_circle),
                itemAsString: (FleetSupervisorsModel item) => item.name,
                // --- FIX: ADDED compareFn ---
                compareFn: (item1, item2) => item1 == item2,
                onChanged: (FleetSupervisorsModel? value) {
                  controller.selectedSupervisor.value = value;
                },
                validator: (FleetSupervisorsModel? value) =>
                value == null ? 'Please select a supervisor' : null,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ReusableSearchableDropdown<ProcurementSpecialistsModel>(
          items: controller.procurementSpecialists,
          selectedItem: controller.selectedProcurementSpecialist.value,
          labelText: "Procurement Specialist",
          hintText: "Select specialist...",
          searchHint: "Search specialist...",
          prefixIcon: Icon(Icons.person),
          itemAsString: (ProcurementSpecialistsModel item) => item.name,
          // --- FIX: ADDED compareFn ---
          compareFn: (item1, item2) => item1 == item2,
          onChanged: (ProcurementSpecialistsModel? value) {
            controller.selectedProcurementSpecialist.value = value;
          },
          validator: (ProcurementSpecialistsModel? value) =>
          value == null ? 'Please select a specialist' : null,
        ),
        SizedBox(height: 16),
        TextField(
          controller: controller.noteController,
          decoration: InputDecoration(
            labelText: 'Note',
            hintText: 'Write your note here...',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          onTapOutside: (tap) {
            // replace with function i the controller
            controller.note.value = controller.noteController.text.toString();
          },
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
        ),
      ],
    ),
  );
}
