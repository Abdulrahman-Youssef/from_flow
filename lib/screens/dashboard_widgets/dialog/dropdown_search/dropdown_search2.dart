
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class ReusableSearchableDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final Function(String?) onChanged;
  final String labelText;
  final String? hintText;
  final String? searchHint;
  final String? Function(String?)? validator;
  final bool enabled;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? maxHeight;
  final Color? backgroundColor;
  final double elevation;

  const ReusableSearchableDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    required this.labelText,
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
    return DropdownSearch<String>(
      items: (filter, infiniteScrollProps) async {
        // Return filtered items based on search
        if (filter.isEmpty) {
          return items;
        }
        return items
            .where((item) =>
            item.toLowerCase().contains(filter.toLowerCase()))
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
              item,
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
