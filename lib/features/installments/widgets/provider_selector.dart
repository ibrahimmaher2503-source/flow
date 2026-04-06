import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/icon_resolver.dart';
import '../../../data/models/installment_provider_model.dart';
import '../../../providers/installment_provider.dart';

class ProviderSelector extends ConsumerWidget {
  final int? selectedProviderId;
  final ValueChanged<InstallmentProvider> onSelected;

  const ProviderSelector({
    super.key,
    this.selectedProviderId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providersAsync = ref.watch(installmentProvidersListProvider);

    return providersAsync.when(
      data: (providers) => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: providers.map((p) {
          final isSelected = selectedProviderId == p.id;
          final color = p.color.toColor;

          return GestureDetector(
            onTap: () => onSelected(p),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.3)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: color, width: 2)
                    : Border.all(color: AppColors.textMuted.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(IconResolver.resolve(p.icon), color: color, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    p.name,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('$e'),
    );
  }
}
