import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

enum TransactionFilter { all, income, expense, installment }

class FilterBar extends StatelessWidget {
  final TransactionFilter selected;
  final ValueChanged<TransactionFilter> onChanged;

  const FilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: TransactionFilter.values.map((filter) {
          final isSelected = selected == filter;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(
                _label(filter),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onSelected: (_) => onChanged(filter),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _label(TransactionFilter filter) {
    switch (filter) {
      case TransactionFilter.all:
        return 'الكل';
      case TransactionFilter.income:
        return 'دخل';
      case TransactionFilter.expense:
        return 'مصروف';
      case TransactionFilter.installment:
        return 'أقساط';
    }
  }
}
