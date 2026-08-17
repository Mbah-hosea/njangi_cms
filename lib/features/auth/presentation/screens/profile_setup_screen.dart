import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() =>
      _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController =
      TextEditingController();
  final TextEditingController _emergencyController =
      TextEditingController();

  bool _hasPhoto = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emergencyController.dispose();
    super.dispose();
  }

  void _pickPhoto() {
    // TODO: implement image picker
    setState(() => _hasPhoto = true);
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

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // TODO: Save profile to backend and SharedPreferences
      await Future.delayed(const Duration(milliseconds: 1000));

      if (!mounted) return;

      // Go to group choice — clear all auth screens
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.groupChoice,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Failed to save profile. Please try again.',
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
        title: const Text('Set Up Your Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Intro Text ─────────────────────────────
                Text(
                  'Almost there!',
                  style: AppTextStyles.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Set up your profile so other group members can recognise you.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey700,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Profile Photo ──────────────────────────
                Center(
                  child: GestureDetector(
                    onTap: _pickPhoto,
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _hasPhoto
                                ? AppColors.primarySurface
                                : AppColors.grey300,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            size: 50,
                            color: _hasPhoto
                                ? AppColors.primary
                                : AppColors.grey500,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              size: 16,
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
                    'Tap to add photo',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Full Name ──────────────────────────────
                Text(
                  'Full Name',
                  style: AppTextStyles.labelLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Grace Eko Ngono',
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.grey500,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    if (value.trim().length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ── Emergency Contact ──────────────────────
                Text(
                  'Emergency Contact Number',
                  style: AppTextStyles.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'In case the group needs to reach someone on your behalf',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emergencyController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                  ],
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: '6XX XXX XXX',
                    prefixIcon: Icon(
                      Icons.emergency_rounded,
                      color: AppColors.grey500,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an emergency contact';
                    }
                    if (value.length < 9) {
                      return 'Enter a valid 9-digit number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // ── Complete Setup Button ──────────────────
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : const Text('Complete Setup'),
                ),

                const SizedBox(height: 16),

                // ── Skip For Now ───────────────────────────
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Go to group choice — clear all auth screens
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.groupChoice,
                        (route) => false,
                      );
                    },
                    child: Text(
                      'Skip for now',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

} // end of _ProfileSetupScreenState