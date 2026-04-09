import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../providers/gamification_provider.dart';
import '../../../l10n/generated/app_localizations.dart';

class FinanceScoreCard extends ConsumerWidget {
  const FinanceScoreCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(financeScoreProvider);
    final badgesAsync = ref.watch(earnedBadgesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg + 4),
      decoration: BoxDecoration(
        color: isDark ? null : AppColors.lightSurfaceContainerLow,
        gradient: isDark
            ? LinearGradient(
                colors: [
                  AppColors.secondary.withValues(alpha: 0.15),
                  AppColors.surface.withValues(alpha: 0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: isDark
              ? AppColors.secondary.withValues(alpha: 0.2)
              : AppColors.lightBorderVariant,
          width: 0.5,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : AppColors.lightShadowSubtle,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Animated score circle with glow
              scoreAsync.when(
                data: (score) => _AnimatedScoreCircle(score: score, isDark: isDark, l10n: l10n),
                loading: () => const _ScoreShimmer(),
                error: (_, __) => const SizedBox(width: 80, height: 80),
              ),

              const SizedBox(width: AppSpacing.lg),

              // Label + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.insights_rounded,
                          size: 18,
                          color: isDark ? AppColors.secondary : AppColors.lightSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.financeScore,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    scoreAsync.when(
                      data: (score) => Text(
                        _getScoreMessage(score, l10n),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    ),
                    const SizedBox(height: 8),
                    // Progress bar
                    scoreAsync.when(
                      data: (score) => _ScoreProgressBar(score: score, isDark: isDark, l10n: l10n),
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Earned badges section
          badgesAsync.when(
            data: (earned) {
              if (earned.isEmpty) return const SizedBox();
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppColors.lightSurfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: (isDark ? AppColors.accent : AppColors.lightAccent)
                              .withValues(alpha: isDark ? 0.15 : 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.emoji_events_rounded,
                          size: 16,
                          color: isDark ? AppColors.accent : AppColors.lightAccent,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        l10n.achievements,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: earned
                                .map((b) => Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Tooltip(
                                        message: b.name,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: (isDark
                                                    ? AppColors.accent
                                                    : AppColors.lightAccent)
                                                .withValues(alpha: isDark ? 0.1 : 0.15),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            b.icon,
                                            style: const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  String _getScoreMessage(int score, AppLocalizations l10n) {
    if (score >= 80) return l10n.scoreExcellent;
    if (score >= 70) return l10n.scoreGreat;
    if (score >= 50) return l10n.scoreGood;
    if (score >= 30) return l10n.scorePoor;
    return l10n.scoreStart;
  }
}

class _AnimatedScoreCircle extends StatefulWidget {
  final int score;
  final bool isDark;
  final AppLocalizations l10n;

  const _AnimatedScoreCircle({required this.score, required this.isDark, required this.l10n});

  @override
  State<_AnimatedScoreCircle> createState() => _AnimatedScoreCircleState();
}

class _AnimatedScoreCircleState extends State<_AnimatedScoreCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  late Animation<int> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.score / 100,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _scoreAnimation = IntTween(
      begin: 0,
      end: widget.score,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(_AnimatedScoreCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.score / 100,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));

      _scoreAnimation = IntTween(
        begin: _scoreAnimation.value,
        end: widget.score,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));

      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getScoreColor(int score) {
    // Use theme-aware semantic colors
    if (score >= 70) {
      return widget.isDark ? AppColors.success : AppColors.lightSuccess;
    }
    if (score >= 40) {
      return widget.isDark ? AppColors.warning : AppColors.lightWarning;
    }
    return widget.isDark ? AppColors.danger : AppColors.lightDanger;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getScoreColor(widget.score);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: -4,
              ),
            ],
          ),
          child: CustomPaint(
            painter: _ScoreCirclePainter(
              progress: _progressAnimation.value,
              color: color,
              isDark: widget.isDark,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${_scoreAnimation.value}',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: color,
                      height: 1,
                    ),
                  ),
                  Text(
                    widget.l10n.scorePoints,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: widget.isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ScoreCirclePainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isDark;

  _ScoreCirclePainter({
    required this.progress,
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 8.0;

    // Background circle
    final bgPaint = Paint()
      ..color = isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [
          color,
          color.withValues(alpha: 0.7),
          color,
        ],
        transform: const GradientRotation(-math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ScoreCirclePainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

class _ScoreProgressBar extends StatelessWidget {
  final int score;
  final bool isDark;
  final AppLocalizations l10n;

  const _ScoreProgressBar({required this.score, required this.isDark, required this.l10n});

  @override
  Widget build(BuildContext context) {
    // Use theme-aware semantic colors
    final color = score >= 70
        ? (isDark ? AppColors.success : AppColors.lightSuccess)
        : score >= 40
            ? (isDark ? AppColors.warning : AppColors.lightWarning)
            : (isDark ? AppColors.danger : AppColors.lightDanger);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.scoreProgress,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10,
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
              ),
            ),
            Text(
              '$score/100',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: score / 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreShimmer extends StatelessWidget {
  const _ScoreShimmer();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.black.withValues(alpha: 0.05),
      ),
    );
  }
}
