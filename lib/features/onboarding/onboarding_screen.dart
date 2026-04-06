import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      icon: Icons.account_balance_wallet_rounded,
      color: AppColors.primary,
      title: 'مرحباً بك في FlowSpend',
      subtitle: 'تطبيقك الشخصي لإدارة المصاريف والأقساط\nكل بياناتك على جهازك — بدون إنترنت',
    ),
    _OnboardingPage(
      icon: Icons.credit_card_rounded,
      color: AppColors.installment,
      title: 'تتبع الأقساط والفوائد',
      subtitle: 'سجل أقساط سهولة وفاليو وكريدت كارد\nاعرف كام دفعت فوائد وكام باقي عليك',
    ),
    _OnboardingPage(
      icon: Icons.pie_chart_rounded,
      color: AppColors.secondary,
      title: 'ميزانية وتقارير ذكية',
      subtitle: 'حدد ميزانية لكل فئة\nشوف فين فلوسك بتروح بالتفصيل',
    ),
    _OnboardingPage(
      icon: Icons.sms_rounded,
      color: AppColors.accent,
      title: 'كشف رسائل البنوك',
      subtitle: 'التطبيق بيقرأ رسائل البنوك تلقائي\nويضيف المعاملات من غير ما تكتب حاجة',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: TextButton(
                onPressed: widget.onComplete,
                child: const Text('تخطي',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textMuted)),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _pages[i],
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) {
                  final isActive = _currentPage == i;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : AppColors.textMuted.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: _currentPage == _pages.length - 1
                  ? AppButton(
                      label: 'ابدأ الآن',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: widget.onComplete,
                    )
                  : AppButton(
                      label: 'التالي',
                      onPressed: () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _OnboardingPage({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.25),
                  color.withValues(alpha: 0.08),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 56),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              color: AppColors.textSecondary.withValues(alpha: 0.9),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
