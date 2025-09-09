import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildDateField({
  required String label,
  required DateTime? date,
  required Function() onTap,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      SizedBox(height: 4),
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                date != null
                    ? DateFormat('yyyy-MM-dd').format(date)
                    : 'Select $label',
                style: TextStyle(
                  color: date != null ? Colors.black : Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
