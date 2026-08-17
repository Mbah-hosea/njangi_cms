import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.groupType);
        },
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'New Group',
          style: AppTextStyles.button.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Header ──────────────────────────────────
              _buildHeader(),
              const SizedBox(height: 20),

              // ── Group Balance Card ───────────────────────
              _buildBalanceCard(),
              const SizedBox(height: 20),

              // ── Officials Section ────────────────────────
              _buildSectionTitle('Officials'),
              const SizedBox(height: 12),
              _buildOfficials(),
              const SizedBox(height: 20),

              // ── Cycle Status ─────────────────────────────
              _buildSectionTitle('Current Cycle'),
              const SizedBox(height: 12),
              _buildCycleCard(),
              const SizedBox(height: 20),

              // ── Recent Activity ──────────────────────────
              _buildSectionTitle('Recent Activity'),
              const SizedBox(height: 12),
              _buildActivityFeed(),
              const SizedBox(height: 80),

            ],
          ),
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Grace 👋',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Nkumu Village Group',
                style: AppTextStyles.headlineMedium,
              ),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.groups_rounded,
            color: AppColors.secondary,
            size: 28,
          ),
        ),
      ],
    );
  }

  // ── Balance Card ──────────────────────────────────────────
  Widget _buildBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Group Balance',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '245,000 CFA',
            style: AppTextStyles.amountLarge.copyWith(
              color: AppColors.white,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.arrow_upward_rounded,
                color: AppColors.secondary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '15,000 CFA added this cycle',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Section Title ─────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.headlineSmall,
    );
  }

  // ── Officials ─────────────────────────────────────────────
  Widget _buildOfficials() {
    final officials = [
      _Official(name: 'Emmanuel T.', role: 'President', initial: 'E'),
      _Official(name: 'Paul N.', role: 'Treasurer', initial: 'P'),
      _Official(name: 'Grace A.', role: 'Secretary', initial: 'G'),
    ];

    return Row(
      children: officials.map((official) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey300),
            ),
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primarySurface,
                  ),
                  child: Center(
                    child: Text(
                      official.initial,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  official.name,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.grey900,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  official.role,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Cycle Card ────────────────────────────────────────────
  Widget _buildCycleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cycle 3  ·  Turn 7 of 12',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.grey700,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successSurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Active',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 7 / 12,
              backgroundColor: AppColors.grey100,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.person_pin_rounded,
                color: AppColors.primary,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                'Next payout: ',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey700,
                ),
              ),
              Text(
                'Mary Fon',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Activity Feed ─────────────────────────────────────────
  Widget _buildActivityFeed() {
    final events = [
      _ActivityEvent(
        icon: Icons.arrow_downward_rounded,
        color: AppColors.eventContribution,
        title: 'John Mbah paid contribution',
        amount: '5,000 CFA',
        time: '10:42 AM',
      ),
      _ActivityEvent(
        icon: Icons.account_balance_wallet_rounded,
        color: AppColors.eventPayout,
        title: 'Mary Fon received payout',
        amount: '60,000 CFA',
        time: 'Yesterday',
      ),
      _ActivityEvent(
        icon: Icons.warning_rounded,
        color: AppColors.eventFine,
        title: 'Grace Eko — fine applied',
        amount: '500 CFA',
        time: 'Yesterday',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Column(
        children: events.asMap().entries.map((entry) {
          int index = entry.key;
          _ActivityEvent event = entry.value;
          bool isLast = index == events.length - 1;

          return Column(
            children: [
              _buildActivityItem(event),
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

  Widget _buildActivityItem(_ActivityEvent event) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: event.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              event.icon,
              color: event.color,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  event.time,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Text(
            event.amount,
            style: AppTextStyles.amountSmall.copyWith(
              color: event.color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data models ───────────────────────────────────────────────
class _Official {
  final String name;
  final String role;
  final String initial;

  const _Official({
    required this.name,
    required this.role,
    required this.initial,
  });
}

class _ActivityEvent {
  final IconData icon;
  final Color color;
  final String title;
  final String amount;
  final String time;

  const _ActivityEvent({
    required this.icon,
    required this.color,
    required this.title,
    required this.amount,
    required this.time,
  });
}