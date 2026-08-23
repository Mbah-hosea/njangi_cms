import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        title: const Text('More'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            // ── Group Section ────────────────────────────
            _buildSectionHeader('Group'),
            const SizedBox(height: 8),
            _buildMenuCard([
              _MenuItem(
                icon: Icons.bar_chart_rounded,
                color: AppColors.primary,
                title: 'Reports & Export',
                subtitle: 'Financial summaries and PDF export',
                onTap: (context) => _comingSoon(
                    context, 'Reports'),
              ),
              _MenuItem(
                icon: Icons.construction_rounded,
                color: AppColors.info,
                title: 'Community Projects',
                subtitle: 'Track project funds and progress',
                onTap: (context) => _comingSoon(
                    context, 'Projects'),
              ),
              _MenuItem(
                icon: Icons.event_rounded,
                color: AppColors.primary,
                title: 'Meetings',
                subtitle: 'Schedule and attendance records',
                onTap: (context) => _comingSoon(
                    context, 'Meetings'),
              ),
              _MenuItem(
                icon: Icons.warning_rounded,
                color: AppColors.warning,
                title: 'Fines',
                subtitle: 'Manage and track member fines',
                onTap: (context) => _comingSoon(
                    context, 'Fines'),
              ),
              _MenuItem(
                icon: Icons.handshake_rounded,
                color: AppColors.eventLoan,
                title: 'Loans',
                subtitle: 'Loan requests and repayments',
                onTap: (context) => _comingSoon(
                    context, 'Loans'),
              ),
            ]),

            const SizedBox(height: 20),

            // ── Finance Section ──────────────────────────
            _buildSectionHeader('Finance'),
            const SizedBox(height: 8),
            _buildMenuCard([
              _MenuItem(
                icon: Icons.rotate_right_rounded,
                color: AppColors.success,
                title: 'Beneficiary Rotation',
                subtitle: 'View and manage payout order',
                onTap: (context) => _comingSoon(
                    context, 'Beneficiary Rotation'),
              ),
              _MenuItem(
                icon: Icons.calendar_month_rounded,
                color: AppColors.primary,
                title: 'Annual Dues',
                subtitle: 'Track yearly contribution dues',
                onTap: (context) => _comingSoon(
                    context, 'Annual Dues'),
              ),
              _MenuItem(
                icon: Icons.account_balance_rounded,
                color: AppColors.info,
                title: 'Cashbook',
                subtitle: 'Full group financial ledger',
                onTap: (context) => _comingSoon(
                    context, 'Cashbook'),
              ),
            ]),

            const SizedBox(height: 20),

            // ── Community Section ────────────────────────
            _buildSectionHeader('Community'),
            const SizedBox(height: 8),
            _buildMenuCard([
              _MenuItem(
                icon: Icons.how_to_vote_rounded,
                color: AppColors.primary,
                title: 'Voting',
                subtitle: 'Group polls and decisions',
                onTap: (context) => _comingSoon(
                    context, 'Voting'),
              ),
              _MenuItem(
                icon: Icons.folder_rounded,
                color: AppColors.warning,
                title: 'Document Vault',
                subtitle: 'Group documents and records',
                onTap: (context) => _comingSoon(
                    context, 'Documents'),
              ),
              _MenuItem(
                icon: Icons.campaign_rounded,
                color: AppColors.info,
                title: 'Announcements',
                subtitle: 'Group-wide announcements',
                onTap: (context) => _comingSoon(
                    context, 'Announcements'),
              ),
              _MenuItem(
                icon: Icons.favorite_rounded,
                color: AppColors.error,
                title: 'Welfare Events',
                subtitle: 'Death and welfare contributions',
                onTap: (context) => _comingSoon(
                    context, 'Welfare Events'),
              ),
            ]),

            const SizedBox(height: 20),

            // ── Settings Section ─────────────────────────
            _buildSectionHeader('Settings'),
            const SizedBox(height: 8),
            _buildMenuCard([
              _MenuItem(
                icon: Icons.settings_rounded,
                color: AppColors.grey700,
                title: 'Group Settings',
                subtitle: 'Rules, fines and loan config',
                onTap: (context) => _comingSoon(
                    context, 'Group Settings'),
              ),
              _MenuItem(
                icon: Icons.person_rounded,
                color: AppColors.primary,
                title: 'My Profile',
                subtitle: 'Edit your name and photo',
                onTap: (context) => _comingSoon(
                    context, 'My Profile'),
              ),
              _MenuItem(
                icon: Icons.notifications_rounded,
                color: AppColors.info,
                title: 'Notification Preferences',
                subtitle: 'Choose what alerts you receive',
                onTap: (context) => _comingSoon(
                    context, 'Notifications'),
              ),
            ]),

            const SizedBox(height: 20),

            // ── Logout ───────────────────────────────────
            _buildLogoutButton(context),

            const SizedBox(height: 32),

          ],
        ),
      ),
    );
  }

  // Section header
  Widget _buildSectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: AppTextStyles.labelMedium.copyWith(
        color: AppColors.grey500,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Card containing a group of menu items
  Widget _buildMenuCard(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          _MenuItem item = entry.value;
          bool isLast = index == items.length - 1;

          return Column(
            children: [
              _buildMenuItem(item),
              if (!isLast)
                const Divider(
                  height: 1,
                  indent: 56,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // One menu item row
  Widget _buildMenuItem(_MenuItem item) {
    return Builder(
      builder: (context) => ListTile(
        onTap: () => item.onTap(context),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            item.icon,
            color: item.color,
            size: 20,
          ),
        ),
        title: Text(
          item.title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          item.subtitle,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.grey500,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.grey500,
          size: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
      ),
    );
  }

  // Logout button
  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey300),
      ),
      child: ListTile(
        onTap: () => _showLogoutConfirm(context),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.logout_rounded,
            color: AppColors.error,
            size: 20,
          ),
        ),
        title: Text(
          'Logout',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.error,
          ),
        ),
        subtitle: Text(
          'Sign out of your account',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.grey500,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.grey500,
          size: 20,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4,
        ),
      ),
    );
  }

  // Logout confirmation dialog
  void _showLogoutConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Logout?',
          style: AppTextStyles.headlineMedium,
        ),
        content: Text(
          'Are you sure you want to logout? You will need to verify your phone number again to login.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.grey700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: clear local storage and navigate to login
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  // Coming soon snackbar
  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — coming soon'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// ── Menu item data model ──────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final void Function(BuildContext context) onTap;

  const _MenuItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
}