import 'package:flutter/material.dart';
import '../../shared/widgets/empty_state.dart';

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الميزانية'),
      ),
      body: const EmptyState(
        icon: Icons.pie_chart,
        message: 'مفيش ميزانيات محددة\nحدد ميزانية لكل فئة عشان تتابع مصاريفك',
      ),
    );
  }
}
