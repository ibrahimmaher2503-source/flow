import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../core/theme/app_spacing.dart';
import 'widgets/dashboard_header.dart';
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
      body: SafeArea(
        child: AnimationLimiter(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Custom app bar area with padding
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  top: AppSpacing.lg,
                ),
                sliver: SliverToBoxAdapter(
                  child: AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      verticalOffset: 30.0,
                      child: FadeInAnimation(
                        child: const DashboardHeader(),
                      ),
                    ),
                  ),
                ),
              ),

              // Main content
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 400),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: 40.0,
                        child: FadeInAnimation(child: widget),
                      ),
                      children: const [
                        // Balance Card - Hero section
                        BalanceCard(),
                        SizedBox(height: AppSpacing.lg),

                        // Streak badge (conditional)
                        StreakBadge(),
                        SizedBox(height: AppSpacing.lg),

                        // Finance Score
                        FinanceScoreCard(),
                        SizedBox(height: AppSpacing.lg),

                        // Quick Stats row
                        QuickStats(),
                        SizedBox(height: AppSpacing.xxl),

                        // Installments Summary
                        InstallmentSummaryCard(),
                        SizedBox(height: AppSpacing.xxl),

                        // Recent Transactions
                        RecentTransactions(),
                        SizedBox(height: AppSpacing.xxl),

                        // Upcoming Recurring
                        UpcomingRecurring(),

                        // Bottom padding for FAB clearance
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
