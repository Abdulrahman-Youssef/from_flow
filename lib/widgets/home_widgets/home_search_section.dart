import 'package:flutter/material.dart';

class SearchAndSortBar extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onSortChanged;
  final String currentSortBy;

  const SearchAndSortBar({
    super.key,
    required this.onSearchChanged,
    required this.onSortChanged,
    required this.currentSortBy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Search Text Field
          Expanded(
            flex: 3,
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search deliveries...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Sort By Dropdown
          Expanded(
            child: DropdownButtonFormField<String>(
              value: currentSortBy,
              decoration: InputDecoration(
                labelText: 'Sort by',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              items: const [
                DropdownMenuItem(value: 'date', child: Text('Date')),
                DropdownMenuItem(value: 'name', child: Text('Name')),
                DropdownMenuItem(value: 'trips', child: Text('Trips Count')),
              ],
              onChanged: onSortChanged,
            ),
          ),
        ],
      ),
    );
  }
}