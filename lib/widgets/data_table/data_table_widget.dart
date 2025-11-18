import 'package:flutter/material.dart';
import 'package:form_flow/models/trip_data.dart';
import 'package:form_flow/screens/Dashboard/dashboard_controller.dart';
import 'package:get/get.dart';
import '../dashboard_widgets/dashboard_build_expanded_details.dart';
import '../dashboard_widgets/dashboard_build_responsive_header.dart';

class DataTableWidget extends GetView<DashboardController> {
  const DataTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Header (fixed)
          Obx(
            () => Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF1E3A8A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: BuildResponsiveHeader(
                tripCount: controller.trips.length,
                totalSuppliers: controller.totalSuppliers.value,
                totalStorages: controller.totalStorages.value,
                totalVehicles: controller.trips.length,
                selectedDate: controller.selectedDeliveryDate.value,
                onDateChange: controller.setSelectedDeliveryDate,
                onAddNew: () => controller.showAddDialog(context),
                onSave: controller.saveAndExit,
                onExport: () => controller.handleExport(context),
              ),
            ),
          ),

          // Table content with proper scrolling
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, // Primary vertical scroll
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Secondary horizontal scroll
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 1000
                      ? MediaQuery.of(context).size.width - 32
                      : 1000, // Fixed minimum width for horizontal scroll
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Table Header
                        Container(
                          color: Color(0xFFF9FAFB),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                SizedBox(width: 20),
                                // Space for expand button
                                Expanded(
                                  flex: 1,
                                  child: Text('Trip #',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text('Vehicle NO',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Storage Name',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text('Suppliers',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text('Procurement Specialist',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text('Fleet Supervisor',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text('Trip Duration',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text('Actions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Table Rows
                        ...List.generate(controller.trips.length, (index) {
                          final trip = controller.trips[index];
                          return Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      // Trip # and Expand/Collapse button
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                trip.isExpanded
                                                    ? Icons.keyboard_arrow_down
                                                    : Icons
                                                        .keyboard_arrow_right,
                                                size: 20,
                                              ),
                                              onPressed: () => controller
                                                  .toggleExpansion(index),
                                              style: IconButton.styleFrom(
                                                backgroundColor:
                                                    Colors.grey.shade100,
                                                minimumSize: Size(32, 32),
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        Colors.grey.shade300),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text('${index + 1}'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Vehicle NO
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade500,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Center(
                                            child: Text(
                                              trip.vehicle.vehicleCode,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Storage
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: _buildStorageCell(trip),
                                        ),
                                      ),
                                      // Suppliers
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: _buildSupplierCell(trip),
                                        ),
                                      ),
                                      // Procurement Specialist
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text(
                                            trip.procurementSpecialist.name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // Fleet Supervisor
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text(
                                            trip.fleetSupervisor.name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      // Trip Duration
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Center(
                                            child: Text(

                                              '${trip.totalWaitingTime} Hours',
                                              style: TextStyle(
                                                  color: Colors.blue.shade700),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Actions
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit, size: 16),
                                              onPressed: () =>
                                                  controller.showEditDialog(
                                                      trip, context),
                                              tooltip: 'Edit record',
                                              style: IconButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blue.shade50,
                                                foregroundColor:
                                                    Colors.blue.shade600,
                                                minimumSize: Size(28, 28),
                                                padding: EdgeInsets.zero,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.copy, size: 16),
                                              onPressed: () => controller
                                                  .handleCopy(trip.id!),
                                              tooltip: 'Copy record',
                                              style: IconButton.styleFrom(
                                                backgroundColor:
                                                    Colors.green.shade50,
                                                foregroundColor:
                                                    Colors.green.shade600,
                                                minimumSize: Size(28, 28),
                                                padding: EdgeInsets.zero,
                                              ),
                                            ),
                                            IconButton(
                                              icon:
                                                  Icon(Icons.delete, size: 16),
                                              onPressed: () => controller
                                                  .showDeleteDialog(trip),
                                              tooltip: 'Delete record',
                                              style: IconButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red.shade50,
                                                foregroundColor:
                                                    Colors.red.shade600,
                                                minimumSize: Size(28, 28),
                                                padding: EdgeInsets.zero,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Expanded supplier details
                              if (trip.isExpanded)
                                SizedBox(
                                  width: double.infinity,
                                  child: buildExpandedDetails(
                                      trip, controller.formatDateTime),
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Helper widget for storage cell
  Widget _buildStorageCell(TripData trip) {
    if (trip.storages.length == 1) {
      return Text(
        trip.storages.first.name ?? 'Unknown',
        overflow: TextOverflow.ellipsis,
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.purple.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '${trip.storages.length} Storages',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Colors.purple.shade700,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }

// Helper widget for supplier cell
  Widget _buildSupplierCell(TripData trip) {
    if (trip.suppliers.length == 1) {
      return Text(
        trip.suppliers.first.supplierName ?? 'Unknown',
        overflow: TextOverflow.ellipsis,
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '${trip.suppliers.length} suppliers',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade700,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
  }
}
