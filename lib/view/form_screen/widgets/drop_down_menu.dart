import 'package:flutter/material.dart';

Widget buildDropdown({
  required String label,
  required String? value,
  required List<String> options,
  required Function(String?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            hint: Text('Select $label'),
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ],
  );
}