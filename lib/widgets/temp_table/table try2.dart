import 'package:flutter/material.dart';
import 'package:form_flow/models/supplier_data.dart';
import 'package:form_flow/models/trip_data.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

// class TripData {
//   final String vehicleCode;
//   final String storageName;
//   final String procurementSpecialist;
//   final String fleetSupervisor;
//   // final List<trip> suppliers;
//   final List<SupplierData> suppliers;
//   bool isExpanded;
//
//   TripData({
//     required this.vehicleCode,
//     required this.storageName,
//     required this.procurementSpecialist,
//     required this.fleetSupervisor,
//     required this.suppliers,
//     this.isExpanded = false,
//   });
//
//   DateTime? get earliestArrival => suppliers
//       .map((s) => s.actualArriveDate)
//       .reduce((a, b) => a!.isBefore(b!) ? a : b);
//
//   DateTime? get latestDeparture => suppliers
//       .map((s) => s.actualDepartureDate)
//       .reduce((a, b) => a!.isAfter(b!) ? a : b);
//
//   String get totalWaitingTime {
//     final difference = latestDeparture!.difference(earliestArrival!);
//     final hours = difference.inHours;
//     final minutes = difference.inMinutes.remainder(60);
//     return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
//   }
//
//   String get suppliersList {
//     if (suppliers.length == 1) {
//       return suppliers.first.supplierName!;
//     } else {
//       return '${suppliers.first.supplierName} (+${suppliers.length - 1} more)';
//     }
//   }
// }

class DataTableWidget extends StatefulWidget {
  final List<TripData> data;
  final DateTime selectedDate;
  final Function(DateTime) onDateChange;
  final VoidCallback onAddNew;
  final Function(TripData, BuildContext) onEdit;
  final Function(int) onCopy;
  final Function(TripData) onDelete;
  final VoidCallback onSave;

  const DataTableWidget({
    super.key,
    required this.data,
    required this.selectedDate,
    required this.onDateChange,
    required this.onAddNew,
    required this.onEdit,
    required this.onCopy,
    required this.onDelete,
    required this.onSave,
  });

  @override
  _DataTableWidgetState createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  List<TripData> _trips = [];

  @override
  void initState() {
    super.initState();
    _groupDataIntoTrips();
  }

