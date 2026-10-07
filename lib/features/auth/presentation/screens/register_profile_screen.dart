import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/routing/route_paths.dart';
import '../providers/auth_controller.dart';

/// User Details Screen for post-login onboarding.
///
/// Features:
/// - Light cream background #FAF7F2
/// - Header with back arrow & "User Details" (Playfair Display 28px bold #0B1F19)
/// - Subtitle: "Please confirm your personal details to begin your gold journey."
/// - 4 Rounded Card Inputs:
///   1. Full Name (prefilled from Google/profile if available)
///   2. Phone Number (prefilled from Phone auth/profile if available)
///   3. Email Address (prefilled from Google/profile if available)
///   4. Date of Birth (interactive date selector + formatted string)
/// - "NEXT" primary button (#063B2C) navigating directly to the KYC screen.
class RegisterProfileScreen extends ConsumerStatefulWidget {
  const RegisterProfileScreen({super.key});

  @override
  ConsumerState<RegisterProfileScreen> createState() => _RegisterProfileScreenState();
}

class _RegisterProfileScreenState extends ConsumerState<RegisterProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _mobileController;
  late final TextEditingController _emailController;
  late final TextEditingController _dobController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final AppAuthState appAuth = ref.read(appAuthStateProvider);
    final AuthFlowState authFlow = ref.read(authControllerProvider);

    // Prefill known info from Google SSO or Phone Authentication
    final String initialName = appAuth.userName.isNotEmpty
        ? appAuth.userName
        : (authFlow.authSession?.user.name ?? '');

    final String initialMobile = appAuth.userPhone.isNotEmpty
        ? appAuth.userPhone
        : (authFlow.phone.isNotEmpty
            ? '${authFlow.countryCode} ${authFlow.phone}'.trim()
            : (authFlow.authSession?.user.phone ?? ''));

    final String initialEmail = appAuth.userEmail.isNotEmpty
        ? appAuth.userEmail
        : (authFlow.authSession?.user.email ?? '');

    final String initialDob = appAuth.userDob.isNotEmpty ? appAuth.userDob : '';

    _nameController = TextEditingController(text: initialName);
    _mobileController = TextEditingController(text: initialMobile);
    _emailController = TextEditingController(text: initialEmail);
    _dobController = TextEditingController(text: initialDob);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    await HapticFeedback.selectionClick();
    DateTime initial = DateTime(1998, 1, 1);
    try {
      final List<String> parts = _dobController.text.split('/');
      if (parts.length == 3) {
        final int d = int.parse(parts[0]);
        final int m = int.parse(parts[1]);
        final int y = int.parse(parts[2]);
        initial = DateTime(y, m, d);
      }
    } catch (_) {}

    if (!mounted) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      helpText: 'Select Date of Birth (18+ required)',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF063B2C),
              onPrimary: Colors.white,
              onSurface: Color(0xFF101915),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String phone = _mobileController.text.trim();
    final String dob = _dobController.text.trim();

    // 1. Persist updated user details into global auth state and secure storage
    await ref.read(appAuthStateProvider.notifier).updateProfile(
          userName: name,
          userEmail: email,
          userPhone: phone,
          userDob: dob,
        );

    // Also update session in authController if available
    try {
      final AuthController authController = ref.read(authControllerProvider.notifier);
      final AuthFlowState currentFlow = ref.read(authControllerProvider);
      if (currentFlow.authSession != null) {
        final updatedUser = currentFlow.authSession!.user.copyWith(
          name: name,
          email: email,
          phone: phone,
        );
        final updatedSession = currentFlow.authSession!.copyWith(user: updatedUser);
        authController.updateSession(updatedSession);
      }
    } catch (_) {}

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      // 2. Navigate directly to KYC per Step 1 requirement
      await context.push(RoutePaths.kyc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Top Navigation Bar
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 12, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(RoutePaths.login);
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF101915),
                    size: 24,
                  ),
                ),
              ),
            ),

            // Scrollable Form Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: 8),

                      // Screen Title (Playfair Display 28px bold)
                      Center(
                        child: Text(
                          'User Details',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0B1F19),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          'Confirm your personal details to begin\nyour gold investment journey.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF636D69),
                            height: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Field 1: Name Card
                      _buildFieldCard(
                        icon: Icons.person_outline_rounded,
                        label: 'Full Name',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your full name';
                          }
                          if (value.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      // Field 2: Phone Number Card
                      _buildFieldCard(
                        icon: Icons.phone_android_rounded,
                        label: 'Phone Number',
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your phone number';
                          }
                          final String digits = value.replaceAll(RegExp(r'\D'), '');
                          if (digits.length < 10) {
                            return 'Please enter a valid 10-digit mobile number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      // Field 3: Email Address Card
                      _buildFieldCard(
                        icon: Icons.mail_outline_rounded,
                        label: 'Email Address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      // Field 4: Date of Birth Card
                      _buildFieldCard(
                        icon: Icons.calendar_today_rounded,
                        label: 'Date of Birth (DD/MM/YYYY)',
                        controller: _dobController,
                        keyboardType: TextInputType.datetime,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.date_range_rounded, color: Color(0xFF063B2C)),
                          onPressed: _selectDateOfBirth,
                        ),
                        onTap: _selectDateOfBirth,
                        readOnly: true,
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your date of birth';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      // NEXT Primary CTA Button
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _handleSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF063B2C),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'NEXT',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_rounded, size: 18),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 36),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldCard({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required FormFieldValidator<String> validator,
    Widget? suffixIcon,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEFE8DE)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF5EB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFC88A35), size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF7A8682),
                  ),
                ),
                TextFormField(
                  controller: controller,
                  keyboardType: keyboardType,
                  validator: validator,
                  readOnly: readOnly,
                  onTap: onTap,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF101915),
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.only(top: 2, bottom: 2),
                    border: InputBorder.none,
                    errorStyle: TextStyle(fontSize: 11, height: 1.1),
                  ),
                ),
              ],
            ),
          ),
          ?suffixIcon,
        ],
      ),
    );
  }
}
