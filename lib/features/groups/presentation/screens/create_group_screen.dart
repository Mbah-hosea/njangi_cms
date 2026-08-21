import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() =>
      _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _nameController =
  TextEditingController();
  final TextEditingController _descriptionController =
  TextEditingController();
  final TextEditingController _amountController =
  TextEditingController();
  final TextEditingController _maxMembersController =
  TextEditingController();

  // Group type passed from previous screen
  String _groupType = '';

  // Selected contribution frequency
  String _frequency = 'Monthly';
  final List<String> _frequencies = [
    'Weekly',
    'Bi-Weekly',
    'Monthly',
  ];

  // Group logo placeholder
  bool _hasLogo = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Read group type from previous screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null) {
        setState(() => _groupType = args as String);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _maxMembersController.dispose();
    super.dispose();
  }

  void _pickLogo() {
    // TODO: implement image picker
    setState(() => _hasLogo = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Image picker coming soon'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Collect all group details into a map
      // We pass this to the invite screen
      final groupData = {
        'type': _groupType,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'amount': int.parse(_amountController.text.trim()),
        'frequency': _frequency,
        'maxMembers': int.parse(
          _maxMembersController.text.trim(),
        ),
        'hasLogo': _hasLogo,
      };

      if (!mounted) return;

      // Go to invite members screen
      Navigator.pushNamed(
        context,
        AppRoutes.inviteMembers,
        arguments: groupData,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Something went wrong. Please try again.',
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey100,
      appBar: AppBar(
        title: const Text('Group Details'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Step indicator ─────────────────────────
                _buildStepIndicator(),
                const SizedBox(height: 32),

                // ── Group Logo ─────────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: _pickLogo,
                    child: Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: _hasLogo
                                ? AppColors.primarySurface
                                : AppColors.grey300,
                            borderRadius:
                            BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.groups_rounded,
                            size: 44,
                            color: _hasLogo
                                ? AppColors.primary
                                : AppColors.grey500,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Tap to add group logo (optional)',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Group Name ─────────────────────────────
                _buildLabel('Group Name'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Nkumu Village Group',
                    prefixIcon: Icon(
                      Icons.group_rounded,
                      color: AppColors.grey500,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a group name';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ── Description ────────────────────────────
                _buildLabel('Description (Optional)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText:
                    'Brief description of your group...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 48),
                      child: Icon(
                        Icons.description_rounded,
                        color: AppColors.grey500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Contribution Amount ────────────────────
                _buildLabel('Contribution Amount (CFA)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 5000',
                    prefixIcon: Icon(
                      Icons.payments_rounded,
                      color: AppColors.grey500,
                    ),
                    suffixText: 'CFA',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter contribution amount';
                    }
                    final amount = int.tryParse(value);
                    if (amount == null || amount < 100) {
                      return 'Minimum amount is 100 CFA';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ── Frequency ──────────────────────────────
                _buildLabel('Contribution Frequency'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.grey300,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _frequency,
                      isExpanded: true,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.grey900,
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.grey500,
                      ),
                      items: _frequencies.map((freq) {
                        return DropdownMenuItem(
                          value: freq,
                          child: Text(freq),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _frequency = value!);
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Max Members ────────────────────────────
                _buildLabel('Maximum Members'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _maxMembersController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'e.g. 20',
                    prefixIcon: Icon(
                      Icons.people_rounded,
                      color: AppColors.grey500,
                    ),
                    suffixText: 'members',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter maximum members';
                    }
                    final count = int.tryParse(value);
                    if (count == null || count < 3) {
                      return 'Minimum is 3 members';
                    }
                    if (count > 500) {
                      return 'Maximum is 500 members';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // ── Continue Button ────────────────────────
                ElevatedButton(
                  onPressed: _isLoading ? null : _continue,
                  child: _isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                      : const Text('Continue to Invite Members'),
                ),

                const SizedBox(height: 24),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // Step indicator at top
  Widget _buildStepIndicator() {
    return Row(
      children: [
        _buildStep(1, 'Type', false),
        _buildStepLine(),
        _buildStep(2, 'Details', true),
        _buildStepLine(),
        _buildStep(3, 'Invite', false),
      ],
    );
  }

  Widget _buildStep(int number, String label, bool isActive) {
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

  // Reusable field label
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.labelLarge,
    );
  }
}