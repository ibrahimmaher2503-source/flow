import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../providers/wallet_provider.dart';
import '../../../providers/transaction_provider.dart';
import '../../../l10n/generated/app_localizations.dart';

class BalanceCard extends ConsumerStatefulWidget {
  const BalanceCard({super.key});

  @override
  ConsumerState<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends ConsumerState<BalanceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalBalance = ref.watch(totalBalanceProvider);
    final income = ref.watch(monthlyIncomeProvider);
    final expense = ref.watch(monthlyExpenseProvider);
    final l10n = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                Color(0xFF6C63FF),
                Color(0xFF5B52E5),
                Color(0xFF4F46E5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl + 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 32,
                offset: const Offset(0, 16),
                spreadRadius: -8,
              ),
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 64,
                offset: const Offset(0, 32),
                spreadRadius: -16,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Animated shimmer overlay
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl + 4),
                  child: CustomPaint(
                    painter: _ShimmerPainter(
                      progress: _shimmerController.value,
                    ),
                  ),
                ),
              ),

              // Decorative elements
              ..._buildDecorations(),

              // Main content
              Column(
                children: [
                  // Balance label with icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          size: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.labelTotalBalanceFull,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Balance amount
                  totalBalance.when(
                    data: (val) => _AnimatedBalance(value: val),
                    loading: () => const _BalanceShimmer(),
                    error: (_, __) => const Text(
                      '--',
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Income / Expense pills
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatPill(
                            label: l10n.labelMonthIncome,
                            value: income,
                            icon: Icons.arrow_downward_rounded,
                            color: AppColors.secondary,
                            isIncome: true,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        Expanded(
                          child: _StatPill(
                            label: l10n.labelMonthExpense,
                            value: expense,
                            icon: Icons.arrow_upward_rounded,
                            color: const Color(0xFFFF6B8A),
                            isIncome: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildDecorations() {
    return [
      // Top-right large circle
      Positioned(
        top: -40,
        right: -40,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.12),
                Colors.white.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
      // Bottom-left medium circle
      Positioned(
        bottom: -30,
        left: -30,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.white.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
      // Small accent circle
      Positioned(
        top: 40,
        left: 20,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.secondary.withValues(alpha: 0.4),
          ),
        ),
      ),
    ];
  }
}

class _ShimmerPainter extends CustomPainter {
  final double progress;

  _ShimmerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.05),
          Colors.white.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
        transform: GradientRotation(math.pi / 4),
      ).createShader(
        Rect.fromLTWH(
          size.width * (progress * 2 - 1),
          0,
          size.width,
          size.height,
        ),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ShimmerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _AnimatedBalance extends StatelessWidget {
  final double value;

  const _AnimatedBalance({required this.value});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return Text(
          CurrencyFormatter.format(animatedValue),
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 38,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -1,
            height: 1.1,
          ),
        );
      },
    );
  }
}

class _BalanceShimmer extends StatelessWidget {
  const _BalanceShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final AsyncValue<double> value;
  final IconData icon;
  final Color color;
  final bool isIncome;

  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with background
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 10),
          // Text content
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Colors.white54,
                  ),
                ),
                value.when(
                  data: (val) => Text(
                    CurrencyFormatter.formatCompact(val),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  loading: () => Container(
                    width: 60,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  error: (_, __) => const Text('--'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
