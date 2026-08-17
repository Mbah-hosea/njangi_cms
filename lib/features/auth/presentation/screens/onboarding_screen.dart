import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';

/// Data model for each onboarding page
/// Each page has exactly these four things
class OnboardingPage {
  final IconData icon;
  final String title;
  final String message;
  final Color color;

  const OnboardingPage({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });
}
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}
class _OnboardingScreenState extends State<OnboardingScreen> {

// Controls which page we are on
final PageController _pageController = PageController();
int _currentPage = 0;

// Our three onboarding pages — data defined here, UI built below
final List<OnboardingPage> _pages = const [
OnboardingPage(
icon: Icons.visibility_rounded,
title: 'Full Transparency',
message: 'Every contribution, payout and expenditure is visible to all members. Nothing hidden. Nothing lost.',
color: AppColors.primary,
),
OnboardingPage(
icon: Icons.shield_rounded,
title: 'Built on Trust',
message: 'Every action is recorded, attributed and permanent. No disputes. No fraud. Just honesty.',
color: AppColors.primaryDark,
),
OnboardingPage(
icon: Icons.groups_rounded,
title: 'Your Community. Digitalised.',
message: 'Njangi, village groups, welfare societies — manage them all in one trusted place.',
color: AppColors.primary,
),
];

@override
void dispose() {
// Always dispose PageController to free memory
_pageController.dispose();
super.dispose();
}

// Called when user taps Get Started or Skip
void _finishOnboarding() {
// TODO: Save to SharedPreferences that user has onboarded
// So splash screen never shows onboarding again
Navigator.pushReplacementNamed(context, AppRoutes.login);
}

// Called when user taps Next
void _nextPage() {
_pageController.nextPage(
duration: const Duration(milliseconds: 400),
curve: Curves.easeInOut,
);
}
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: AppColors.primary,
body: SafeArea(
child: Column(
children: [

// ── Skip Button (top right) ──────────────────
Align(
alignment: Alignment.topRight,
child: TextButton(
onPressed: _finishOnboarding,
child: Text(
'Skip',
style: AppTextStyles.labelLarge.copyWith(
color: AppColors.white.withOpacity(0.7),
),
),
),
),

// ── Swipeable Pages ──────────────────────────
Expanded(
child: PageView.builder(
controller: _pageController,
itemCount: _pages.length,
onPageChanged: (index) {
// Rebuild to update dots and button
setState(() {
_currentPage = index;
});
},
itemBuilder: (context, index) {
return _buildPage(_pages[index]);
},
),
),

// ── Dot Indicators ───────────────────────────
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: List.generate(
_pages.length,
(index) => _buildDot(index),
),
),

const SizedBox(height: 32),

// ── Bottom Button ────────────────────────────
Padding(
padding: const EdgeInsets.symmetric(horizontal: 24),
child: _currentPage == _pages.length - 1
? ElevatedButton(
onPressed: _finishOnboarding,
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.secondary,
foregroundColor: AppColors.primary,
),
child: const Text('Get Started'),
)
: ElevatedButton(
onPressed: _nextPage,
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.white
.withOpacity(0.2),
foregroundColor: AppColors.white,
),
child: const Text('Next'),
),
),

const SizedBox(height: 32),

],
),
),
);
}
// Builds one full onboarding page
  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // ── Icon Circle ──────────────────────────────
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 64,
              color: AppColors.secondary,
            ),
          ),

          const SizedBox(height: 48),

          // ── Title ────────────────────────────────────
          Text(
            page.title,
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.white,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // ── Message ──────────────────────────────────
          Text(
            page.message,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.white.withOpacity(0.85),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),

        ],
      ),
    );
  }

  // Builds one dot indicator
  Widget _buildDot(int index) {
    // Current page dot is wider and fully opaque
    // Other dots are small and semi-transparent
    bool isActive = index == _currentPage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.secondary
            : AppColors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

} // end of _OnboardingScreenState