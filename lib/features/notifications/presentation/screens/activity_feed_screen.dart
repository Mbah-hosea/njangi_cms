import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Type of activity event
enum ActivityType {
  contribution,
  payout,
  fine,
  loan,
  expenditure,
  meeting,
  memberJoined,
  announcement,
}

/// One activity event in the feed
class ActivityEvent {
  final String id;
  final ActivityType type;
  final String title;
  final String subtitle;
  final String time;
  final String date;
  final String? amount;
  final String recordedBy;

  const ActivityEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.date,
    this.amount,
    required this.recordedBy,
  });
}
class ActivityFeedScreen extends StatefulWidget {
  const ActivityFeedScreen({super.key});

  @override
  State<ActivityFeedScreen> createState() =>
      _ActivityFeedScreenState();
}

class _ActivityFeedScreenState
    extends State<ActivityFeedScreen> {

// Sample activity data grouped by date
// TODO: replace with real API data
final Map<String, List<ActivityEvent>> _feedByDate = {
'Today — June 1, 2025': [
const ActivityEvent(
id: '1',
type: ActivityType.contribution,
title: 'Contribution received',
subtitle: 'John Mbah · Cycle 3',
time: '10:42 AM',
date: 'Today',
amount: '5,000 CFA',
recordedBy: 'Treasurer Paul N.',
),
const ActivityEvent(
id: '2',
type: ActivityType.contribution,
title: 'Contribution received',
subtitle: 'Emmanuel Tanyi · Cycle 3',
time: '11:15 AM',
date: 'Today',
amount: '5,000 CFA',
recordedBy: 'Treasurer Paul N.',
),
const ActivityEvent(
id: '3',
type: ActivityType.fine,
title: 'Fine applied',
subtitle: 'Grace Eko · Late payment',
time: '2:00 PM',
date: 'Today',
amount: '500 CFA',
recordedBy: 'Admin Emmanuel T.',
),
],
'Yesterday — May 31, 2025': [
const ActivityEvent(
id: '4',
type: ActivityType.payout,
title: 'Payout confirmed',
subtitle: 'Mary Fon · Cycle 3 Turn 6',
time: '3:30 PM',
date: 'Yesterday',
amount: '60,000 CFA',
recordedBy: 'President Emmanuel T.',
),
const ActivityEvent(
id: '5',
type: ActivityType.memberJoined,
title: 'New member joined',
subtitle: 'David Che accepted invitation',
time: '9:00 AM',
date: 'Yesterday',
recordedBy: 'System',
),
],
'May 30, 2025': [
const ActivityEvent(
id: '6',
type: ActivityType.loan,
title: 'Loan approved',
subtitle: 'Beatrice Yong · Shortee: Paul N.',
time: '4:00 PM',
date: 'May 30',
amount: '20,000 CFA',
recordedBy: 'Admin Emmanuel T.',
),
const ActivityEvent(
id: '7',
type: ActivityType.meeting,
title: 'Meeting held',
subtitle: 'Monthly meeting · 12 attended',
time: '3:00 PM',
date: 'May 30',
recordedBy: 'Secretary Grace A.',
),
const ActivityEvent(
id: '8',
type: ActivityType.expenditure,
title: 'Expenditure recorded',
subtitle: 'Meeting refreshments',
time: '5:30 PM',
date: 'May 30',
amount: '15,000 CFA',
recordedBy: 'Treasurer Paul N.',
),
],
};
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: AppColors.grey100,
appBar: AppBar(
title: const Text('Activity Feed'),
automaticallyImplyLeading: false,
actions: [
IconButton(
onPressed: () {
// TODO: filter activity by type
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: const Text('Filter — coming soon'),
backgroundColor: AppColors.info,
behavior: SnackBarBehavior.floating,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
);
},
icon: const Icon(Icons.filter_list_rounded),
tooltip: 'Filter',
),
],
),
body: SafeArea(
child: ListView.builder(
padding: const EdgeInsets.all(16),
itemCount: _feedByDate.length,
itemBuilder: (context, groupIndex) {
final date = _feedByDate.keys
.elementAt(groupIndex);
final events = _feedByDate[date]!;

return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [

// ── Date header ────────────────────────
_buildDateHeader(date),
const SizedBox(height: 8),

// ── Events for this date ───────────────
...events.map(
(event) => _buildEventCard(event),
),

const SizedBox(height: 16),

],
);
},
),
),
);
}
// Date group header
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

