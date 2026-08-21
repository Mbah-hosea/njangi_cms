import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'dashboard_screen.dart';
import '../../../members/presentation/screens/members_screen.dart';

// ── Placeholder screens for tabs not built yet ────────────
// We replace these one by one as we build each feature

class _ActivityScreen extends StatelessWidget {
  const _ActivityScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: Center(
        child: Text(
          'Activity Feed\nComing soon',
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineMedium,
        ),
      ),
    );
  }
}

class _AlertsScreen extends StatelessWidget {
  const _AlertsScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: Center(
        child: Text(
          'Alerts\nComing soon',
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineMedium,
        ),
      ),
    );
  }
}

class _MembersScreen extends StatelessWidget {
  const _MembersScreen();
  @override
  Widget build(BuildContext context) {
    return const MembersScreen();
  }
}

class _MoreScreen extends StatelessWidget {
  const _MoreScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: Center(
        child: Text(
          'More Options\nComing soon',
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineMedium,
        ),
      ),
    );
  }
}

// ── Main Shell ────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {

  // Tracks which tab is currently active
  int _currentIndex = 0;

  // All 5 tab screens in order
  // Replace placeholders as we build each feature
  final List<Widget> _screens = const [
    DashboardScreen(),
    _ActivityScreen(),
    _AlertsScreen(),
    _MembersScreen(),
    _MoreScreen(),
  ];

  // Tab definitions — icon, label, active icon
  final List<_TabItem> _tabs = const [
    _TabItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _TabItem(
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
      label: 'Activity',
    ),
    _TabItem(
      icon: Icons.notifications_outlined,
      activeIcon: Icons.notifications_rounded,
      label: 'Alerts',
    ),
    _TabItem(
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
      label: 'Members',
    ),
    _TabItem(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      label: 'More',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                _tabs.length,
                    (index) => _buildTabItem(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index) {
    bool isActive = _currentIndex == index;
    _TabItem tab = _tabs[index];

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primarySurface
              : AppColors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? tab.activeIcon : tab.icon,
              color: isActive
                  ? AppColors.primary
                  : AppColors.grey500,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              tab.label,
              style: AppTextStyles.caption.copyWith(
                color: isActive
                    ? AppColors.primary
                    : AppColors.grey500,
                fontWeight: isActive
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tab data model ─────────────────────────────────────────
class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}