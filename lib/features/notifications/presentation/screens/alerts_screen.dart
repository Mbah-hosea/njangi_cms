import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Type of personal alert
enum AlertType {
  paymentRecorded,
  payoutComing,
  shorteeRequest,
  loanApproved,
  loanRejected,
  fineApplied,
  meetingReminder,
  memberJoined,
  announcement,
}

/// One personal alert
class UserAlert {
  final String id;
  final AlertType type;
  final String title;
  final String message;
  final String time;
  final String date;
  final bool isRead;
  final bool requiresAction;

  const UserAlert({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.date,
    this.isRead = false,
    this.requiresAction = false,
  });
}

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {

  // Sample alerts grouped by date
  // TODO: replace with real API data
  final Map<String, List<UserAlert>> _alertsByDate = {
    'Today': [
      const UserAlert(
        id: '1',
        type: AlertType.paymentRecorded,
        title: 'Payment Recorded',
        message:
        'Your contribution of 5,000 CFA has been recorded. Receipt #0001.',
        time: '10:42 AM',
        date: 'Today',
        isRead: false,
      ),
      const UserAlert(
        id: '2',
        type: AlertType.payoutComing,
        title: 'Payout Coming Soon',
        message:
        'You are next to receive the payout of 60,000 CFA on June 15, 2025.',
        time: '11:00 AM',
        date: 'Today',
        isRead: false,
      ),
    ],
    'Yesterday': [
      const UserAlert(
        id: '3',
        type: AlertType.shorteeRequest,
        title: 'Shortee Request',
        message:
        'Paul Ngono has selected you as guarantor for a loan of 20,000 CFA. Please accept or decline.',
        time: '9:00 AM',
        date: 'Yesterday',
        isRead: false,
        requiresAction: true,
      ),
      const UserAlert(
        id: '4',
        type: AlertType.meetingReminder,
        title: 'Meeting Tomorrow',
        message:
        'Monthly group meeting is tomorrow, June 1 at 3:00 PM. Please attend.',
        time: '8:00 AM',
        date: 'Yesterday',
        isRead: true,
      ),
    ],
    'May 30, 2025': [
      const UserAlert(
        id: '5',
        type: AlertType.fineApplied,
        title: 'Fine Applied',
        message:
        'A fine of 500 CFA has been applied to your account for late payment. Please clear it promptly.',
        time: '2:00 PM',
        date: 'May 30',
        isRead: true,
      ),
      const UserAlert(
        id: '6',
        type: AlertType.loanApproved,
        title: 'Loan Approved',
        message:
        'Your loan request of 15,000 CFA has been approved by the Admin. Repayment starts next cycle.',
        time: '4:30 PM',
        date: 'May 30',
        isRead: true,
      ),
    ],
  };

  // Count unread alerts
  int get _unreadCount => _alertsByDate.values
      .expand((list) => list)
      .where((a) => !a.isRead)
      .length;

  // Mark all as read
  void _markAllRead() {
    setState(() {
      // TODO: Call API to mark all read
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All alerts marked as read'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Alerts'),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_unreadCount',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _alertsByDate.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _alertsByDate.length,
          itemBuilder: (context, groupIndex) {
            final date = _alertsByDate.keys
                .elementAt(groupIndex);
            final alerts = _alertsByDate[date]!;

            return Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                // Date header
                _buildDateHeader(date),
                const SizedBox(height: 8),

                // Alerts for this date
                ...alerts.map(
                      (alert) => _buildAlertCard(alert),
                ),

                const SizedBox(height: 16),

              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return Row(
      children: [
        Text(
          date,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.grey700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.grey300,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertCard(UserAlert alert) {
    return GestureDetector(
      onTap: () => _showAlertDetail(alert),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: alert.isRead
              ? AppColors.white
              : AppColors.primarySurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: alert.requiresAction
                ? AppColors.secondary
                : alert.isRead
                ? AppColors.grey300
                : AppColors.primary.withOpacity(0.3),
            width: alert.requiresAction ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Alert icon ──────────────────────────
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _alertColor(alert.type)
                      .withOpacity(0.1),
                ),
                child: Icon(
                  _alertIcon(alert.type),
                  color: _alertColor(alert.type),
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              // ── Alert content ────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            alert.title,
                            style: AppTextStyles.bodyMedium
                                .copyWith(
                              fontWeight: FontWeight.w600,
                              color: alert.isRead
                                  ? AppColors.grey900
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                        // Unread dot
                        if (!alert.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      alert.message,
                      style: AppTextStyles.bodySmall
                          .copyWith(
                        color: AppColors.grey700,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    Text(
                      alert.time,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),

                    // Action buttons for Shortee request
                    if (alert.requiresAction) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // TODO: decline shortee
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Shortee request declined',
                                    ),
                                    backgroundColor:
                                    AppColors.error,
                                    behavior: SnackBarBehavior
                                        .floating,
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          8),
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: const BorderSide(
                                  color: AppColors.error,
                                ),
                                minimumSize:
                                const Size(0, 36),
                              ),
                              child: const Text('Decline'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: accept shortee
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Shortee request accepted ✅',
                                    ),
                                    backgroundColor:
                                    AppColors.success,
                                    behavior: SnackBarBehavior
                                        .floating,
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          8),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                const Size(0, 36),
                              ),
                              child: const Text('Accept'),
                            ),
                          ),
                        ],
                      ),
                    ],

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Alert detail bottom sheet
  void _showAlertDetail(UserAlert alert) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _alertColor(alert.type)
                        .withOpacity(0.1),
                  ),
                  child: Icon(
                    _alertIcon(alert.type),
                    color: _alertColor(alert.type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    alert.title,
                    style: AppTextStyles.headlineMedium
                        .copyWith(
                      color: _alertColor(alert.type),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              alert.message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey700,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 12),

            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${alert.date} · ${alert.time}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),

            const SizedBox(height: 8),

          ],
        ),
      ),
    );
  }

  // Alert colour by type
  Color _alertColor(AlertType type) {
    switch (type) {
      case AlertType.paymentRecorded:
        return AppColors.success;
      case AlertType.payoutComing:
        return AppColors.info;
      case AlertType.shorteeRequest:
        return AppColors.secondary;
      case AlertType.loanApproved:
        return AppColors.success;
      case AlertType.loanRejected:
        return AppColors.error;
      case AlertType.fineApplied:
        return AppColors.error;
      case AlertType.meetingReminder:
        return AppColors.primary;
      case AlertType.memberJoined:
        return AppColors.success;
      case AlertType.announcement:
        return AppColors.info;
    }
  }

  // Alert icon by type
  IconData _alertIcon(AlertType type) {
    switch (type) {
      case AlertType.paymentRecorded:
        return Icons.receipt_rounded;
      case AlertType.payoutComing:
        return Icons.account_balance_wallet_rounded;
      case AlertType.shorteeRequest:
        return Icons.handshake_rounded;
      case AlertType.loanApproved:
        return Icons.check_circle_rounded;
      case AlertType.loanRejected:
        return Icons.cancel_rounded;
      case AlertType.fineApplied:
        return Icons.warning_rounded;
      case AlertType.meetingReminder:
        return Icons.event_rounded;
      case AlertType.memberJoined:
        return Icons.person_add_rounded;
      case AlertType.announcement:
        return Icons.campaign_rounded;
    }
  }

  // Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.notifications_off_rounded,
            size: 64,
            color: AppColors.grey300,
          ),
          const SizedBox(height: 16),
          Text(
            'No Alerts Yet',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'You will be notified of payments,\nmeetings and important updates here.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey700,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

} // end of _AlertsScreenState