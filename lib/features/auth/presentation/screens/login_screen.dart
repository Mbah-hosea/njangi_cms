import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // Controls the phone number input field
  final TextEditingController _phoneController = TextEditingController();

  // Key that identifies our form for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Tracks if we are currently sending OTP
  bool _isLoading = false;

  @override
  void dispose() {
    // Free memory — always dispose controllers
    _phoneController.dispose();
    super.dispose();
  }

  // Validates and sends OTP
  Future<void> _continue() async {
    // Check if form is valid before doing anything
    if (!_formKey.currentState!.validate()) return;

    // Show loading state
    setState(() => _isLoading = true);

    try {
      // TODO: Send OTP via Firebase Auth
      // For now we simulate a 1.5 second network call
      await Future.delayed(const Duration(milliseconds: 1500));

      // Navigate to OTP screen, passing the phone number
      if (!mounted) return;
      Navigator.pushNamed(
        context,
        AppRoutes.otp,
        arguments: '+237${_phoneController.text.trim()}',
      );
    } catch (e) {
      // Show error if something goes wrong
      if (!mounted) return;
      _showError('Failed to send OTP. Please try again.');
    } finally {
      // Always hide loading — even if error occurred
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 48),

                // ── Logo & Title ─────────────────────────
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.groups_rounded,
                      size: 40,
                      color: AppColors.secondary,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  'Welcome Back',
                  style: AppTextStyles.displayMedium,
                ),

                const SizedBox(height: 8),

                Text(
                  'Enter your phone number to continue',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey700,
                  ),
                ),

                const SizedBox(height: 40),

                // ── Phone Number Label ───────────────────
                Text(
                  'Phone Number',
                  style: AppTextStyles.labelLarge,
                ),

                const SizedBox(height: 8),

                // ── Phone Number Field ───────────────────
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    // Only allow digits
                    FilteringTextInputFormatter.digitsOnly,
                    // Maximum 9 digits for Cameroon numbers
                    LengthLimitingTextInputFormatter(9),
                  ],
                  style: AppTextStyles.bodyLarge,
                  decoration: InputDecoration(
                    // Country code prefix — not editable
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
                    hintText: '6XX XXX XXX',
                    hintStyle: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  // Validation runs when user taps Continue
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length < 9) {
                      return 'Enter a valid 9-digit Cameroon number';
                    }
                    return null; // null means valid
                  },
                ),

                const SizedBox(height: 32),

                // ── Continue Button ──────────────────────
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
                      : const Text('Continue'),
                ),

                const SizedBox(height: 24),

                // ── Terms Notice ─────────────────────────
                Center(
                  child: Text(
                    'By continuing you agree to our Terms of Service',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}