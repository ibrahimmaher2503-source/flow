import 'package:flutter/material.dart';
import '../../shared/widgets/empty_state.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المعاملات'),
      ),
      body: const EmptyState(
        icon: Icons.receipt_long,
        message: 'مفيش معاملات لسه\nاضغط + لإضافة معاملة جديدة',
      ),
    );
  }
}
