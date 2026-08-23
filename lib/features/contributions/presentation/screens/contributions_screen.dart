import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Status of each contribution
enum ContributionStatus { paid, pending, late }

/// Data model for one contribution record
class Contribution {
  final String id;
  final String memberName;
  final String memberInitial;
  final String memberRole;
  final int amount;
  final ContributionStatus status;
  final String date;
  final String? receiptNumber;

  const Contribution({
    required this.id,
    required this.memberName,
    required this.memberInitial,
    required this.memberRole,
    required this.amount,
    required this.status,
    required this.date,
    this.receiptNumber,
  });
}
class ContributionsScreen extends StatefulWidget {
  const ContributionsScreen({super.key});

  @override
  State<ContributionsScreen> createState() =>
      _ContributionsScreenState();
}
class _ContributionsScreenState
    extends State<ContributionsScreen> {

// Currently selected filter
String _selectedFilter = 'All';

final List<String> _filters = [
'All',
'Paid',
'Pending',
'Late',
];

// Sample data — TODO: replace with real API
final List<Contribution> _allContributions = const [
Contribution(
id: '1',
memberName: 'Grace Atanga',
memberInitial: 'G',
memberRole: 'Secretary',
amount: 5000,
status: ContributionStatus.paid,
date: 'June 1, 2025',
receiptNumber: '#0001',
),
Contribution(
id: '2',
memberName: 'John Mbah',
memberInitial: 'J',
memberRole: 'Member',
amount: 5000,
status: ContributionStatus.paid,
date: 'June 3, 2025',
receiptNumber: '#0002',
),
Contribution(
id: '3',
memberName: 'Paul Ngono',
memberInitial: 'P',
memberRole: 'Treasurer',
amount: 5000,
status: ContributionStatus.paid,
date: 'June 4, 2025',
receiptNumber: '#0003',
),
Contribution(
id: '4',
memberName: 'Mary Fon',
memberInitial: 'M',
memberRole: 'Member',
amount: 5000,
status: ContributionStatus.pending,
date: 'Due June 15, 2025',
),
Contribution(
id: '5',
memberName: 'David Che',
memberInitial: 'D',
memberRole: 'Member',
amount: 5000,
status: ContributionStatus.pending,
date: 'Due June 15, 2025',
),
Contribution(
id: '6',
memberName: 'Samuel Nkeng',
memberInitial: 'S',
memberRole: 'Member',
amount: 5000,
status: ContributionStatus.late,
date: 'Was due June 1, 2025',
),
Contribution(
id: '7',
memberName: 'Beatrice Yong',
memberInitial: 'B',
memberRole: 'Shortee',
amount: 5000,
status: ContributionStatus.late,
date: 'Was due June 1, 2025',
),
Contribution(
id: '8',
memberName: 'Emmanuel Tanyi',
memberInitial: 'E',
memberRole: 'President',
amount: 5000,
status: ContributionStatus.paid,
date: 'June 2, 2025',
receiptNumber: '#0004',
),
];

// Filtered list based on selected tab
List<Contribution> get _filtered {
if (_selectedFilter == 'All') return _allContributions;
return _allContributions.where((c) {
switch (_selectedFilter) {
case 'Paid':
return c.status == ContributionStatus.paid;
case 'Pending':
return c.status == ContributionStatus.pending;
case 'Late':
return c.status == ContributionStatus.late;
default:
return true;
}
}).toList();
}

// Summary calculations
int get _totalCollected => _allContributions
.where((c) => c.status == ContributionStatus.paid)
.fold(0, (sum, c) => sum + c.amount);

int get _totalExpected => _allContributions
.fold(0, (sum, c) => sum + c.amount);

int get _totalOutstanding =>
_totalExpected - _totalCollected;

int get _paidCount => _allContributions
.where((c) => c.status == ContributionStatus.paid)
.length;

int get _pendingCount => _allContributions
.where((c) => c.status == ContributionStatus.pending)
.length;

int get _lateCount => _allContributions
.where((c) => c.status == ContributionStatus.late)
.length;
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: AppColors.grey100,
appBar: AppBar(
title: const Text('Contributions'),
automaticallyImplyLeading: false,
actions: [
// Export button
IconButton(
onPressed: () {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: const Text(
'Export — coming soon',
),
backgroundColor: AppColors.info,
behavior: SnackBarBehavior.floating,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
);
},
icon: const Icon(Icons.download_rounded),
tooltip: 'Export Report',
),
],
),
body: SafeArea(
child: Column(
children: [

// ── Cycle Summary Card ───────────────────────
_buildSummaryCard(),

// ── Filter Tabs ──────────────────────────────
_buildFilterTabs(),

// ── Contributions List ───────────────────────
Expanded(
child: _filtered.isEmpty
? _buildEmptyState()
: ListView.builder(
padding: const EdgeInsets.all(16),
itemCount: _filtered.length,
itemBuilder: (context, index) {
return _buildContributionTile(
_filtered[index],
);
},
),
),

],
),
),

