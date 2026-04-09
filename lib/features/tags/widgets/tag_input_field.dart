import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../providers/tag_provider.dart';
import 'tag_chip.dart';

/// Input field for adding tags with autocomplete
class TagInputField extends ConsumerStatefulWidget {
  final List<String> selectedTags;
  final ValueChanged<List<String>> onTagsChanged;
  final String? category; // For suggested tags
  final int maxTags;

  const TagInputField({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
    this.category,
    this.maxTags = 5,
  });

  @override
  ConsumerState<TagInputField> createState() => _TagInputFieldState();
}

class _TagInputFieldState extends ConsumerState<TagInputField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _showSuggestions = false;
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus;
    });
    if (_focusNode.hasFocus && _controller.text.isEmpty) {
      _loadSuggestions('');
    }
  }

  Future<void> _loadSuggestions(String query) async {
    final tagService = ref.read(tagServiceProvider);
    final results = await tagService.searchTags(query);

    // Filter out already selected tags
    final filtered = results
        .where((t) => !widget.selectedTags.contains(t.name))
        .map((t) => t.name)
        .toList();

    // Add category-based suggestions if available
    if (query.isEmpty && widget.category != null) {
      final suggested =
          await tagService.getSuggestedTags(widget.category!);
      for (final tag in suggested) {
        if (!widget.selectedTags.contains(tag) && !filtered.contains(tag)) {
          filtered.insert(0, tag);
        }
      }
    }

    setState(() {
      _suggestions = filtered.take(8).toList();
    });
  }

  void _addTag(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isEmpty) return;
    if (widget.selectedTags.contains(trimmed)) return;
    if (widget.selectedTags.length >= widget.maxTags) return;

    final newTags = [...widget.selectedTags, trimmed];
    widget.onTagsChanged(newTags);
    _controller.clear();
    _loadSuggestions('');
  }

  void _removeTag(String tag) {
    final newTags = widget.selectedTags.where((t) => t != tag).toList();
    widget.onTagsChanged(newTags);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'التاجات',
          style: TextStyle(
            color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Selected tags
        if (widget.selectedTags.isNotEmpty) ...[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: widget.selectedTags.map((tag) {
              return TagChip(
                label: tag,
                removable: true,
                onRemove: () => _removeTag(tag),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],

        // Input field
        if (widget.selectedTags.length < widget.maxTags)
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceLight.withValues(alpha: 0.5)
                  : AppColors.lightSurfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? (isDark ? AppColors.primary : AppColors.lightPrimary)
                    : (isDark
                        ? AppColors.surfaceLight
                        : AppColors.lightSurfaceContainerHighest),
                width: _focusNode.hasFocus ? 1.5 : 1,
              ),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              style: TextStyle(
                color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'أضف تاج (مثل: رمضان، سفر)',
                hintStyle: TextStyle(
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.tag_rounded,
                  color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                  size: 20,
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.add_circle_rounded,
                          color: isDark ? AppColors.primary : AppColors.lightPrimary,
                        ),
                        onPressed: () => _addTag(_controller.text),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
              ),
              textInputAction: TextInputAction.done,
              onChanged: (value) {
                setState(() {});
                _loadSuggestions(value);
              },
              onSubmitted: _addTag,
            ),
          ),

        // Suggestions
        if (_showSuggestions && _suggestions.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surface
                  : AppColors.lightSurfaceContainerLow,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              boxShadow: isDark ? null : AppColors.lightShadowSubtle,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: AppSpacing.xs,
                    bottom: AppSpacing.xs,
                  ),
                  child: Text(
                    'اقتراحات',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textMuted
                          : AppColors.lightTextMuted,
                      fontSize: 12,
                    ),
                  ),
                ),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: _suggestions.map((tag) {
                    return TagChip(
                      label: tag,
                      onTap: () => _addTag(tag),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],

        // Remaining count
        if (widget.selectedTags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              '${widget.selectedTags.length}/${widget.maxTags} تاجات',
              style: TextStyle(
                color: isDark ? AppColors.textMuted : AppColors.lightTextMuted,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
