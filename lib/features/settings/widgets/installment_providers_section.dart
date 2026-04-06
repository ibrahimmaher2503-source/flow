import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/icon_resolver.dart';
import '../../../data/models/installment_provider_model.dart';
import '../../../providers/installment_provider.dart';

class InstallmentProvidersSection extends ConsumerWidget {
  const InstallmentProvidersSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providersAsync = ref.watch(installmentProvidersListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, right: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'مقدمي التقسيط',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle,
                    color: AppColors.primary, size: 24),
                onPressed: () => _showAddProviderDialog(context, ref),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: providersAsync.when(
            data: (providers) => Column(
              children: providers
                  .map((p) => _providerTile(context, ref, p))
                  .toList(),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('$e'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _providerTile(
      BuildContext context, WidgetRef ref, InstallmentProvider provider) {
    final color = provider.color.toColor;
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(IconResolver.resolve(provider.icon), color: color, size: 20),
      ),
      title: Text(provider.name,
          style: const TextStyle(fontFamily: 'Cairo', color: Colors.white)),
      subtitle: provider.creditLimit != null
          ? Text('ليمت: ${provider.creditLimit!.toStringAsFixed(0)} جنيه',
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 12,
                  color: AppColors.textMuted))
          : null,
      trailing: IconButton(
        icon:
            const Icon(Icons.delete_outline, color: AppColors.textMuted, size: 20),
        onPressed: () async {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: AppColors.surface,
              title: Text('حذف ${provider.name}؟',
                  style: const TextStyle(
                      fontFamily: 'Cairo', color: Colors.white)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child:
                      const Text('لا', style: TextStyle(fontFamily: 'Cairo')),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('نعم',
                      style: TextStyle(
                          fontFamily: 'Cairo', color: AppColors.danger)),
                ),
              ],
            ),
          );
          if (confirmed == true) {
            await ref
                .read(installmentRepoProvider)
                .deleteProvider(provider.id);
            refreshInstallments(ref);
          }
        },
      ),
    );
  }

  void _showAddProviderDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final limitController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('إضافة مقدم تقسيط',
            style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style:
                  const TextStyle(fontFamily: 'Cairo', color: Colors.white),
              decoration: const InputDecoration(hintText: 'الاسم'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: limitController,
              keyboardType: TextInputType.number,
              style:
                  const TextStyle(fontFamily: 'Cairo', color: Colors.white),
              decoration:
                  const InputDecoration(hintText: 'الليمت (اختياري)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء',
                style: TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.isEmpty) return;
              final limit = double.tryParse(limitController.text);
              await ref.read(installmentRepoProvider).addProvider(
                    InstallmentProvider()
                      ..name = nameController.text
                      ..icon = 'credit_card'
                      ..color = '#6C63FF'
                      ..creditLimit = limit
                      ..createdAt = DateTime.now(),
                  );
              refreshInstallments(ref);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('إضافة',
                style: TextStyle(
                    fontFamily: 'Cairo', color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
