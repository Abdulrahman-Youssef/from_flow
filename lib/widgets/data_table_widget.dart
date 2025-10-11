import 'package:flutter/material.dart';
import 'package:form_flow/models/trip_data.dart';
import 'package:form_flow/screens/dashboard_widgets/dashboard_build_expanded_details.dart';
import 'package:form_flow/screens/dashboard_widgets/dashboard_build_responsive_header.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

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
  int? _totalSuppliers;
  int? _totalStorages;

  @override
  void initState() {
    super.initState();
    _sortSuppliersByDateInTrip();
    _getTotalSuppliers();
    _getStorages();
  }

  @override
  void didUpdateWidget(DataTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _sortSuppliersByDateInTrip();
    }
    _getTotalSuppliers();
    _getStorages();
  }

  void _sortSuppliersByDateInTrip() {
    widget.data.sort((a, b) => a.suppliers.first.actualArriveDate!
        .compareTo(b.suppliers.first.actualArriveDate!));
    _trips = widget.data;
    setState(() {});
  }

  void _getTotalSuppliers() {
    int totalCount = 0;

    if (_trips.isEmpty) return;

    for (var trip in _trips) {
      totalCount += trip.suppliers.length;
    }
    _totalSuppliers = totalCount;
  }

  void _getStorages() {
    int totalCount = 0;

    if (_trips.isEmpty) return;

    for (var trip in _trips) {
      totalCount += trip.storages.length;
    }
    _totalStorages = totalCount;
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
      final supplierDetails = trip.suppliers
          .map((s) =>
              '${s.supplierName} (${_formatDateTime(s.actualArriveDate!)} - ${_formatDateTime(s.actualDepartureDate!)})')
          .join('; ');
      final storageDetails = trip.storages.map((s) => '${s.name}').join('; ');

      final row = [
        (i + 1).toString(),
        trip.vehicleCode,
        '"$storageDetails"',
        '"${trip.procurementSpecialist}"',
        '"${trip.fleetSupervisor}"',
        trip.suppliers.length.toString(),
        '"${_formatDateTime(trip.earliestArrival!)}"',
        '"${_formatDateTime(trip.latestDeparture!)}"',
        trip.totalWaitingTime,
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



  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Header (fixed)
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1E3A8A),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: BuildResponsiveHeader(
              tripCount: _trips.length,
              totalSuppliers: _totalSuppliers ?? 0,
              totalStorages: _totalStorages ?? 0,
              totalVehicles: _trips.length,
              selectedDate: widget.selectedDate,
              onDateChange: widget.onDateChange,
              onAddNew: widget.onAddNew,
              onSave: widget.onSave,
              onExport: () => _handleExport(context),
            ),
          ),

          // Table content with proper scrolling
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, // Primary vertical scroll
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Secondary horizontal scroll
                child: Container(
                  width: MediaQuery.of(context).size.width > 1000
                      ? MediaQuery.of(context).size.width - 32
                      : 1000, // Fixed minimum width for horizontal scroll
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Table Header
                      Container(
                        color: Color(0xFFF9FAFB),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            children: [
                              SizedBox(width: 20), // Space for expand button
                              Expanded(
                                flex: 1,
                                child: Text('Trip #',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text('Vehicle NO',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('Storage Name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text('Fleet Supervisor',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ),
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
                                                  : Icons.keyboard_arrow_right,
                                              size: 20,
                                            ),
                                            onPressed: () =>
                                                _toggleExpansion(index),
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
                                                  color: Colors.grey.shade300),
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
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade500,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            trip.vehicleCode,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Storage
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: _buildStorageCell(trip),
                                      ),
                                    ),
                                    // Suppliers
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: _buildSupplierCell(trip),
                                      ),
                                    ),
                                    // Procurement Specialist
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          trip.procurementSpecialist,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    // Fleet Supervisor
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: Text(
                                          trip.fleetSupervisor,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    // Trip Duration
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin:
                                            EdgeInsets.symmetric(horizontal: 4),
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
                                                widget.onEdit(trip, context),
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
                                            onPressed: () =>
                                                widget.onCopy(trip.id!),
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
                                            icon: Icon(Icons.delete, size: 16),
                                            onPressed: () =>
                                                widget.onDelete(trip),
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
                              Container(
                                width: double.infinity,
                                child:
                                    buildExpandedDetails(trip, _formatDateTime),
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
