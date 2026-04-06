import 'package:flutter/material.dart';
import '../../shared/widgets/empty_state.dart';

class SmsInboxScreen extends StatelessWidget {
  const SmsInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // SMS parsing requires telephony package + Android permissions
    // This is a placeholder that will be populated when SMS is read
    return Scaffold(
      appBar: AppBar(
        title: const Text('رسائل البنوك'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('قراءة الرسائل تحتاج تشغيل التطبيق على جهاز حقيقي'),
                ),
              );
            },
          ),
        ],
      ),
      body: const EmptyState(
        icon: Icons.sms,
        message: 'مفيش رسائل مكتشفة\nالتطبيق هيكتشف رسائل البنوك تلقائياً',
      ),
    );
  }
}