// Record payment FAB — Treasurer only
// TODO: show only if user role is Treasurer
floatingActionButton: FloatingActionButton.extended(
onPressed: () => _showRecordPaymentSheet(context),
backgroundColor: AppColors.primary,
icon: const Icon(
Icons.add_rounded,
color: AppColors.white,
),
label: Text(
'Record Payment',
style: AppTextStyles.button.copyWith(
color: AppColors.white,
),
),
),
);
}
Widget _buildSummaryCard() {
double progress = _totalExpected > 0
? _totalCollected / _totalExpected
: 0.0;

return Container(
margin: const EdgeInsets.all(16),
padding: const EdgeInsets.all(16),
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

// Title and cycle label
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
'Cycle 3 — Turn 7',
style: AppTextStyles.bodyMedium.copyWith(
color: AppColors.white.withOpacity(0.8),
),
),
Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 4,
),
decoration: BoxDecoration(
color: AppColors.secondary.withOpacity(0.2),
borderRadius: BorderRadius.circular(20),
),
child: Text(
'$_paidCount of ${_allContributions.length} paid',
style: AppTextStyles.caption.copyWith(
color: AppColors.secondary,
fontWeight: FontWeight.w600,
),
),
),
],
),

const SizedBox(height: 12),

// Collected amount
Text(
'${_formatAmount(_totalCollected)} CFA',
style: AppTextStyles.amountLarge.copyWith(
color: AppColors.white,
fontSize: 28,
),
),

Text(
'collected of ${_formatAmount(_totalExpected)} CFA',
style: AppTextStyles.bodySmall.copyWith(
color: AppColors.white.withOpacity(0.7),
),
),

const SizedBox(height: 12),

// Progress bar
ClipRRect(
borderRadius: BorderRadius.circular(4),
child: LinearProgressIndicator(
value: progress,
backgroundColor: AppColors.white.withOpacity(0.2),
valueColor: const AlwaysStoppedAnimation<Color>(
AppColors.secondary,
),
minHeight: 8,
),
),

const SizedBox(height: 12),

// Stats row
Row(
children: [
_buildStat(
'$_paidCount Paid',
AppColors.secondary,
),
const SizedBox(width: 16),
_buildStat(
'$_pendingCount Pending',
AppColors.white.withOpacity(0.7),
),
const SizedBox(width: 16),
_buildStat(
'$_lateCount Late',
AppColors.error,
),
],
),

],
),
);
}

Widget _buildStat(String label, Color color) {
return Row(
children: [
Container(
width: 8,
height: 8,
decoration: BoxDecoration(
shape: BoxShape.circle,
color: color,
),
),
const SizedBox(width: 4),
Text(
label,
style: AppTextStyles.caption.copyWith(
color: AppColors.white.withOpacity(0.9),
),
),
],
);
}
Widget _buildFilterTabs() {
return Container(
color: AppColors.white,
padding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 8,
),
child: Row(
children: _filters.map((filter) {
bool isSelected = _selectedFilter == filter;
return GestureDetector(
onTap: () {
setState(() => _selectedFilter = filter);
},
child: AnimatedContainer(
duration: const Duration(milliseconds: 200),
margin: const EdgeInsets.only(right: 8),
padding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 8,
),
decoration: BoxDecoration(
color: isSelected
? AppColors.primary
: AppColors.grey100,
borderRadius: BorderRadius.circular(20),
),
child: Text(
filter,
style: AppTextStyles.labelMedium.copyWith(
color: isSelected
? AppColors.white
: AppColors.grey700,
fontWeight: isSelected
? FontWeight.w600
: FontWeight.w400,
),
),
),
);
}).toList(),
),
);
}
Widget _buildContributionTile(Contribution contribution) {
return GestureDetector(
onTap: () => _showContributionDetail(contribution),
child: Container(
margin: const EdgeInsets.only(bottom: 8),
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: AppColors.white,
borderRadius: BorderRadius.circular(12),
border: Border.all(
color: _borderColor(contribution.status),
),
),
child: Row(
children: [

// ── Avatar ──────────────────────────────────
Container(
width: 44,
height: 44,
decoration: BoxDecoration(
shape: BoxShape.circle,
color: _statusColor(contribution.status)
.withOpacity(0.1),
),
child: Center(
child: Text(
contribution.memberInitial,
style: AppTextStyles.headlineSmall.copyWith(
color: _statusColor(contribution.status),
),
),
),
),

const SizedBox(width: 12),

// ── Member info ──────────────────────────────
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
contribution.memberName,
style: AppTextStyles.bodyMedium.copyWith(
fontWeight: FontWeight.w600,
),
),
Text(
contribution.date,
style: AppTextStyles.caption.copyWith(
color: AppColors.grey500,
),
),
if (contribution.receiptNumber != null)
Text(
contribution.receiptNumber!,
style: AppTextStyles.caption.copyWith(
color: AppColors.primary,
fontWeight: FontWeight.w500,
),
),
],
),
),

