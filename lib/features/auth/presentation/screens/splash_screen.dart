import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  // Controls our logo animation
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _navigate();
  }

  void _setupAnimation() {
    // Animation runs for 1.2 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Logo fades from invisible to fully visible
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    // Logo grows from 80% size to full size
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    // Start the animation immediately
    _controller.forward();
  }

  Future<void> _navigate() async {
    // Wait 2.5 seconds on splash screen
    await Future.delayed(const Duration(milliseconds: 2500));

    // Check if widget is still on screen before navigating
    if (!mounted) return;

    // TODO: Check onboarding and auth status from SharedPreferences
    // For now we always go to onboarding
    Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
  }

  @override
  void dispose() {
    // Always dispose animation controllers to free memory
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Full green background
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // ── App Icon ────────────────────────────
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.groups_rounded,
                    size: 56,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 24),

                // ── App Name ─────────────────────────────
                Text(
                  AppConstants.appName,
                  style: AppTextStyles.displayLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),

                const SizedBox(height: 8),

                // ── Tagline ───────────────────────────────
                Text(
                  'Community. Transparency. Trust.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withOpacity(0.8),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),

      // Version number at the bottom
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: Text(
          'v${AppConstants.appVersion}',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.white.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}