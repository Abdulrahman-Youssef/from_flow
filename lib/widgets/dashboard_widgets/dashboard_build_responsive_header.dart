import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildResponsiveHeader extends StatelessWidget {
  final int tripCount;
  final int totalSuppliers;
  final int totalStorages;
  final int totalVehicles;
  final DateTime selectedDate;
  final Function(DateTime) onDateChange;
  final VoidCallback onAddNew;
  final VoidCallback onSave;
  final VoidCallback onExport;

  const BuildResponsiveHeader({
    super.key,
    required this.tripCount,
    required this.totalSuppliers,
    required this.totalStorages,
    required this.totalVehicles,
    required this.selectedDate,
    required this.onDateChange,
    required this.onAddNew,
    required this.onSave,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 1200; // Breakpoint for compact layout
    final isVeryCompact = screenWidth < 800; // Breakpoint for very compact layout

    if (isVeryCompact) {
      // Stack layout for very small screens
      return Column(
        children: [
          // First row: Title and stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Stats container
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$tripCount Trip${tripCount != 1 ? 's' : ''} • $totalSuppliers Supplier${totalSuppliers != 1 ? 's' : ''} • $totalStorages Storage${totalStorages != 1 ? 's' : ''}• $totalVehicles vehicle${totalVehicles != 1 ? 's' : ''}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const Spacer(),
                // Date picker
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        onDateChange(picked);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd/MM/yyyy').format(selectedDate),
                          style: const TextStyle(
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
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onAddNew,
                    icon: const Icon(Icons.add, size: 14),
                    label: const Text('Add', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onSave,
                    icon: const Icon(Icons.save, size: 14),
                    label: const Text('Save', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.9),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onExport,
                    icon: const Icon(Icons.file_download, size: 14),
                    label: const Text('Export', style: TextStyle(fontSize: 12)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withOpacity(0.9),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Stats section
          if (!isCompact)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$tripCount Trip${tripCount != 1 ? 's' : ''} • $totalSuppliers Supplier${totalSuppliers != 1 ? 's' : ''} • $totalStorages Storage${totalStorages != 1 ? 's' : ''}• $totalVehicles vehicle${totalVehicles != 1 ? 's' : ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${tripCount}T • ${totalSuppliers}S',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const Spacer(),

          // Date picker
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 8 : 12,
              vertical: isCompact ? 6 : 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  onDateChange(picked);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, color: Colors.white, size: isCompact ? 14 : 16),
                  SizedBox(width: isCompact ? 4 : 8),
                  Text(
                    DateFormat(isCompact ? 'dd/MM' : 'dd/MM/yyyy').format(selectedDate),
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
          const SizedBox(width: 16),

          // Action buttons
          if (!isCompact) ...[
            ElevatedButton.icon(
              onPressed: onAddNew,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add New'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.save, size: 16),
              label: const Text('Save All'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.9),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: onExport,
              icon: const Icon(Icons.file_download, size: 16),
              label: const Text('Export Excel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(0.9),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ] else ...[
            ElevatedButton.icon(
              onPressed: onAddNew,
              icon: const Icon(Icons.add, size: 14),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.1),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
            ),
            const SizedBox(width: 6),
            ElevatedButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.save, size: 14),
              label: const Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.9),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
            ),
            const SizedBox(width: 6),
            ElevatedButton(
              onPressed: onExport,
              child: const Icon(Icons.file_download, size: 14),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(0.9),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}