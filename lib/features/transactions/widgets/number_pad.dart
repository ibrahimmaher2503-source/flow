import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class NumberPad extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const NumberPad({
    super.key,
    required this.value,
    required this.onChanged,
  });

  void _onKey(String key) {
    if (key == 'C') {
      onChanged('0');
    } else if (key == '⌫') {
      if (value.length <= 1) {
        onChanged('0');
      } else {
        onChanged(value.substring(0, value.length - 1));
      }
    } else if (key == '.') {
      if (!value.contains('.')) {
        onChanged('$value.');
      }
    } else {
      if (value == '0') {
        onChanged(key);
      } else {
        if (value.contains('.')) {
          final parts = value.split('.');
          if (parts[1].length >= 2) return;
        }
        onChanged('$value$key');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', '⌫'],
    ];

    return Column(
      children: keys.map((row) {
        return Row(
          children: row.map((key) {
            final isBackspace = key == '⌫';
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _onKey(key),
                    borderRadius: BorderRadius.circular(14),
                    splashColor: AppColors.primary.withValues(alpha: 0.2),
                    highlightColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Container(
                      height: 58,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: isBackspace
                            ? LinearGradient(
                                colors: [
                                  AppColors.danger.withValues(alpha: 0.15),
                                  AppColors.danger.withValues(alpha: 0.05),
                                ],
                              )
                            : LinearGradient(
                                colors: [
                                  AppColors.surface.withValues(alpha: 0.8),
                                  AppColors.surface.withValues(alpha: 0.4),
                                ],
                              ),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isBackspace
                              ? AppColors.danger.withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.04),
                        ),
                      ),
                      child: isBackspace
                          ? const Icon(Icons.backspace_rounded,
                              color: AppColors.danger, size: 22)
                          : Text(
                              key,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
