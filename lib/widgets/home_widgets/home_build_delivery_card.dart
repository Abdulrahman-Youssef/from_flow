import 'package:flutter/material.dart';
import 'package:form_flow/models/delivery_model.dart';
import 'package:form_flow/models/responses/delivery_summary_response.dart';
import 'package:form_flow/widgets/home_widgets/home_build_mini_state.dart';
import 'package:intl/intl.dart';

Widget buildDeliveryCard({
  required DeliverySummary delivery,
  required void Function(int deliveryID) onDeliveryTap,
  required void Function(int id) onDeleteTap,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      onTap: () => onDeliveryTap(delivery.deliveryId),
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
                    delivery.deliveryName,
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
                    DateFormat('dd/MM').format(delivery.deliveryDate),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 18,
                    splashRadius: 20,
                    icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
                    onPressed: () => onDeleteTap(delivery.deliveryId),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              DateFormat('EEEE, dd MMMM yyyy').format(delivery.deliveryDate),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 12),

            // 2x2 Stats Grid
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
                const SizedBox(width: 8),
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
            const SizedBox(height: 8),
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
                const SizedBox(width: 8),
                Expanded(
                  child: buildMiniStat(
                    delivery.storagesCount.toString(),
                    'Storages',
                    'مخازن',
                    Icons.warehouse,
                    Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Divider
            Divider(
              color: Colors.grey.shade300,
              thickness: 1,
              height: 1,
            ),

            const SizedBox(height: 10),

            // Created/Edited By Section
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    delivery.editedBy != null && delivery.editedBy!.isNotEmpty
                        ? 'Created by ${delivery.createdBy} • Edited by ${delivery.editedBy}'
                        : 'Created by ${delivery.createdBy}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}