// One activity event card
Widget _buildEventCard(ActivityEvent event) {
return GestureDetector(
onTap: () => _showEventDetail(event),
child: Container(
margin: const EdgeInsets.only(bottom: 8),
padding: const EdgeInsets.all(14),
decoration: BoxDecoration(
color: AppColors.white,
borderRadius: BorderRadius.circular(12),
border: Border.all(
color: AppColors.grey300,
),
// Left coloured border indicates event type
// We achieve this with a left border accent
),
child: Row(
children: [

// ── Event type icon ──────────────────────
Container(
width: 40,
height: 40,
decoration: BoxDecoration(
shape: BoxShape.circle,
color: _eventColor(event.type)
.withOpacity(0.1),
),
child: Icon(
_eventIcon(event.type),
color: _eventColor(event.type),
size: 20,
),
),

const SizedBox(width: 12),

// ── Event details ────────────────────────
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
event.title,
style: AppTextStyles.bodyMedium.copyWith(
fontWeight: FontWeight.w600,
color: _eventColor(event.type),
),
),
const SizedBox(height: 2),
Text(
event.subtitle,
style: AppTextStyles.bodySmall.copyWith(
color: AppColors.grey900,
),
),
const SizedBox(height: 2),
Text(
'By: ${event.recordedBy} · ${event.time}',
style: AppTextStyles.caption.copyWith(
color: AppColors.grey500,
),
),
],
),
),

// ── Amount (if any) ──────────────────────
if (event.amount != null)
Text(
event.amount!,
style: AppTextStyles.amountSmall.copyWith(
color: _eventColor(event.type),
fontSize: 13,
),
),

],
),
),
);
}
  // Event type colour
  Color _eventColor(ActivityType type) {
    switch (type) {
      case ActivityType.contribution:
        return AppColors.eventContribution;
      case ActivityType.payout:
        return AppColors.eventPayout;
      case ActivityType.fine:
        return AppColors.eventFine;
      case ActivityType.loan:
        return AppColors.eventLoan;
      case ActivityType.expenditure:
        return AppColors.eventExpenditure;
      case ActivityType.meeting:
        return AppColors.eventMeeting;
      case ActivityType.memberJoined:
        return AppColors.success;
      case ActivityType.announcement:
        return AppColors.info;
    }
  }

  // Event type icon
  IconData _eventIcon(ActivityType type) {
    switch (type) {
      case ActivityType.contribution:
        return Icons.arrow_downward_rounded;
      case ActivityType.payout:
        return Icons.account_balance_wallet_rounded;
      case ActivityType.fine:
        return Icons.warning_rounded;
      case ActivityType.loan:
        return Icons.handshake_rounded;
      case ActivityType.expenditure:
        return Icons.shopping_cart_rounded;
      case ActivityType.meeting:
        return Icons.groups_rounded;
      case ActivityType.memberJoined:
        return Icons.person_add_rounded;
      case ActivityType.announcement:
        return Icons.campaign_rounded;
    }
  }

  // Event detail bottom sheet
  void _showEventDetail(ActivityEvent event) {
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

            // Handle
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

            // Icon and title
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _eventColor(event.type)
                        .withOpacity(0.1),
                  ),
                  child: Icon(
                    _eventIcon(event.type),
                    color: _eventColor(event.type),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: AppTextStyles.headlineMedium
                            .copyWith(
                          color: _eventColor(event.type),
                        ),
                      ),
                      Text(
                        event.subtitle,
                        style: AppTextStyles.bodySmall
                            .copyWith(
                          color: AppColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Details
            _detailRow('Date', event.date),
            const SizedBox(height: 12),
            _detailRow('Time', event.time),
            const SizedBox(height: 12),
            _detailRow('Recorded by', event.recordedBy),
            if (event.amount != null) ...[
              const SizedBox(height: 12),
              _detailRow('Amount', event.amount!),
            ],

            const SizedBox(height: 8),

            // Audit note
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This record is permanent and cannot be deleted. It is part of the group audit trail.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
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

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.grey700,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

} // end of _ActivityFeedScreenState
