import 'package:flutter/material.dart';

/// Smart insights screen - personalized spending pattern insights
class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الذكاء المالي'),
      ),
      body: const Center(
        child: Text('قريبًا - رؤى ذكية'),
      ),
    );
  }
}
