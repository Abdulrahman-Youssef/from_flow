import 'package:flutter/material.dart';
import 'package:form_flow/models/trip_data.dart';
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

      final row = [
        (i + 1).toString(),
        trip.vehicleCode,
        '"trip.storageName"',
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

  Widget _buildExpandedDetails(TripData trip) {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Storage Section
          Container(
            margin: EdgeInsetsGeometry.directional(bottom: 10),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Storages (${trip.storages.length} storage${trip.storages.length != 1 ? 's' : ''})',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.purple.shade700,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: trip.storages.asMap().entries.map((entry) {
                    final index = entry.key;
                    final storage = entry.value;
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.purple.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.purple.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            storage.name ?? 'Unknown Storage',
                            style: TextStyle(
                              color: Colors.purple.shade700,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Suppliers Section Header
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
            ),
            child: Row(
              children: [
                Container(width: 24),
                SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Text(
                    'Suppliers Details (${trip.suppliers.length} supplier${trip.suppliers.length != 1 ? 's' : ''})',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Plan Arrive Date",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Actual Arrive Date",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Actual Departure Date",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Waiting Time",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                if(false)
                SizedBox(
                  width: 108,
                  child: Text(
                    "Actions",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
          ),

          // Suppliers Rows
          ...trip.suppliers.asMap().entries.map((entry) {
            final index = entry.key;
            final supplier = entry.value;
            return Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: index < trip.suppliers.length - 1
                      ? BorderSide(color: Colors.grey.shade300)
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
                      supplier.supplierName ?? 'Unknown Supplier',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      supplier.planArriveDate != null
                          ? _formatDateTime(supplier.planArriveDate!)
                          : 'Not set',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      supplier.actualArriveDate != null
                          ? _formatDateTime(supplier.actualArriveDate!)
                          : 'Not set',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      supplier.actualDepartureDate != null
                          ? _formatDateTime(supplier.actualDepartureDate!)
                          : 'Not set',
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
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Text(
                        supplier.waitingTime ?? '00:00',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  //actions
                  if(false )
                  SizedBox(
                    width: 108,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, size: 14),
                          onPressed: () => widget.onEdit(trip, context),
                          tooltip: 'Edit trip',
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.blue.shade50,
                            foregroundColor: Colors.blue.shade600,
                            minimumSize: Size(28, 28),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        SizedBox(width: 4),
                        IconButton(
                          icon: Icon(Icons.delete, size: 14),
                          onPressed: () => widget.onDelete(trip),
                          tooltip: 'Delete trip',
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red.shade600,
                            minimumSize: Size(28, 28),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResponsiveHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 1200; // Breakpoint for compact layout
    final isVeryCompact =
        screenWidth < 800; // Breakpoint for very compact layout

    if (isVeryCompact) {
      // Stack layout for very small screens
      return Column(
        children: [
          // First row: Title and stats
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Stats container
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_trips.length} Trip${_trips.length != 1 ? 's' : ''} • $_totalSuppliers Supplier${_totalSuppliers != 1 ? 's' : ''} •  $_totalStorages Supplier${_totalStorages != 1 ? 's' : ''}• ${_trips.length} vehicle${_trips.length != 1 ? 's' : ''} ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Spacer(),
                // Date picker
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GestureDetector(
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          DateFormat('dd/MM/yyyy').format(widget.selectedDate),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Second row: Action buttons
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onAddNew,
                    icon: Icon(Icons.add, size: 14),
                    label: Text('Add', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: widget.onSave,
                    icon: Icon(Icons.save, size: 14),
                    label: Text('Save', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.withValues(alpha: 0.9),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    ),
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleExport(context),
                    icon: Icon(Icons.file_download, size: 14),
                    label: Text('Export', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withValues(alpha: 0.9),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // Single row layout for larger screens
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          // Stats section - adapts based on screen size
          if (!isCompact) ...[
            // Full stats for large screens
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_trips.length} Trip${_trips.length != 1 ? 's' : ''} • $_totalSuppliers Supplier${_totalSuppliers != 1 ? 's' : ''} •  $_totalStorages Storage${_totalStorages != 1 ? 's' : ''}• ${_trips.length} vehicle${_trips.length != 1 ? 's' : ''} ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ] else ...[
            // Compact stats for medium screens
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_trips.length}T • ${widget.data.length}S',
                // T=Trips, S=Suppliers
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],

          // Flexible spacer
          Expanded(child: SizedBox(width: 16)),

          // Date picker - always visible but adapts size
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 8 : 12, vertical: isCompact ? 6 : 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: GestureDetector(
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today,
                      color: Colors.white, size: isCompact ? 14 : 16),
                  SizedBox(width: isCompact ? 4 : 8),
                  Text(
                    DateFormat(isCompact ? 'dd/MM' : 'dd/MM/yyyy')
                        .format(widget.selectedDate),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: isCompact ? 12 : 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 16),

          // Action buttons - adapt based on screen size
          if (!isCompact) ...[
            // Full buttons for large screens
            ElevatedButton.icon(
              onPressed: widget.onAddNew,
              icon: Icon(Icons.add, size: 16),
              label: Text('Add New'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: widget.onSave,
              icon: Icon(Icons.save, size: 16),
              label: Text('Save All'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withValues(alpha: 0.9),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _handleExport(context),
              icon: Icon(Icons.file_download, size: 16),
              label: Text('Export Excel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withValues(alpha: 0.9),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ] else ...[
            // Compact buttons for medium screens
            ElevatedButton.icon(
              onPressed: widget.onAddNew,
              icon: Icon(Icons.add, size: 14),
              label: Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
            ),
            SizedBox(width: 6),
            ElevatedButton.icon(
              onPressed: widget.onSave,
              icon: Icon(Icons.save, size: 14),
              label: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withValues(alpha: 0.9),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
            ),
            SizedBox(width: 6),
            ElevatedButton(
              onPressed: () => _handleExport(context),
              child: Icon(Icons.file_download, size: 14),
              // Icon only for very compact
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withValues(alpha: 0.9),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
            ),
          ],
        ],
      ),
    );
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
            child: _buildResponsiveHeader(context),
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
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text('Vehicle NO',
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('Storage Name',
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text('Suppliers',
                                      style: TextStyle(fontWeight: FontWeight.w600)),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('Procurement Specialist',
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text('Fleet Supervisor',
                                    style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text('Trip Duration',
                                      style: TextStyle(fontWeight: FontWeight.w600)),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text('Actions',
                                    style: TextStyle(fontWeight: FontWeight.w600)),
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
                                  bottom: BorderSide(color: Colors.grey.shade200),
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
                                            onPressed: () => _toggleExpansion(index),
                                            style: IconButton.styleFrom(
                                              backgroundColor: Colors.grey.shade100,
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
                                              borderRadius: BorderRadius.circular(4),
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
                                        margin: EdgeInsets.symmetric(horizontal: 4),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade500,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            trip.vehicleCode,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Storage
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4),
                                        child: _buildStorageCell(trip),
                                      ),
                                    ),
                                    // Suppliers
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4),
                                        child: _buildSupplierCell(trip),
                                      ),
                                    ),
                                    // Procurement Specialist
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 4),
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
                                        padding: EdgeInsets.symmetric(horizontal: 4),
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
                                        margin: EdgeInsets.symmetric(horizontal: 4),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(4),
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
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit, size: 16),
                                            onPressed: () =>
                                                widget.onEdit(trip, context),
                                            tooltip: 'Edit record',
                                            style: IconButton.styleFrom(
                                              backgroundColor: Colors.blue.shade50,
                                              foregroundColor: Colors.blue.shade600,
                                              minimumSize: Size(28, 28),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.copy, size: 16),
                                            onPressed: () => widget.onCopy(trip.id!),
                                            tooltip: 'Copy record',
                                            style: IconButton.styleFrom(
                                              backgroundColor: Colors.green.shade50,
                                              foregroundColor: Colors.green.shade600,
                                              minimumSize: Size(28, 28),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete, size: 16),
                                            onPressed: () => widget.onDelete(trip),
                                            tooltip: 'Delete record',
                                            style: IconButton.styleFrom(
                                              backgroundColor: Colors.red.shade50,
                                              foregroundColor: Colors.red.shade600,
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
                                child: _buildExpandedDetails(trip),
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