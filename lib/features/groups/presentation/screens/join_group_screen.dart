import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {

  bool _isLoading = true;

  // Simulated invite data
  // TODO: Replace with real API call
  // Fetch invites for this user's phone number
  List<_GroupInvite> _invites = [];

  @override
  void initState() {
    super.initState();
    _loadInvites();
  }

  Future<void> _loadInvites() async {
    // Simulate network call to check invites
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    // DEV BYPASS — simulate no invites for now
    // TODO: Replace with real API call
    // final invites = await InviteRepository.getMyInvites();
    setState(() {
      _invites = []; // Empty = no invites
      _isLoading = false;
    });
  }

  Future<void> _acceptInvite(_GroupInvite invite) async {
    // TODO: Call API to accept invite
    // Then navigate to group dashboard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joined ${invite.groupName} successfully!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    // Go to dashboard
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.shell,
      (route) => false,
    );
  }

  void _declineInvite(_GroupInvite invite) {
    // Show confirmation dialog before declining
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Decline Invitation?',
          style: AppTextStyles.headlineMedium,
        ),
        content: Text(
          'Are you sure you want to decline the invitation to join ${invite.groupName}?',
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
              // TODO: Call API to decline invite
              setState(() {
                _invites.remove(invite);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        title: const Text('Join a Group'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? _buildLoading()
            : _invites.isEmpty
                ? _buildNoInvites()
                : _buildInviteList(),
      ),
    );
  }

  // Loading state
  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          SizedBox(height: 16),
          Text('Checking your invitations...'),
        ],
      ),
    );
  }

  // No invites found
  Widget _buildNoInvites() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // ── Empty illustration ───────────────────────
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.grey100,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.grey300,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.mail_outline_rounded,
              size: 48,
              color: AppColors.grey500,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'No Pending Invitations',
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Text(
            'You have not been invited to any group yet. Ask your group Admin to send you an invitation.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey700,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Show user's phone number so they can share it
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.phone_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Your number: +237 6XX XXX XXX',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Back to create group
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Back'),
          ),

          const SizedBox(height: 12),

          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.groupType,
              );
            },
            child: Text(
              'Create a new group instead',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        ],
      ),
    );
  }

  // Has invites — show list
  Widget _buildInviteList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _invites.length,
      itemBuilder: (context, index) {
        return _buildInviteCard(_invites[index]);
      },
    );
  }

  // One invite card
  Widget _buildInviteCard(_GroupInvite invite) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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

          // ── Group header ──────────────────────────────
          Row(
            children: [
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
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invite.groupName,
                      style: AppTextStyles.headlineMedium,
                    ),
                    Text(
                      '${invite.memberCount} members · ${invite.groupType}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // ── Invite details ────────────────────────────
          _buildDetailRow(
            Icons.person_rounded,
            'Invited by',
            invite.invitedBy,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            Icons.badge_rounded,
            'Your role',
            invite.assignedRole,
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            Icons.timer_rounded,
            'Expires in',
            invite.expiresIn,
            valueColor: invite.isExpiringSoon
                ? AppColors.error
                : AppColors.grey700,
          ),

          const SizedBox(height: 20),

          // ── Action Buttons ────────────────────────────
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _declineInvite(invite),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(
                      color: AppColors.error,
                    ),
                  ),
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => _acceptInvite(invite),
                  child: const Text('Accept & Join'),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  // One detail row inside invite card
  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color valueColor = AppColors.grey900,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.grey500),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.grey500,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ── Invite data model ─────────────────────────────────────────
class _GroupInvite {
  final String groupName;
  final String groupType;
  final int memberCount;
  final String invitedBy;
  final String assignedRole;
  final String expiresIn;
  final bool isExpiringSoon;

  const _GroupInvite({
    required this.groupName,
    required this.groupType,
    required this.memberCount,
    required this.invitedBy,
    required this.assignedRole,
    required this.expiresIn,
    required this.isExpiringSoon,
  });
}