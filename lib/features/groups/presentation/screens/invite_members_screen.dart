import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';

class InviteMembersScreen extends StatefulWidget {
  const InviteMembersScreen({super.key});

  @override
  State<InviteMembersScreen> createState() =>
      _InviteMembersScreenState();
}

class _InviteMembersScreenState extends State<InviteMembersScreen> {

  // Group data passed from previous screen
  Map<String, dynamic> _groupData = {};

  // List of members being invited
  final List<_InvitedMember> _invitedMembers = [];

  // Controllers for the add member form
  final TextEditingController _phoneController =
  TextEditingController();
  String _selectedRole = 'Member';
  bool _isCreating = false;

  // Available roles admin can assign
  final List<String> _roles = [
    'Member',
    'Treasurer',
    'Secretary',
    'Shortee',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        setState(() {
          _groupData = args as Map<String, dynamic>;
        });
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  // Add a member to the invite list
  void _addMember() {
    final phone = _phoneController.text.trim();

    // Validate phone
    if (phone.isEmpty || phone.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please enter a valid 9-digit phone number',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    // Check duplicate
    final fullPhone = '+237$phone';
    final alreadyAdded = _invitedMembers
        .any((m) => m.phone == fullPhone);

    if (alreadyAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$fullPhone has already been added',
          ),
          backgroundColor: AppColors.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    // Add to list
    setState(() {
      _invitedMembers.add(
        _InvitedMember(
          phone: fullPhone,
          role: _selectedRole,
        ),
      );
      // Reset form
      _phoneController.clear();
      _selectedRole = 'Member';
    });
  }

  // Remove a member from invite list
  void _removeMember(int index) {
    setState(() => _invitedMembers.removeAt(index));
  }

  // How many more members needed
  int get _remaining =>
      (3 - _invitedMembers.length).clamp(0, 3);

  // Whether minimum is met
  bool get _minimumMet => _invitedMembers.length >= 3;

  // Create the group
  Future<void> _createGroup() async {
    if (!_minimumMet) return;

    setState(() => _isCreating = true);

    try {
      // TODO: Call API to create group and send invites
      // Pass _groupData and _invitedMembers to backend
      await Future.delayed(
        const Duration(milliseconds: 2000),
      );

      if (!mounted) return;

      // Group created — go to dashboard
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.shell,
            (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Failed to create group. Please try again.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        title: const Text('Invite Members'),
      ),
      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Step indicator ───────────────────
                    _buildStepIndicator(),
                    const SizedBox(height: 24),

                    // ── Minimum notice ───────────────────
                    _buildMinimumNotice(),
                    const SizedBox(height: 24),

                    // ── Add member form ──────────────────
                    _buildAddMemberForm(),
                    const SizedBox(height: 24),

                    // ── Invited list ─────────────────────
                    if (_invitedMembers.isNotEmpty) ...[
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Invited Members',
                            style: AppTextStyles.headlineSmall,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _minimumMet
                                  ? AppColors.successSurface
                                  : AppColors.warningSurface,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${_invitedMembers.length} added',
                              style: AppTextStyles.caption
                                  .copyWith(
                                color: _minimumMet
                                    ? AppColors.success
                                    : AppColors.secondaryDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ..._invitedMembers
                          .asMap()
                          .entries
                          .map((entry) {
                        return _buildMemberTile(
                          entry.value,
                          entry.key,
                        );
                      }),
                    ],

                  ],
                ),
              ),
            ),

            // ── Create Group Button ──────────────────────
            _buildCreateButton(),

          ],
        ),
      ),
    );
  }

  // Minimum 3 members notice
  Widget _buildMinimumNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _minimumMet
            ? AppColors.successSurface
            : AppColors.secondarySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _minimumMet
              ? AppColors.success
              : AppColors.secondary,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _minimumMet
                ? Icons.check_circle_rounded
                : Icons.info_rounded,
            color: _minimumMet
                ? AppColors.success
                : AppColors.secondaryDark,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _minimumMet
                  ? 'Minimum met! You can create the group.'
                  : 'You must invite at least $_remaining more member${_remaining == 1 ? '' : 's'} to continue.',
              style: AppTextStyles.bodySmall.copyWith(
                color: _minimumMet
                    ? AppColors.success
                    : AppColors.secondaryDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Add member form
  Widget _buildAddMemberForm() {
    return Container(
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
            'Add a Member',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 16),

          // Phone field
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            style: AppTextStyles.bodyLarge,
            decoration: InputDecoration(
              hintText: '6XX XXX XXX',
              prefixIcon: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: AppColors.grey300,
                    ),
                  ),
                ),
                child: Text(
                  '🇨🇲 +237',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Role dropdown
          Text(
            'Assign Role',
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
              border: Border.all(color: AppColors.grey300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedRole,
                isExpanded: true,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.grey900,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.grey500,
                ),
                items: _roles.map((role) {
                  return DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedRole = value!);
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Add button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _addMember,
              icon: const Icon(Icons.person_add_rounded),
              label: const Text('Add to Invite List'),
            ),
          ),

        ],
      ),
    );
  }

  // One invited member tile
  Widget _buildMemberTile(_InvitedMember member, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey300),
      ),
      child: Row(
        children: [

          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primarySurface,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // Phone and role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.phone,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  member.role,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          // Remove button
          IconButton(
            onPressed: () => _removeMember(index),
            icon: const Icon(
              Icons.remove_circle_outline_rounded,
              color: AppColors.error,
              size: 22,
            ),
          ),

        ],
      ),
    );
  }

  // Bottom create button
  Widget _buildCreateButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _minimumMet && !_isCreating
            ? _createGroup
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _minimumMet
              ? AppColors.primary
              : AppColors.grey300,
        ),
        child: _isCreating
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.white,
          ),
        )
            : Text(
          _minimumMet
              ? 'Create Group & Send Invites'
              : 'Add ${_remaining} more member${_remaining == 1 ? '' : 's'} to continue',
        ),
      ),
    );
  }

  // Step indicator
  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildStep(1, 'Type', false),
        _buildStepLine(),
        _buildStep(2, 'Details', false),
        _buildStepLine(),
        _buildStep(3, 'Invite', true),
      ],
    );
  }

  Widget _buildStep(
      int number, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? AppColors.primary
                : AppColors.grey300,
          ),
          child: Center(
            child: Text(
              '$number',
              style: AppTextStyles.labelLarge.copyWith(
                color: isActive
                    ? AppColors.white
                    : AppColors.grey500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
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
    );
  }

  Widget _buildStepLine() {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: AppColors.grey300,
      ),
    );
  }
}

// ── Data model for invited member ─────────────────────────────
class _InvitedMember {
  final String phone;
  final String role;

  const _InvitedMember({
    required this.phone,
    required this.role,
  });
}