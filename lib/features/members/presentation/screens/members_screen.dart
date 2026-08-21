import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Status of each member in the group
enum MemberStatus { active, pending, suspended }

/// Data model for one group member
class GroupMember {
  final String id;
  final String name;
  final String phone;
  final String role;
  final MemberStatus status;
  final String initial;
  final int totalPaid;
  final bool isOfficial;

  const GroupMember({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    required this.status,
    required this.initial,
    required this.totalPaid,
    this.isOfficial = false,
  });
}

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}
class _MembersScreenState extends State<MembersScreen> {

// Search query
String _searchQuery = '';
final TextEditingController _searchController =
TextEditingController();

// Sample members — TODO: replace with real API data
final List<GroupMember> _allMembers = const [
GroupMember(
id: '1',
name: 'Emmanuel Tanyi',
phone: '+237 677 001 001',
role: 'President',
status: MemberStatus.active,
initial: 'E',
totalPaid: 60000,
isOfficial: true,
),
GroupMember(
id: '2',
name: 'Paul Ngono',
phone: '+237 699 002 002',
role: 'Treasurer',
status: MemberStatus.active,
initial: 'P',
totalPaid: 55000,
isOfficial: true,
),
GroupMember(
id: '3',
name: 'Grace Atanga',
phone: '+237 655 003 003',
role: 'Secretary',
status: MemberStatus.active,
initial: 'G',
totalPaid: 50000,
isOfficial: true,
),
GroupMember(
id: '4',
name: 'John Mbah',
phone: '+237 677 004 004',
role: 'Member',
status: MemberStatus.active,
initial: 'J',
totalPaid: 45000,
),
GroupMember(
id: '5',
name: 'Mary Fon',
phone: '+237 699 005 005',
role: 'Member',
status: MemberStatus.pending,
initial: 'M',
totalPaid: 0,
),
GroupMember(
id: '6',
name: 'David Che',
phone: '+237 655 006 006',
role: 'Member',
status: MemberStatus.active,
initial: 'D',
totalPaid: 40000,
),
GroupMember(
id: '7',
name: 'Beatrice Yong',
phone: '+237 677 007 007',
role: 'Shortee',
status: MemberStatus.active,
initial: 'B',
totalPaid: 35000,
),
GroupMember(
id: '8',
name: 'Samuel Nkeng',
phone: '+237 699 008 008',
role: 'Member',
status: MemberStatus.suspended,
initial: 'S',
totalPaid: 20000,
),
];

// Filtered members based on search
List<GroupMember> get _filteredMembers {
if (_searchQuery.isEmpty) return _allMembers;
return _allMembers.where((m) {
return m.name.toLowerCase().contains(
_searchQuery.toLowerCase(),
) ||
m.phone.contains(_searchQuery) ||
m.role.toLowerCase().contains(
_searchQuery.toLowerCase(),
);
}).toList();
}

// Officials only
List<GroupMember> get _officials =>
_allMembers.where((m) => m.isOfficial).toList();

@override
void dispose() {
_searchController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: AppColors.grey100,
appBar: AppBar(
title: const Text('Members'),
automaticallyImplyLeading: false,
actions: [
// Invite button — Admin only
// TODO: show only if user role is Admin
IconButton(
onPressed: () {
// TODO: navigate to invite screen
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
content: const Text(
'Invite member — coming soon',
),
backgroundColor: AppColors.info,
behavior: SnackBarBehavior.floating,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(8),
),
),
);
},
icon: const Icon(Icons.person_add_rounded),
tooltip: 'Invite Member',
),
],
),
body: SafeArea(
child: Column(
children: [

// ── Search Bar ───────────────────────────────
_buildSearchBar(),

Expanded(
child: _filteredMembers.isEmpty
? _buildEmptySearch()
: ListView(
padding: const EdgeInsets.all(16),
children: [

// Officials section
if (_searchQuery.isEmpty) ...[
_buildSectionHeader(
'Officials',
_officials.length,
),
const SizedBox(height: 12),
_buildOfficialsRow(),
const SizedBox(height: 24),
],

// All members section
_buildSectionHeader(
_searchQuery.isEmpty
? 'All Members'
: 'Search Results',
_filteredMembers.length,
),
const SizedBox(height: 12),

// Member list
..._filteredMembers.map(
(member) => _buildMemberTile(member),
),

const SizedBox(height: 80),
],
),
),
],
),
),
);
}
Widget _buildSearchBar() {
return Container(
color: AppColors.white,
padding: const EdgeInsets.all(16),
child: TextField(
controller: _searchController,
style: AppTextStyles.bodyMedium,
onChanged: (value) {
setState(() => _searchQuery = value);
},
decoration: InputDecoration(
hintText: 'Search members...',
hintStyle: AppTextStyles.bodyMedium.copyWith(
color: AppColors.grey500,
),
prefixIcon: const Icon(
Icons.search_rounded,
color: AppColors.grey500,
),
suffixIcon: _searchQuery.isNotEmpty
? IconButton(
onPressed: () {
_searchController.clear();
setState(() => _searchQuery = '');
},
icon: const Icon(
Icons.clear_rounded,
color: AppColors.grey500,
),
)
: null,
filled: true,
fillColor: AppColors.grey100,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide.none,
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide.none,
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: const BorderSide(
color: AppColors.primary,
width: 1.5,
),
),
contentPadding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 12,
),
),
),
);
}
Widget _buildSectionHeader(String title, int count) {
return Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
title,
style: AppTextStyles.headlineSmall,
),
Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 4,
),
decoration: BoxDecoration(
color: AppColors.primarySurface,
borderRadius: BorderRadius.circular(20),
),
child: Text(
'$count',
style: AppTextStyles.caption.copyWith(
color: AppColors.primary,
fontWeight: FontWeight.w600,
),
),
),
],
);
}

