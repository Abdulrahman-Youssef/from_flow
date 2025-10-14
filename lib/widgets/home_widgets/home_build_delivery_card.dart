import 'package:flutter/material.dart';
import 'package:form_flow/models/shipment_model.dart';
import 'package:form_flow/widgets/home_widgets/home_build_mini_state.dart';
import 'package:intl/intl.dart';

Widget buildDeliveryCard({required SupplyDeliveryData delivery ,required void Function(SupplyDeliveryData) onDeliveryTap }) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      onTap: () => onDeliveryTap(delivery),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with name and date
            Row(
              children: [
                Expanded(
                  child: Text(
                    delivery.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF1E3A8A).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateFormat('dd/MM').format(delivery.date),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            Text(
              DateFormat('EEEE, dd MMMM yyyy').format(delivery.date),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 12),
            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: buildMiniStat(
                    delivery.tripsCount.toString(),
                    'Trips',
                    'رحلات',
                    Icons.route,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 6),
                Expanded(
                  child: buildMiniStat(
                    delivery.suppliersCount.toString(),
                    'Suppliers',
                    'موردين',
                    Icons.business,
                    Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: buildMiniStat(
                    delivery.vehiclesCount.toString(),
                    'Vehicles',
                    'مركبات',
                    Icons.local_shipping,
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 6),
                Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}