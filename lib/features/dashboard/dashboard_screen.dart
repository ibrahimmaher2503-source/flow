import 'package:flutter/material.dart';
import '../../shared/widgets/empty_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرئيسية'),
      ),
      body: const EmptyState(
        icon: Icons.dashboard,
        message: 'مرحباً بك في FlowSpend\nابدأ بإضافة أول معاملة',
      ),
    );
  }
}
