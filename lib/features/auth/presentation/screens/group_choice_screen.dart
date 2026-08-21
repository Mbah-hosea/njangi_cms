import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';

class GroupChoiceScreen extends StatelessWidget {
  const GroupChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        title: const Text('Welcome'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(        // ← fixes overflow
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 24),

              // ── Welcome Text ───────────────────────────
              Text(
                'What would you\nlike to do?',
                style: AppTextStyles.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Choose an option to get started.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey700,
                ),
              ),

              const SizedBox(height: 40),

              // ── Create a Group Card ────────────────────
              _buildChoiceCard(
                context: context,
                icon: Icons.add_business_rounded,
                title: 'Create a Group',
                description:
                'Start a new njangi, village association, welfare society or any community group.',
                buttonLabel: 'Create Group',
                buttonColor: AppColors.primary,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.groupType,
                  );
                },
              ),

              const SizedBox(height: 16),

              // ── Join a Group Card ──────────────────────
              _buildChoiceCard(
                context: context,
                icon: Icons.group_add_rounded,
                title: 'Join a Group',
                description:
                'You were invited by a group admin. Check your pending invitations here.',
                buttonLabel: 'View My Invites',
                buttonColor: AppColors.secondary,
                buttonTextColor: AppColors.primary,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.joinGroup,
                  );
                },
              ),

              const SizedBox(height: 32),

              // ── Bottom note ────────────────────────────
              Center(
                child: Text(
                  'You can only join a group if an Admin has invited you.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.grey500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required String buttonLabel,
    required Color buttonColor,
    Color buttonTextColor = AppColors.white,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey300),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Icon ────────────────────────────────────
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 28,
            ),
          ),

          const SizedBox(height: 16),

          // ── Title ───────────────────────────────────
          Text(
            title,
            style: AppTextStyles.headlineMedium,
          ),

          const SizedBox(height: 8),

          // ── Description ─────────────────────────────
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey700,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          // ── Button ──────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: buttonTextColor,
              ),
              child: Text(buttonLabel),
            ),
          ),

        ],
      ),
    );
  }
}