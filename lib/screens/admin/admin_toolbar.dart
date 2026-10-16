import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Search box + All / Fish / Chicken chips used on Products, Prices and Stock pages.
class AdminCatalogueToolbar extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onCategoryChanged;

  const AdminCatalogueToolbar({
    super.key,
    required this.selectedCategory,
    required this.onQueryChanged,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        onChanged: onQueryChanged,
        decoration: InputDecoration(
          hintText: 'Find a cut or catch...',
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17),
            borderSide: const BorderSide(color: AppColors.textSecondary, width: 1.4),
          ),
        ),
      ),
      const SizedBox(height: 13),
      Wrap(
        spacing: 8,
        children: ['All', 'Fish', 'Chicken']
            .map(
              (label) => ChoiceChip(
                label: Text(label.toUpperCase()),
                selected: selectedCategory == label,
                onSelected: (_) => onCategoryChanged(label),
                showCheckmark: false,
                labelStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                  color: selectedCategory == label ? Colors.white : AppColors.textPrimary,
                ),
                selectedColor: AppColors.textPrimary,
                backgroundColor: AppColors.surface,
                side: BorderSide(
                  color: selectedCategory == label ? AppColors.textPrimary : AppColors.border,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )
            .toList(),
      ),
    ],
  );
}