// ── Amount and status ────────────────────────
Column(
crossAxisAlignment: CrossAxisAlignment.end,
children: [
Text(
'${_formatAmount(contribution.amount)} CFA',
style: AppTextStyles.amountSmall.copyWith(
color: _statusColor(contribution.status),
),
),
const SizedBox(height: 4),
_buildStatusBadge(contribution.status),
],
),

],
),
),
);
}

Widget _buildStatusBadge(ContributionStatus status) {
return Container(
padding: const EdgeInsets.symmetric(
horizontal: 8,
vertical: 2,
),
decoration: BoxDecoration(
color: _statusColor(status).withOpacity(0.1),
borderRadius: BorderRadius.circular(20),
),
child: Text(
_statusLabel(status),
style: AppTextStyles.caption.copyWith(
color: _statusColor(status),
fontWeight: FontWeight.w600,
),
),
);
}
// Status colour
Color _statusColor(ContributionStatus status) {
switch (status) {
case ContributionStatus.paid:
return AppColors.success;
case ContributionStatus.pending:
return AppColors.warning;
case ContributionStatus.late:
return AppColors.error;
}
}

// Border colour — subtle version of status colour
Color _borderColor(ContributionStatus status) {
switch (status) {
case ContributionStatus.paid:
return AppColors.grey300;
case ContributionStatus.pending:
return AppColors.warningSurface;
case ContributionStatus.late:
return AppColors.errorSurface;
}
}

// Status label
String _statusLabel(ContributionStatus status) {
switch (status) {
case ContributionStatus.paid:
return 'Paid';
case ContributionStatus.pending:
return 'Pending';
case ContributionStatus.late:
return 'Late';
}
}

// Format amount with thousands separator
String _formatAmount(int amount) {
return amount.toString().replaceAllMapped(
RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
(m) => '${m[1]},',
);
}

// Empty state
Widget _buildEmptyState() {
return Center(
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
const Icon(
Icons.receipt_long_rounded,
size: 64,
color: AppColors.grey300,
),
const SizedBox(height: 16),
Text(
'No contributions found',
style: AppTextStyles.headlineMedium,
),
const SizedBox(height: 8),
Text(
'No $_selectedFilter contributions yet',
style: AppTextStyles.bodyMedium.copyWith(
color: AppColors.grey700,
),
),
],
),
);
}
  // Bottom sheet to record a payment
  void _showRecordPaymentSheet(BuildContext context) {
    final phoneController = TextEditingController();
    final amountController = TextEditingController();
    String selectedMember = 'Mary Fon';
    bool isRecording = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Handle bar
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

                  Text(
                    'Record Payment',
                    style: AppTextStyles.headlineLarge,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Record a contribution payment for a member.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey700,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Member dropdown
                  Text(
                    'Select Member',
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.grey300,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMember,
                        isExpanded: true,
                        style: AppTextStyles.bodyLarge
                            .copyWith(color: AppColors.grey900),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.grey500,
                        ),
                        items: [
                          'Mary Fon',
                          'David Che',
                          'Samuel Nkeng',
                          'Beatrice Yong',
                        ].map((name) {
                          return DropdownMenuItem(
                            value: name,
                            child: Text(name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setSheetState(() {
                            selectedMember = value!;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Amount field
                  Text(
                    'Amount (CFA)',
                    style: AppTextStyles.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: AppTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: '5,000',
                      prefixIcon: Icon(
                        Icons.payments_rounded,
                        color: AppColors.grey500,
                      ),
                      suffixText: 'CFA',
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isRecording
                          ? null
                          : () async {
                        setSheetState(
                              () => isRecording = true,
                        );

                        // TODO: Call API to record payment
                        await Future.delayed(
                          const Duration(
                              milliseconds: 1500),
                        );

                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                'Payment recorded for $selectedMember ✅',
                              ),
                              backgroundColor:
                              AppColors.success,
                              behavior:
                              SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(8),
                              ),
                            ),
                          );
                        }
                      },
                      child: isRecording
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                          : const Text('Confirm Payment'),
                    ),
                  ),

                  const SizedBox(height: 8),

                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Contribution detail bottom sheet
  void _showContributionDetail(Contribution contribution) {
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

            // Avatar and name
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _statusColor(contribution.status)
                        .withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      contribution.memberInitial,
                      style:
                      AppTextStyles.headlineLarge.copyWith(
                        color: _statusColor(contribution.status),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contribution.memberName,
                      style: AppTextStyles.headlineMedium,
                    ),
                    Text(
                      contribution.memberRole,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),

            // Details
            _detailRow('Amount',
                '${_formatAmount(contribution.amount)} CFA'),
            const SizedBox(height: 12),
            _detailRow('Status',
                _statusLabel(contribution.status)),
            const SizedBox(height: 12),
            _detailRow('Date', contribution.date),
            if (contribution.receiptNumber != null) ...[
              const SizedBox(height: 12),
              _detailRow(
                  'Receipt', contribution.receiptNumber!),
            ],

            const SizedBox(height: 24),

            // Close button
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

} // end of _ContributionsScreenState