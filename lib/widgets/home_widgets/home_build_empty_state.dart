import 'package:flutter/material.dart';

Widget buildEmptyState({void Function()? onAddNewDelivery}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.local_shipping_outlined,
          size: 64,
          color: Colors.grey.shade400,
        ),
        SizedBox(height: 16),
        Text(
          'No deliveries found',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Create your first delivery to get started',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
        SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: onAddNewDelivery,
          icon: Icon(Icons.add),
          label: Text('Create New Delivery'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    ),
  );
}
