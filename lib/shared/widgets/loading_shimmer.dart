import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';

/// Semantic shimmer variants for different content types
enum ShimmerVariant {
  /// Default surface shimmer
  surface,
  /// Primary tinted shimmer for featured content
  primary,
  /// Secondary tinted shimmer for accent content
  secondary,
}

class LoadingShimmer extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final ShimmerVariant variant;

  const LoadingShimmer({
    super.key,
    this.height = 80,
    this.width = double.infinity,
    this.borderRadius = 16,
    this.variant = ShimmerVariant.surface,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = _getVariantColors(isDark);

    return Shimmer.fromColors(
      baseColor: colors.baseColor,
      highlightColor: colors.highlightColor,
      period: const Duration(milliseconds: 1400),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: colors.baseColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: isDark
              ? null
              : Border.all(color: colors.borderColor, width: 0.5),
        ),
      ),
    );
  }

  _ShimmerColors _getVariantColors(bool isDark) {
    switch (variant) {
      case ShimmerVariant.surface:
        return _ShimmerColors(
          baseColor: isDark
              ? AppColors.surface
              : AppColors.lightSurfaceContainer,
          highlightColor: isDark
              ? AppColors.surfaceLight
              : AppColors.lightSurfaceContainerLowest,
          borderColor: AppColors.lightBorderVariant,
        );
      case ShimmerVariant.primary:
        return _ShimmerColors(
          baseColor: isDark
              ? AppColors.primary.withValues(alpha: 0.15)
              : AppColors.lightPrimaryMuted,
          highlightColor: isDark
              ? AppColors.primary.withValues(alpha: 0.25)
              : AppColors.lightPrimaryContainer,
          borderColor: AppColors.lightPrimaryBorder.withValues(alpha: 0.5),
        );
      case ShimmerVariant.secondary:
        return _ShimmerColors(
          baseColor: isDark
              ? AppColors.secondary.withValues(alpha: 0.15)
              : AppColors.lightSecondaryMuted,
          highlightColor: isDark
              ? AppColors.secondary.withValues(alpha: 0.25)
              : AppColors.lightSecondaryContainer,
          borderColor: AppColors.lightSecondaryBorder.withValues(alpha: 0.5),
        );
    }
  }

  /// Create a list of shimmer placeholders
  static Widget list({
    int count = 3,
    double itemHeight = 80,
    double spacing = 12,
    ShimmerVariant variant = ShimmerVariant.surface,
  }) {
    return Column(
      children: List.generate(
        count,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index < count - 1 ? spacing : 0),
          child: LoadingShimmer(height: itemHeight, variant: variant),
        ),
      ),
    );
  }

  /// Create a card shimmer placeholder
  static Widget card({
    double height = 160,
    ShimmerVariant variant = ShimmerVariant.surface,
  }) {
    return LoadingShimmer(height: height, variant: variant);
  }

  /// Create a text line shimmer
  static Widget text({
    double width = 120,
    double height = 16,
    ShimmerVariant variant = ShimmerVariant.surface,
  }) {
    return LoadingShimmer(
      width: width,
      height: height,
      borderRadius: 4,
      variant: variant,
    );
  }

  /// Create a circular shimmer (e.g., for avatars)
  static Widget circle({
    double size = 48,
    ShimmerVariant variant = ShimmerVariant.surface,
  }) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final baseColor = isDark
            ? AppColors.surface
            : AppColors.lightSurfaceContainer;
        final highlightColor = isDark
            ? AppColors.surfaceLight
            : AppColors.lightSurfaceContainerLowest;

        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: const Duration(milliseconds: 1400),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: baseColor,
              shape: BoxShape.circle,
              border: isDark
                  ? null
                  : Border.all(
                      color: AppColors.lightBorderVariant,
                      width: 0.5,
                    ),
            ),
          ),
        );
      },
    );
  }

  /// Create a composite shimmer for transaction tiles
  static Widget transactionTile() {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final baseColor = isDark
            ? AppColors.surface
            : AppColors.lightSurfaceContainer;
        final highlightColor = isDark
            ? AppColors.surfaceLight
            : AppColors.lightSurfaceContainerLowest;

        return Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: const Duration(milliseconds: 1400),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surface : AppColors.lightSurfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: isDark
                  ? null
                  : Border.all(color: AppColors.lightBorderVariant, width: 0.5),
            ),
            child: Row(
              children: [
                // Icon placeholder
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                // Text placeholders
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 14,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 12,
                        decoration: BoxDecoration(
                          color: baseColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                // Amount placeholder
                Container(
                  width: 60,
                  height: 16,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerColors {
  final Color baseColor;
  final Color highlightColor;
  final Color borderColor;

  const _ShimmerColors({
    required this.baseColor,
    required this.highlightColor,
    required this.borderColor,
  });
}