  @override
  void didUpdateWidget(DataTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _groupDataIntoTrips();
    }
  }

  void _groupDataIntoTrips() {
    // Group by vehicle code and basic trip info
    Map<String, List<TripData>> tripGroups = {};

    for (var trip in widget.data) {
      String tripKey = '${trip.vehicleCode}-${trip.storageName}-${trip.procurementSpecialist}-${trip.fleetSupervisor}';

      if (!tripGroups.containsKey(tripKey)) {
        tripGroups[tripKey] = [];
      }
      tripGroups[tripKey]!.add(trip);
    }

    // Convert to TripData objects and sort suppliers within each trip
    _trips = tripGroups.entries.map((entry) {
      var tripsList = entry.value;
      // Sort suppliers by arrival date within each trip
      tripsList.sort((a, b) => a.suppliers.first.actualArriveDate!.compareTo(b.suppliers.first.actualArriveDate!));

      return TripData(
        vehicleCode: tripsList.first.vehicleCode,
        storageName: tripsList.first.storageName,
        procurementSpecialist: tripsList.first.procurementSpecialist,
        fleetSupervisor: tripsList.first.fleetSupervisor,
        suppliers: tripsList.first.suppliers, id: null,
      );
    }).toList();

    // Sort trips by earliest arrival time
    // _trips.sort((a, b) => a.earliestArrival!.compareTo(b.earliestArrival!));

    setState(() {});
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  Future<void> _handleExport(BuildContext context) async {
    try {
      final String csvContent = _generateCsvContent();

      String? savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save CSV Export',
        fileName:
        'supply-chain-trips-${DateFormat('yyyy-MM-dd').format(widget.selectedDate)}.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (savePath == null || savePath.isEmpty) {
        return;
      }

      if (!savePath.endsWith('.csv')) {
        savePath = '$savePath.csv';
      }

      final file = File(savePath);
      await file.writeAsString(csvContent);

      Get.snackbar(
        'Success',
        'Excel file exported successfully to: ${file.path}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error exporting file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String _generateCsvContent() {
    final headers = [
      'Trip #',
      'Vehicle NO',
      'Storage Name',
      'Procurement Specialist',
      'Fleet Supervisor',
      'Suppliers Count',
      'Earliest Arrival',
      'Latest Departure',
      'Total Trip Time',
      'Supplier Details'
    ];

    final csvContent = StringBuffer();
    csvContent.writeln(headers.join(','));

    for (int i = 0; i < _trips.length; i++) {
      final trip = _trips[i];
      final supplierDetails = trip.suppliers.map((s) =>
      '${s.supplierName} (${_formatDateTime(s.actualArriveDate!)} - ${_formatDateTime(s.actualDepartureDate!)})'
      ).join('; ');

      final row = [
        (i + 1).toString(),
        trip.vehicleCode,
        '"${trip.storageName}"',
        '"${trip.procurementSpecialist}"',
        '"${trip.fleetSupervisor}"',
        trip.suppliers.length.toString(),
        // '"${_formatDateTime(trip.earliestArrival!)}"',
        // '"${_formatDateTime(trip.latestDeparture!)}"',
        // trip.totalWaitingTime,
        '"$supplierDetails"'
      ];
      csvContent.writeln(row.join(','));
    }

    return csvContent.toString();
  }

  void _toggleExpansion(int index) {
    setState(() {
      _trips[index].isExpanded = !_trips[index].isExpanded;
    });
  }

  Widget _buildExpandedSupplierDetails(TripData trip) {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Suppliers Details (${trip.suppliers.length} suppliers)',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
          ...trip.suppliers.asMap().entries.map((entry) {
            final index = entry.key;
            final supplier = entry.value;
            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: index < trip.suppliers.length - 1
                      ? BorderSide(color: Colors.grey.shade200)
                      : BorderSide.none,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: Text(
                      supplier.supplierName!,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      _formatDateTime(supplier.actualArriveDate!),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      _formatDateTime(supplier.actualDepartureDate!),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        supplier.waitingTime,
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, size: 14),
                        onPressed: () => widget.onEdit(_trips.first, context),
                        tooltip: 'Edit supplier',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.blue.shade50,
                          foregroundColor: Colors.blue.shade600,
                          minimumSize: Size(28, 28),
                        ),
                      ),
                      SizedBox(width: 4),
                      IconButton(
                        icon: Icon(Icons.copy, size: 14),
                        onPressed: () => widget.onCopy(supplier.id!),
                        tooltip: 'Copy supplier',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.green.shade50,
                          foregroundColor: Colors.green.shade600,
                          minimumSize: Size(28, 28),
                        ),
                      ),
                      SizedBox(width: 4),
                      IconButton(
                        icon: Icon(Icons.delete, size: 14),
                        onPressed: () => widget.onDelete(trip),
                        tooltip: 'Delete supplier',
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red.shade600,
                          minimumSize: Size(28, 28),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1E3A8A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Title section
                Expanded(
                  flex: 8,
                  child: Row(
                    children: [
                      Text(
                        'Supply Chain Management',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 16),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${_trips.length} Trip${_trips.length != 1 ? 's' : ''} • ${widget.data.length} Supplier${widget.data.length != 1 ? 's' : ''}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Date picker section
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: widget.selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (picked != null) {
                            widget.onDateChange(picked);
                          }
                        },
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(widget.selectedDate),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                // Action buttons section
                Expanded(
                  flex: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: widget.onAddNew,
                        icon: Icon(Icons.add, size: 16),
                        label: Text('Add New'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: widget.onSave,
                        icon: Icon(Icons.save, size: 16),
                        label: Text('Save All'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.withOpacity(0.9),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => _handleExport(context),
                        icon: Icon(Icons.file_download, size: 16),
                        label: Text('Export Excel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.withOpacity(0.9),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Table content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Table Header
                  Container(
                    color: Color(0xFFF9FAFB),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          SizedBox(width: 40), // Space for expand button
                          Expanded(flex: 1, child: Text('Trip #', style: TextStyle(fontWeight: FontWeight.w600))),
                          Expanded(flex: 2, child: Text('Vehicle NO', style: TextStyle(fontWeight: FontWeight.w600))),
                          Expanded(flex: 2, child: Text('Storage Name', style: TextStyle(fontWeight: FontWeight.w600))),
                          Expanded(flex: 3, child: Text('Suppliers', style: TextStyle(fontWeight: FontWeight.w600))),
                          Expanded(flex: 2, child: Text('Procurement Specialist', style: TextStyle(fontWeight: FontWeight.w600))),
                          Expanded(flex: 2, child: Text('Fleet Supervisor', style: TextStyle(fontWeight: FontWeight.w600))),
                          Expanded(flex: 2, child: Text('Trip Duration', style: TextStyle(fontWeight: FontWeight.w600))),
                          Expanded(flex: 1, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600))),
                        ],
                      ),
                    ),
                  ),
                  // Table Rows
                  ...List.generate(_trips.length, (index) {
                    final trip = _trips[index];
                    return Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Expand/Collapse button
                                SizedBox(
                                  width: 40,
                                  child: IconButton(
                                    icon: Icon(
                                      trip.isExpanded
                                          ? Icons.keyboard_arrow_down
                                          : Icons.keyboard_arrow_right,
                                      size: 20,
                                    ),
                                    onPressed: () => _toggleExpansion(index),
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.grey.shade100,
                                      minimumSize: Size(32, 32),
                                    ),
                                  ),
                                ),
                                // Trip #
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text('${index + 1}'),
                                  ),
                                ),
                                // Vehicle NO
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade500,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(trip.vehicleCode, style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                // Storage Name
                                Expanded(flex: 2, child: Text(trip.storageName)),
                                // Suppliers
                                Expanded(
                                  flex: 3,
                                  child: Row(
                                    children: [
                                      Expanded(child: Text("trip.suppliersList")),
                                      // Expanded(child: Text(trip.suppliersList)),
                                      if (trip.suppliers.length > 1)
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade100,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '${trip.suppliers.length}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                // Procurement Specialist
                                Expanded(flex: 2, child: Text(trip.procurementSpecialist)),
                                // Fleet Supervisor
                                Expanded(flex: 2, child: Text(trip.fleetSupervisor)),
                                // Trip Duration
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      // '${trip.totalWaitingTime} Hours',
                                      'not yet Hours',
                                      style: TextStyle(color: Colors.blue.shade700),
                                    ),
                                  ),
                                ),
                                // Actions
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'View Details',
                                    style: TextStyle(
                                      color: Colors.blue.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Expanded supplier details
                        if (trip.isExpanded) _buildExpandedSupplierDetails(trip),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}