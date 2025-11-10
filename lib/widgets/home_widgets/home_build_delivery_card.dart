import 'package:flutter/material.dart';
import 'package:form_flow/models/delivery_model.dart';
import 'package:form_flow/widgets/home_widgets/home_build_mini_state.dart';
import 'package:intl/intl.dart';

Widget buildDeliveryCard({
  required SupplyDeliveryData delivery,
  required void Function(SupplyDeliveryData) onDeliveryTap,
  required void Function(int id) onDeleteTap, // Added delete callback
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      onTap: () => onDeliveryTap(delivery),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with name, date, and delete button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    delivery.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateFormat('dd/MM').format(delivery.date),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ),
                // **** START: DELETE BUTTON ADDED ****
                SizedBox(
                  width: 28,
                  height: 28,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 18,
                    splashRadius: 20,
                    icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
                    onPressed: () => onDeleteTap(delivery.id),
                  ),
                ),
                // **** END: DELETE BUTTON ADDED ****
              ],
            ),

            const SizedBox(height: 8),

            Text(
              DateFormat('EEEE, dd MMMM yyyy').format(delivery.date),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            // Stats Grid (no changes below this line)
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
                const SizedBox(width: 6),
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
            const SizedBox(height: 6),
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
                const SizedBox(width: 6),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}