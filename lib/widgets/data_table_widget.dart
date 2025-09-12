import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/supplier_data.dart';
import 'package:file_picker/file_picker.dart';

class DataTableWidget extends StatelessWidget {
  final List<SupplierData> data;
  final DateTime selectedDate;
  final Function(DateTime) onDateChange;
  final VoidCallback onAddNew;
  final Function(SupplierData, BuildContext) onEdit;
  final Function(int) onCopy;
  final Function(SupplierData) onDelete;
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

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  Future<void> _handleExport(BuildContext context) async {
    try {
      // First prepare the CSV content in memory
      final String csvContent = _generateCsvContent();

      // Show the save file dialog
      String? savePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save CSV Export',
        fileName:
            'supply-chain-data-${DateFormat('yyyy-MM-dd').format(selectedDate)}.csv',
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      // If user cancelled the dialog, do nothing
      if (savePath == null || savePath.isEmpty) {
        return;
      }

      // Ensure the file has .csv extension
      if (!savePath.endsWith('.csv')) {
        savePath = '$savePath.csv';
      }

      // Write the file to the selected path
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

// Helper function to generate CSV content
  String _generateCsvContent() {
    final headers = [
      'Row Number',
      'Shipment Date',
      'Supplier Name',
      'Storage Name',
      'Vehicle NO',
      'Procurement Specialist',
      'fleet supervisor',
      'Actual Arrive Date',
      'Actual Departure Date',
      'Waiting hours'
    ];

    final csvContent = StringBuffer();
    csvContent.writeln(headers.join(','));

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final row = [
        (i + 1).toString(),
        DateFormat('dd/MM/yyyy').format(selectedDate),
        '"${item.supplierName}"',
        '"${item.storageName}"',
        item.vehicleCode,
        '"${item.procurementSpecialist}"',
        '"${item.fleetSupervisor}"',
        '"${_formatDateTime(item.actualArriveDate)}"',
        '"${_formatDateTime(item.actualDepartureDate)}"',
        item.waitingTime
      ];
      csvContent.writeln(row.join(','));
    }

    return csvContent.toString();
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
                  child: Text(
                    'Supply Chain Management',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (picked != null) {
                            onDateChange(picked);
                          }
                        },
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(selectedDate),
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
                        onPressed: onAddNew,
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
                        onPressed: onSave,
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
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: WidgetStateColor.resolveWith(
                    (states) => Color(0xFFF9FAFB),
                  ),
                  columns: [
                    DataColumn(
                        label: Text('#',
                            style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(
                        label: Text('Supplier Name',
                            style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(
                        label: Text('Storage Name',
                            style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(
                        label: Text('vehicle NO',
                            style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(
                        label: Text('Procurement Specialist',
                            style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(
                        label: Text('fleet Supervisor',
                            style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(
                        label: Text('Actual Arrive Date',
                            style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(
                        label: Text('Actual Departure Date',
                            style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(
                        label: Text('Waiting Hours',
                            style: TextStyle(fontWeight: FontWeight.w600))),
                    DataColumn(
                        label: Text('Actions',
                            style: TextStyle(fontWeight: FontWeight.w600))),
                  ],
                  rows: data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return DataRow(
                      cells: [
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('${index + 1}'),
                          ),
                        ),
                        DataCell(Text(item.supplierName)),
                        DataCell(Text(item.storageName)),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade500,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(item.vehicleCode),
                          ),
                        ),
                        DataCell(Text(item.procurementSpecialist)),
                        DataCell(Text(item.fleetSupervisor)),
                        DataCell(Text(_formatDateTime(item.actualArriveDate))),
                        DataCell(Text(_formatDateTime(item.actualDepartureDate))),
                        DataCell(
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${item.waitingTime} Hours:mints',
                              style: TextStyle(color: Colors.blue.shade700),
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, size: 16),
                                onPressed: () => onEdit(item, context),
                                tooltip: 'Edit record',
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.blue.shade50,
                                  foregroundColor: Colors.blue.shade600,
                                  minimumSize: Size(32, 32),
                                ),
                              ),
                              SizedBox(width: 4),
                              IconButton(
                                icon: Icon(Icons.copy, size: 16),
                                onPressed: () => onCopy(item.id),
                                tooltip: 'Copy record',
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.green.shade50,
                                  foregroundColor: Colors.green.shade600,
                                  minimumSize: Size(32, 32),
                                ),
                              ),
                              SizedBox(width: 4),
                              IconButton(
                                icon: Icon(Icons.delete, size: 16),
                                onPressed: () => onDelete(item),
                                tooltip: 'Delete record',
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.red.shade50,
                                  foregroundColor: Colors.red.shade600,
                                  minimumSize: Size(32, 32),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
