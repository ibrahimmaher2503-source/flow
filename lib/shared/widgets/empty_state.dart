import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Semantic variants for empty state styling
enum EmptyStateVariant {
  /// Default neutral styling
  neutral,
  /// Primary themed for main actions
  primary,
  /// Info themed for informational messages
  info,
  /// Warning themed for attention-needed states
  warning,
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EmptyStateVariant variant;
  final String? subtitle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.variant = EmptyStateVariant.neutral,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _getVariantColors(isDark);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // M3 icon container with semantic coloring
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colors.containerColor,
                shape: BoxShape.circle,
                border: isDark
                    ? null
                    : Border.all(color: colors.borderColor, width: 0.5),
                boxShadow: isDark
                    ? [
                        BoxShadow(
                          color: colors.accentColor.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : AppColors.lightShadowSubtle,
              ),
              child: Icon(
                icon,
                size: 44,
                color: colors.iconColor,
              ),
            ),
            const SizedBox(height: 24),

            // Main message
            Text(
              message,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w500, // M3 title medium
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
                letterSpacing: 0.15,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            // Optional subtitle
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w400, // M3 body medium
                  color: isDark
                      ? AppColors.textSecondary
                      : AppColors.lightTextSecondary,
                  letterSpacing: 0.25,
                  height: 1.43,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              _ActionButton(
                label: actionLabel!,
                onTap: onAction!,
                color: colors.accentColor,
                isDark: isDark,
              ),
            ],
          ],
        ),
      ),
    );
  }

  _EmptyStateColors _getVariantColors(bool isDark) {
    switch (variant) {
      case EmptyStateVariant.neutral:
        return _EmptyStateColors(
          containerColor: isDark
              ? AppColors.surface.withValues(alpha: 0.5)
              : AppColors.lightSurfaceContainerHigh,
          iconColor: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
          accentColor: isDark ? AppColors.primary : AppColors.lightPrimary,
          borderColor: AppColors.lightBorderVariant,
        );
      case EmptyStateVariant.primary:
        return _EmptyStateColors(
          containerColor: isDark
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.lightPrimaryMuted,
          iconColor: isDark ? AppColors.primary : AppColors.lightPrimary,
          accentColor: isDark ? AppColors.primary : AppColors.lightPrimary,
          borderColor: AppColors.lightPrimaryBorder,
        );
      case EmptyStateVariant.info:
        return _EmptyStateColors(
          containerColor: isDark
              ? const Color(0xFF60A5FA).withValues(alpha: 0.15)
              : AppColors.lightInfoMuted,
          iconColor: isDark ? const Color(0xFF60A5FA) : AppColors.lightInfo,
          accentColor: isDark ? const Color(0xFF60A5FA) : AppColors.lightInfo,
          borderColor: AppColors.lightInfoBorder,
        );
      case EmptyStateVariant.warning:
        return _EmptyStateColors(
          containerColor: isDark
              ? AppColors.warning.withValues(alpha: 0.15)
              : AppColors.lightWarningMuted,
          iconColor: isDark ? AppColors.warning : AppColors.lightWarning,
          accentColor: isDark ? AppColors.warning : AppColors.lightWarning,
          borderColor: AppColors.lightWarningBorder,
        );
    }
  }
}

class _EmptyStateColors {
  final Color containerColor;
  final Color iconColor;
  final Color accentColor;
  final Color borderColor;

  const _EmptyStateColors({
    required this.containerColor,
    required this.iconColor,
    required this.accentColor,
    required this.borderColor,
  });
}

class _ActionButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool isDark;

  const _ActionButton({
    required this.label,
    required this.onTap,
    required this.color,
    required this.isDark,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // M3 tonal button styling
    final bgColor = widget.isDark
        ? widget.color.withValues(alpha: 0.15)
        : AppColors.getColoredContainer(widget.color, false);

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
              border: widget.isDark
                  ? null
                  : Border.all(
                      color: widget.color.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
              boxShadow: widget.isDark
                  ? null
                  : [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500, // M3 label large
                fontSize: 14,
                color: widget.color,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
