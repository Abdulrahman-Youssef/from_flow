import 'package:flutter/material.dart';

// The header is now a function that accepts parameters for its data and actions.
Widget homeHeaderSection({
  required VoidCallback onAddNewDelivery,
  required int totalDeliveries,
}) {
  return Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFF1E3A8A),
          Color(0xFF3B82F6),
        ],
      ),
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supply Chain Management',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'إدارة سلسلة التوريد',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: onAddNewDelivery, // Use the parameter here
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('New Delivery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1E3A8A),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Stats Row
            Row(
              children: [
                // Pass the delivery count from the parameter
                _buildStatCard(
                  'Total Deliveries',
                  'إجمالي التوريدات',
                  totalDeliveries.toString(), // Use the parameter here
                  Icons.local_shipping,
                  const Color.fromRGBO(255, 255, 255, 0.2),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// A sample implementation for _buildStatCard so the code is complete.
Widget _buildStatCard(String title, String titleArabic, String value, IconData icon, Color backgroundColor) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromRGBO(255, 255, 255, 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            titleArabic,
            style: const TextStyle(
              fontSize: 10,
              color: Color.fromRGBO(255, 255, 255, 0.6),
            ),
          ),
        ],
      ),
    ),
  );
}