import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Gradient? gradient;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.gradient,
    this.icon,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),  // Slightly longer for smoother feel
    );
    // Scale animation with premium easeOutCubic curve
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    // Shadow animation - reduces shadow on press for tactile feel
    _shadowAnimation = Tween<double>(begin: 1.0, end: 0.4).animate(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.primary : AppColors.lightPrimary;
    final onPrimaryColor = isDark ? Colors.white : AppColors.lightOnPrimary;
    final defaultGradient = isDark ? AppColors.primaryGradient : AppColors.lightPrimaryGradient;
    final isDisabled = widget.onPressed == null && !widget.isLoading;

    // M3 disabled state colors
    final disabledBgColor = isDark
        ? AppColors.surface.withValues(alpha: 0.38)
        : AppColors.lightSurfaceContainerHighest;
    final disabledFgColor = isDark
        ? AppColors.textMuted
        : AppColors.lightTextDisabled;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => _controller.forward(),
      onTapUp: isDisabled ? null : (_) {
        _controller.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: isDisabled ? null : () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 56, // M3 standard height
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: isDisabled ? null : (widget.gradient ?? defaultGradient),
              color: isDisabled ? disabledBgColor : null,
              borderRadius: BorderRadius.circular(20), // M3 full-rounded
              boxShadow: isDisabled
                  ? null
                  : [
                      // M3 tonal shadow - colored glow
                      BoxShadow(
                        color: primaryColor.withValues(alpha: (isDark ? 0.25 : 0.20) * _shadowAnimation.value),
                        blurRadius: 12 * _shadowAnimation.value,
                        offset: Offset(0, 4 * _shadowAnimation.value),
                      ),
                      // M3 ambient shadow - soft depth
                      if (!isDark)
                        BoxShadow(
                          color: AppColors.lightShadow.withValues(alpha: _shadowAnimation.value),
                          blurRadius: 24 * _shadowAnimation.value,
                          offset: Offset(0, 8 * _shadowAnimation.value),
                          spreadRadius: -4,
                        ),
                    ],
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: isDisabled ? disabledFgColor : onPrimaryColor,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: isDisabled ? disabledFgColor : onPrimaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          widget.label,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16, // M3 label large
                            fontWeight: FontWeight.w500,
                            color: isDisabled ? disabledFgColor : onPrimaryColor,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