// Officials displayed as horizontal row of avatars
Widget _buildOfficialsRow() {
return Row(
children: _officials.map((official) {
return Expanded(
child: GestureDetector(
onTap: () => _openMemberProfile(official),
child: Container(
margin: const EdgeInsets.only(right: 8),
padding: const EdgeInsets.all(12),
decoration: BoxDecoration(
color: AppColors.white,
borderRadius: BorderRadius.circular(12),
border: Border.all(
color: AppColors.grey300,
),
),
child: Column(
children: [
// Avatar
Container(
width: 48,
height: 48,
decoration: const BoxDecoration(
shape: BoxShape.circle,
color: AppColors.primary,
),
child: Center(
child: Text(
official.initial,
style:
AppTextStyles.headlineSmall.copyWith(
color: AppColors.white,
),
),
),
),
const SizedBox(height: 6),
Text(
official.name.split(' ').first,
style: AppTextStyles.labelMedium.copyWith(
fontWeight: FontWeight.w600,
),
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
),
);
}).toList(),
);
}
  // One member row — WhatsApp style
  Widget _buildMemberTile(GroupMember member) {
    return GestureDetector(
      onTap: () => _openMemberProfile(member),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Row(
          children: [

            // ── Avatar ────────────────────────────────
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _avatarColor(member.role),
              ),
              child: Center(
                child: Text(
                  member.initial,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // ── Name, role, phone ─────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          member.name,
                          style:
                          AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Status badge
                      _buildStatusBadge(member.status),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    member.role,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    member.phone,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),

            // ── Arrow ─────────────────────────────────
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey500,
              size: 20,
            ),

          ],
        ),
      ),
    );
  }

  // Status badge pill
  Widget _buildStatusBadge(MemberStatus status) {
    Color color;
    String label;

    switch (status) {
      case MemberStatus.active:
        color = AppColors.success;
        label = 'Active';
        break;
      case MemberStatus.pending:
        color = AppColors.warning;
        label = 'Pending';
        break;
      case MemberStatus.suspended:
        color = AppColors.error;
        label = 'Suspended';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Avatar colour based on role
  Color _avatarColor(String role) {
    switch (role) {
      case 'President':
        return AppColors.primary;
      case 'Treasurer':
        return AppColors.info;
      case 'Secretary':
        return AppColors.success;
      case 'Shortee':
        return AppColors.warning;
      default:
        return AppColors.grey500;
    }
  }

  // Empty search result
  Widget _buildEmptySearch() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppColors.grey300,
          ),
          const SizedBox(height: 16),
          Text(
            'No members found',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching by name, phone or role',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey700,
            ),
          ),
        ],
      ),
    );
  }

  // Navigate to member profile
  void _openMemberProfile(GroupMember member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MemberProfileScreen(member: member),
      ),
    );
  }

} // end of _MembersScreenState
// ── Member Profile Screen ─────────────────────────────────────
class MemberProfileScreen extends StatelessWidget {
  final GroupMember member;

