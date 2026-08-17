import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/onboarding_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/otp_screen.dart';
import 'features/auth/presentation/screens/profile_setup_screen.dart';
import 'features/auth/presentation/screens/group_choice_screen.dart';
import 'features/dashboard/presentation/screens/main_shell.dart';
import 'features/groups/presentation/screens/group_type_screen.dart';
import 'features/groups/presentation/screens/join_group_screen.dart';

void main() {
  runApp(const NjangiApp());
}

class NjangiApp extends StatelessWidget {
  const NjangiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Njangi CMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash:       (context) => const SplashScreen(),
        AppRoutes.onboarding:   (context) => const OnboardingScreen(),
        AppRoutes.login:        (context) => const LoginScreen(),
        AppRoutes.otp:          (context) => const OtpScreen(),
        AppRoutes.profileSetup: (context) => const ProfileSetupScreen(),
        AppRoutes.groupChoice:  (context) => const GroupChoiceScreen(),
        AppRoutes.shell:        (context) => const MainShell(),
        AppRoutes.groupType:    (context) => const GroupTypeScreen(),
        AppRoutes.joinGroup:    (context) => const JoinGroupScreen(),
      },
    );
  }
}