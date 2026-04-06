import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'widgets/balance_card.dart';
import 'widgets/quick_stats.dart';
import 'widgets/streak_badge.dart';
import 'widgets/installment_summary_card.dart';
import 'widgets/recent_transactions.dart';
import 'widgets/upcoming_recurring.dart';
import 'widgets/finance_score_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlowSpend'),
        centerTitle: true,
      ),
      body: AnimationLimiter(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: const [
                BalanceCard(),
                SizedBox(height: 12),
                FinanceScoreCard(),
                SizedBox(height: 12),
                StreakBadge(),
                SizedBox(height: 12),
                QuickStats(),
                SizedBox(height: 16),
                InstallmentSummaryCard(),
                SizedBox(height: 16),
                RecentTransactions(),
                SizedBox(height: 16),
                UpcomingRecurring(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
