import 'package:flutter/material.dart';

import '../../models/trip_data.dart';

Widget buildExpandedDetails(TripData trip , String Function(DateTime)  formatDateTime) {
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
                        ? formatDateTime(supplier.planArriveDate!)
                        : 'Not set',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    supplier.actualArriveDate != null
                        ? formatDateTime(supplier.actualArriveDate!)
                        : 'Not set',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    supplier.actualDepartureDate != null
                        ? formatDateTime(supplier.actualDepartureDate!)
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
                // if(false )
                  // SizedBox(
                  //   width: 108,
                  //   child: Row(
                  //     mainAxisSize: MainAxisSize.min,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       IconButton(
                  //         icon: Icon(Icons.edit, size: 14),
                  //         onPressed: () => widget.onEdit(trip, context),
                  //         tooltip: 'Edit trip',
                  //         style: IconButton.styleFrom(
                  //           backgroundColor: Colors.blue.shade50,
                  //           foregroundColor: Colors.blue.shade600,
                  //           minimumSize: Size(28, 28),
                  //           padding: EdgeInsets.zero,
                  //         ),
                  //       ),
                  //       SizedBox(width: 4),
                  //       IconButton(
                  //         icon: Icon(Icons.delete, size: 14),
                  //         onPressed: () => widget.onDelete(trip),
                  //         tooltip: 'Delete trip',
                  //         style: IconButton.styleFrom(
                  //           backgroundColor: Colors.red.shade50,
                  //           foregroundColor: Colors.red.shade600,
                  //           minimumSize: Size(28, 28),
                  //           padding: EdgeInsets.zero,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                // SizedBox(width: 8),
              ],
            ),
          );
        }),
      ],
    ),
  );
}
