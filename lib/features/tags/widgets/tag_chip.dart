import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

/// A compact chip for displaying a tag
class TagChip extends StatelessWidget {
  final String label;
  final String? colorHex;
  final bool selected;
  final bool removable;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final bool compact;

  const TagChip({
    super.key,
    required this.label,
    this.colorHex,
    this.selected = false,
    this.removable = false,
    this.onTap,
    this.onRemove,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tagColor = _parseColor(colorHex) ??
        (isDark ? AppColors.primary : AppColors.lightPrimary);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.sm : AppSpacing.md,
          vertical: compact ? 2 : AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: selected
              ? tagColor.withValues(alpha: 0.2)
              : (isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.5)
                  : AppColors.lightSurfaceContainerHigh),
          borderRadius: BorderRadius.circular(AppSpacing.radiusCircle),
          border: Border.all(
            color: selected
                ? tagColor
                : (isDark
                    ? AppColors.surfaceLight
                    : AppColors.lightSurfaceContainerHighest),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color dot
            Container(
              width: compact ? 6 : 8,
              height: compact ? 6 : 8,
              decoration: BoxDecoration(
                color: tagColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: compact ? 4 : AppSpacing.xs),
            // Label
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? tagColor
                    : (isDark
                        ? AppColors.textPrimary
                        : AppColors.lightTextPrimary),
                fontSize: compact ? 11 : 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            // Remove button
            if (removable) ...[
              SizedBox(width: compact ? 2 : AppSpacing.xs),
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  Icons.close_rounded,
                  size: compact ? 14 : 16,
                  color: isDark
                      ? AppColors.textMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      final colorHex = hex.replaceFirst('#', '');
      return Color(int.parse('FF$colorHex', radix: 16));
    } catch (_) {
      return null;
    }
  }
}

/// A row of tag chips with overflow handling
class TagChipRow extends StatelessWidget {
  final List<String> tags;
  final Map<String, String>? tagColors;
  final int maxVisible;
  final bool compact;
  final void Function(String tag)? onTagTap;

  const TagChipRow({
    super.key,
    required this.tags,
    this.tagColors,
    this.maxVisible = 3,
    this.compact = true,
    this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final visibleTags = tags.take(maxVisible).toList();
    final overflowCount = tags.length - maxVisible;

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...visibleTags.map((tag) => TagChip(
              label: tag,
              colorHex: tagColors?[tag],
              compact: compact,
              onTap: onTagTap != null ? () => onTagTap!(tag) : null,
            )),
        if (overflowCount > 0)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? AppSpacing.sm : AppSpacing.md,
              vertical: compact ? 2 : AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.3)
                  : AppColors.lightSurfaceContainer,
              borderRadius: BorderRadius.circular(AppSpacing.radiusCircle),
            ),
            child: Text(
              '+$overflowCount',
              style: TextStyle(
                color: isDark
                    ? AppColors.textMuted
                    : AppColors.lightTextMuted,
                fontSize: compact ? 11 : 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