  const MemberProfileScreen({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: CustomScrollView(
        slivers: [

          // ── Green header with avatar ─────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: AppColors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              // Admin action menu
              // TODO: show only if current user is Admin
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.white,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) =>
                    _handleAdminAction(context, value),
                itemBuilder: (context) => [
                  _menuItem(
                    'change_role',
                    Icons.badge_rounded,
                    'Change Role',
                  ),
                  _menuItem(
                    'suspend',
                    Icons.pause_circle_rounded,
                    'Suspend Member',
                  ),
                  _menuItem(
                    'reinstate',
                    Icons.play_circle_rounded,
                    'Reinstate Member',
                  ),
                  _menuItem(
                    'dismiss',
                    Icons.remove_circle_rounded,
                    'Dismiss Member',
                    isDestructive: true,
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white
                            .withOpacity(0.2),
                        border: Border.all(
                          color: AppColors.white,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          member.initial,
                          style: AppTextStyles.displayMedium
                              .copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      member.name,
                      style:
                      AppTextStyles.headlineLarge.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                        AppColors.secondary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        member.role,
                        style: AppTextStyles.labelMedium
                            .copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Profile Body ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  const SizedBox(height: 8),

                  // ── Stats row ──────────────────────────
                  _buildStatsRow(),
                  const SizedBox(height: 16),

                  // ── Details card ───────────────────────
                  _buildDetailsCard(),
                  const SizedBox(height: 16),

                  // ── Quick actions ──────────────────────
                  _buildQuickActions(context),
                  const SizedBox(height: 32),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Stats — total paid, fines, loans
  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStat(
          '${member.totalPaid ~/ 1000}K CFA',
          'Total Paid',
          AppColors.primary,
        ),
        _buildStat('0', 'Fines', AppColors.error),
        _buildStat('None', 'Active Loan', AppColors.info),
      ],
    );
  }

  Widget _buildStat(String value, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.amountMedium.copyWith(
                color: color,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.grey700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Member details
  Widget _buildDetailsCard() {
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
          Text(
            'Member Details',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            Icons.phone_rounded,
            'Phone',
            member.phone,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            Icons.badge_rounded,
            'Role',
            member.role,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            Icons.circle_rounded,
            'Status',
            member.status.name.toUpperCase(),
            valueColor: member.status == MemberStatus.active
                ? AppColors.success
                : member.status == MemberStatus.pending
                ? AppColors.warning
                : AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon,
      String label,
      String value, {
        Color valueColor = AppColors.grey900,
      }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.grey500),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.grey700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // Quick action buttons
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Records',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 12),
        _buildActionTile(
          context,
          Icons.receipt_long_rounded,
          'Contribution History',
          'View all payments made',
        ),
        _buildActionTile(
          context,
          Icons.warning_rounded,
          'Fine History',
          'View all fines applied',
        ),
        _buildActionTile(
          context,
          Icons.handshake_rounded,
          'Loan History',
          'View all loan records',
        ),
        _buildActionTile(
          context,
          Icons.event_rounded,
          'Meeting Attendance',
          'View attendance record',
        ),
      ],
    );
  }

  Widget _buildActionTile(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey300),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.grey700,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.grey500,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title — coming soon'),
              backgroundColor: AppColors.info,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }

  // Admin action handler
  void _handleAdminAction(BuildContext context, String action) {
    switch (action) {
      case 'change_role':
        _showChangeRoleDialog(context);
        break;
      case 'suspend':
        _showConfirmDialog(
          context,
          title: 'Suspend Member?',
          message:
          'Are you sure you want to suspend ${member.name}?',
          confirmLabel: 'Suspend',
          confirmColor: AppColors.warning,
        );
        break;
      case 'reinstate':
        _showConfirmDialog(
          context,
          title: 'Reinstate Member?',
          message:
          'Reinstate ${member.name} as an active member?',
          confirmLabel: 'Reinstate',
          confirmColor: AppColors.success,
        );
        break;
      case 'dismiss':
        _showConfirmDialog(
          context,
          title: 'Dismiss Member?',
          message:
          'This will permanently remove ${member.name} from the group. This action is logged.',
          confirmLabel: 'Dismiss',
          confirmColor: AppColors.error,
        );
        break;
    }
  }

  // Change role dialog
  void _showChangeRoleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Change Role',
          style: AppTextStyles.headlineMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Member',
            'Treasurer',
            'Secretary',
            'Shortee',
          ].map((role) {
            return ListTile(
              title: Text(
                role,
                style: AppTextStyles.bodyMedium,
              ),
              leading: Radio<String>(
                value: role,
                groupValue: member.role,
                activeColor: AppColors.primary,
                onChanged: (value) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${member.name} role changed to $value',
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // Generic confirm dialog
  void _showConfirmDialog(
      BuildContext context, {
        required String title,
        required String message,
        required String confirmLabel,
        required Color confirmColor,
      }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: AppTextStyles.headlineMedium,
        ),
        content: Text(
          message,
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
              // TODO: Call API for this action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
            ),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  // Popup menu item helper
  PopupMenuItem<String> _menuItem(
      String value,
      IconData icon,
      String label, {
        bool isDestructive = false,
      }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isDestructive
                ? AppColors.error
                : AppColors.grey700,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isDestructive
                  ? AppColors.error
                  : AppColors.grey900,
            ),
          ),
        ],
      ),
    );
  }
}