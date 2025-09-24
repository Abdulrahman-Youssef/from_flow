// import 'package:flutter/material.dart';
// import 'package:form_flow/models/trip_data.dart';
//
// Widget _buildResponsiveHeader(BuildContext context ,List<TripData> trips) {
//   _trips
//   final screenWidth = MediaQuery.of(context).size.width;
//   final isCompact = screenWidth < 1200; // Breakpoint for compact layout
//   final isVeryCompact =
//       screenWidth < 800; // Breakpoint for very compact layout
//
//   if (isVeryCompact) {
//     // Stack layout for very small screens
//     return Column(
//       children: [
//         // First row: Title and stats
//         Padding(
//           padding: EdgeInsets.all(16),
//           child: Row(
//             children: [
//               // Stats container
//               Flexible(
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     '${trips.length} Trip${trips.length != 1 ? 's' : ''} • $_totalSuppliers Supplier${_totalSuppliers != 1 ? 's' : ''} •  $_totalStorages Supplier${_totalStorages != 1 ? 's' : ''}• ${trips.length} vehicle${trips.length != 1 ? 's' : ''} ',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ),
//               Spacer(),
//               // Date picker
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: GestureDetector(
//                   onTap: () async {
//                     final DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: widget.selectedDate,
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime.now().add(Duration(days: 365)),
//                     );
//                     if (picked != null) {
//                       widget.onDateChange(picked);
//                     }
//                   },
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.calendar_today,
//                           color: Colors.white, size: 14),
//                       SizedBox(width: 4),
//                       Text(
//                         DateFormat('dd/MM/yyyy').format(widget.selectedDate),
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Second row: Action buttons
//         Padding(
//           padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
//           child: Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: widget.onAddNew,
//                   icon: Icon(Icons.add, size: 14),
//                   label: Text('Add', style: TextStyle(fontSize: 12)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white.withValues(alpha: 0.1),
//                     foregroundColor: Colors.white,
//                     elevation: 0,
//                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 6),
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: widget.onSave,
//                   icon: Icon(Icons.save, size: 14),
//                   label: Text('Save', style: TextStyle(fontSize: 12)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green.withValues(alpha: 0.9),
//                     foregroundColor: Colors.white,
//                     elevation: 0,
//                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 6),
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: () => _handleExport(context),
//                   icon: Icon(Icons.file_download, size: 14),
//                   label: Text('Export', style: TextStyle(fontSize: 12)),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue.withValues(alpha: 0.9),
//                     foregroundColor: Colors.white,
//                     elevation: 0,
//                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Single row layout for larger screens
//   return Padding(
//     padding: EdgeInsets.all(16),
//     child: Row(
//       children: [
//         // Stats section - adapts based on screen size
//         if (!isCompact) ...[
//           // Full stats for large screens
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               '${trips.length} Trip${trips.length != 1 ? 's' : ''} • $_totalSuppliers Supplier${_totalSuppliers != 1 ? 's' : ''} •  $_totalStorages Storage${_totalStorages != 1 ? 's' : ''}• ${trips.length} vehicle${trips.length != 1 ? 's' : ''} ',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ] else ...[
//           // Compact stats for medium screens
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: Colors.white.withValues(alpha: 0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               '${trips.length}T • ${widget.data.length}S',
//               // T=Trips, S=Suppliers
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//
//         // Flexible spacer
//         Expanded(child: SizedBox(width: 16)),
//
//         // Date picker - always visible but adapts size
//         Container(
//           padding: EdgeInsets.symmetric(
//               horizontal: isCompact ? 8 : 12, vertical: isCompact ? 6 : 8),
//           decoration: BoxDecoration(
//             color: Colors.white.withValues(alpha: 0.1),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: GestureDetector(
//             onTap: () async {
//               final DateTime? picked = await showDatePicker(
//                 context: context,
//                 initialDate: widget.selectedDate,
//                 firstDate: DateTime.now(),
//                 lastDate: DateTime.now().add(Duration(days: 365)),
//               );
//               if (picked != null) {
//                 widget.onDateChange(picked);
//               }
//             },
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.calendar_today,
//                     color: Colors.white, size: isCompact ? 14 : 16),
//                 SizedBox(width: isCompact ? 4 : 8),
//                 Text(
//                   DateFormat(isCompact ? 'dd/MM' : 'dd/MM/yyyy')
//                       .format(widget.selectedDate),
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500,
//                     fontSize: isCompact ? 12 : 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         SizedBox(width: 16),
//
//         // Action buttons - adapt based on screen size
//         if (!isCompact) ...[
//           // Full buttons for large screens
//           ElevatedButton.icon(
//             onPressed: widget.onAddNew,
//             icon: Icon(Icons.add, size: 16),
//             label: Text('Add New'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white.withValues(alpha: 0.1),
//               foregroundColor: Colors.white,
//               elevation: 0,
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             ),
//           ),
//           SizedBox(width: 8),
//           ElevatedButton.icon(
//             onPressed: widget.onSave,
//             icon: Icon(Icons.save, size: 16),
//             label: Text('Save All'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green.withValues(alpha: 0.9),
//               foregroundColor: Colors.white,
//               elevation: 0,
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             ),
//           ),
//           SizedBox(width: 8),
//           ElevatedButton.icon(
//             onPressed: () => _handleExport(context),
//             icon: Icon(Icons.file_download, size: 16),
//             label: Text('Export Excel'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue.withValues(alpha: 0.9),
//               foregroundColor: Colors.white,
//               elevation: 0,
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             ),
//           ),
//         ] else ...[
//           // Compact buttons for medium screens
//           ElevatedButton.icon(
//             onPressed: widget.onAddNew,
//             icon: Icon(Icons.add, size: 14),
//             label: Text('Add'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.white.withValues(alpha: 0.1),
//               foregroundColor: Colors.white,
//               elevation: 0,
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             ),
//           ),
//           SizedBox(width: 6),
//           ElevatedButton.icon(
//             onPressed: widget.onSave,
//             icon: Icon(Icons.save, size: 14),
//             label: Text('Save'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green.withValues(alpha: 0.9),
//               foregroundColor: Colors.white,
//               elevation: 0,
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             ),
//           ),
//           SizedBox(width: 6),
//           ElevatedButton(
//             onPressed: () => _handleExport(context),
//             child: Icon(Icons.file_download, size: 14),
//             // Icon only for very compact
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue.withValues(alpha: 0.9),
//               foregroundColor: Colors.white,
//               elevation: 0,
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//             ),
//           ),
//         ],
//       ],
//     ),
//   );
// }
