import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

// 1. Make the class generic with <T>
class ReusableSearchableDropdown<T> extends StatelessWidget {
  final List<T> items; // <-- CHANGED
  final T? selectedItem; // <-- CHANGED
  final Function(T?) onChanged; // <-- CHANGED
  final String labelText;
  final String? hintText;
  final String? searchHint;
  final String? Function(T?)? validator; // <-- CHANGED
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? maxHeight;
  final Color? backgroundColor;
  final double elevation;

  final bool Function(T?, T?)? compareFn;
  // 2. Add a function to convert your object 'T' to a string
  final String Function(T item) itemAsString; // <-- NEW & REQUIRED

  const ReusableSearchableDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    required this.labelText,
    required this.itemAsString, // <-- NEW & REQUIRED
     this.compareFn,
    this.hintText,
    this.searchHint,
    this.validator,
    this.enabled = true,
    this.prefixIcon,
    this.suffixIcon,
    this.maxHeight = 200,
    this.backgroundColor = Colors.white,
    this.elevation = 8,
  });

  @override
  Widget build(BuildContext context) {
    // 3. Change DropdownSearch<String> to <T>
    return DropdownSearch<T>(
      // 4. Update filtering logic
      items: (filter, infiniteScrollProps) async {
        if (filter.isEmpty) {
          return items;
        }
        // Use itemAsString to filter
        return items
            .where((item) => itemAsString(item) // <-- CHANGED
            .toLowerCase()
            .contains(filter.toLowerCase()))
            .toList();
      },
      selectedItem: selectedItem,
      enabled: enabled,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          hintText: hintText ?? 'Select $labelText...',
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
      compareFn: compareFn,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: searchHint ?? 'Search $labelText...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        menuProps: MenuProps(
          backgroundColor: backgroundColor,
          elevation: elevation,
        ),
        constraints: BoxConstraints(maxHeight: maxHeight!),
        // 5. Update the item builder
        itemBuilder: (context, item, isDisabled, isSelected) {
          return Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade50 : null,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Text(
              itemAsString(item), // <-- CHANGED
              style: TextStyle(
                color: isDisabled ? Colors.grey : Colors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
      onChanged: onChanged,
      validator: validator,
    );
  }
}