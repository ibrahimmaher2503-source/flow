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
        // Limit decimal places to 2
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
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Material(
                  color: key == '⌫'
                      ? AppColors.danger.withValues(alpha: 0.2)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () => _onKey(key),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 56,
                      alignment: Alignment.center,
                      child: key == '⌫'
                          ? const Icon(Icons.backspace_outlined,
                              color: AppColors.danger, size: 24)
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
