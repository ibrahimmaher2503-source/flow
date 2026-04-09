import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/sms_provider.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/loading_shimmer.dart';
import 'widgets/sms_tile.dart';

class SmsInboxScreen extends ConsumerWidget {
  const SmsInboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smsAsync = ref.watch(allDetectedSmsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('رسائل البنوك'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              refreshSmsProviders(ref);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          refreshSmsProviders(ref);
          // Wait a bit for the providers to refresh
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: smsAsync.when(
          data: (smsList) {
            if (smsList.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 100),
                  EmptyState(
                    icon: Icons.sms,
                    message:
                        'مفيش رسائل مكتشفة\nالتطبيق هيكتشف رسائل البنوك تلقائياً',
                  ),
                ],
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: smsList.length,
              itemBuilder: (context, index) {
                final sms = smsList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SmsTile(
                    sms: sms,
                    onTap: () {
                      if (sms.status == 'pending') {
                        Navigator.pushNamed(
                          context,
                          '/sms/confirmation',
                          arguments: sms.id,
                        );
                      }
                    },
                  ),
                );
              },
            );
          },
          loading: () => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 5,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: LoadingShimmer(
                height: 80,
                borderRadius: 16,
              ),
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: isDark ? AppColors.danger : AppColors.lightDanger,
                ),
                const SizedBox(height: 16),
                Text(
                  'حدث خطأ في تحميل الرسائل',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: isDark
                        ? AppColors.textSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => refreshSmsProviders(ref),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
