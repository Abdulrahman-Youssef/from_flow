import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class ReusableSearchableDropdown extends StatefulWidget {
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
  final bool showClearButton;

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
    this.maxHeight = 300,
    this.backgroundColor,
    this.elevation = 4,
    this.showClearButton = true,
  });

  @override
  State<ReusableSearchableDropdown> createState() => _ReusableSearchableDropdownState();
}

class _ReusableSearchableDropdownState extends State<ReusableSearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return DropdownSearch<String>(
      items:(filter, infiniteScrollProps) async {
        // Return filtered items based on search
        if (filter.isEmpty) {
          return widget.items;
        }
        return widget.items
            .where((item) =>
            item.toLowerCase().contains(filter.toLowerCase()))
            .toList();
      },
      selectedItem: widget.selectedItem,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      validator: widget.validator,

      // Main dropdown field styling
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText ?? 'Select or type to search...',
          prefixIcon: widget.prefixIcon ?? const Icon(Icons.search, size: 20),
          suffixIcon: widget.showClearButton ? IconButton(
            icon: const Icon(Icons.clear, size: 18),
            onPressed: () {
              _searchController.clear();
              widget.onChanged(null);
            },
          ) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
          ),
          filled: true,
          fillColor: widget.enabled
              ? (isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50)
              : Colors.grey.shade200,
        ),
      ),

      // Popup properties with integrated search
      popupProps: PopupProps.modalBottomSheet(
        showSearchBox: true,
        searchDelay: Duration(milliseconds: 300),

        // Search field styling
        searchFieldProps: TextFieldProps(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: widget.searchHint ?? 'Search ${widget.labelText.toLowerCase()}...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),

        // Modal styling
        modalBottomSheetProps: ModalBottomSheetProps(
          backgroundColor: widget.backgroundColor ?? theme.scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          constraints: BoxConstraints(maxHeight: widget.maxHeight!),
        ),

        // List item styling
        itemBuilder: (context, item,  isDisabled ,isSelected  ) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Text(
              item,
              style: TextStyle(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            trailing: isSelected ? Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
              size: 20,
            ) : null,
          ),
        ),

        // Empty state
        emptyBuilder: (context, searchEntry) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_off,
                  size: 48,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No results found',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                if (searchEntry.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '"$searchEntry"',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
