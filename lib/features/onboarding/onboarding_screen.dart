import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_button.dart';
import '../../l10n/generated/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_OnboardingPageData> _getPages(AppLocalizations l10n) {
    return [
      _OnboardingPageData(
        icon: Icons.account_balance_wallet_rounded,
        color: AppColors.primary,
        title: l10n.onboardingWelcomeTitle,
        subtitle: l10n.onboardingWelcomeSubtitle,
      ),
      _OnboardingPageData(
        icon: Icons.credit_card_rounded,
        color: AppColors.installment,
        title: l10n.onboardingInstallmentsTitle,
        subtitle: l10n.onboardingInstallmentsSubtitle,
      ),
      _OnboardingPageData(
        icon: Icons.pie_chart_rounded,
        color: AppColors.secondary,
        title: l10n.onboardingBudgetTitle,
        subtitle: l10n.onboardingBudgetSubtitle,
      ),
      _OnboardingPageData(
        icon: Icons.sms_rounded,
        color: AppColors.accent,
        title: l10n.onboardingSmsTitle,
        subtitle: l10n.onboardingSmsSubtitle,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _getPages(l10n);

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
                child: Text(l10n.buttonSkip,
                    style: const TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textMuted)),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: pages.length,
                itemBuilder: (_, i) => _OnboardingPage(data: pages[i]),
              ),
            ),

            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pages.length, (i) {
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
              child: _currentPage == pages.length - 1
                  ? AppButton(
                      label: l10n.buttonStartNow,
                      icon: Icons.arrow_forward_rounded,
                      onPressed: widget.onComplete,
                    )
                  : AppButton(
                      label: l10n.buttonNext,
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

class _OnboardingPageData {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _OnboardingPageData({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingPage({required this.data});

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
                  data.color.withValues(alpha: 0.25),
                  data.color.withValues(alpha: 0.08),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: data.color, size: 56),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
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
            data.subtitle,
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
