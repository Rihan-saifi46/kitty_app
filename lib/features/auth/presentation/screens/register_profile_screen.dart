import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/routing/route_paths.dart';
import '../providers/auth_controller.dart';

/// User Profile Information Collection Screen (View 2.5 of Auth Flow).
///
/// Prompts the authenticated or newly verified patron for their personal
/// details (Full Name, Email Address, City) before granting access to the
/// bullion vault and kitty schemes.
class RegisterProfileScreen extends ConsumerStatefulWidget {
  const RegisterProfileScreen({super.key});

  @override
  ConsumerState<RegisterProfileScreen> createState() => _RegisterProfileScreenState();
}

class _RegisterProfileScreenState extends ConsumerState<RegisterProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _cityController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final AppAuthState appAuth = ref.read(appAuthStateProvider);
    final AuthFlowState authFlow = ref.read(authControllerProvider);

    final String initialName = appAuth.userName.isNotEmpty && appAuth.userName != 'Rihan'
        ? appAuth.userName
        : (authFlow.authSession?.user.name ?? '');

    final String initialEmail = authFlow.authSession?.user.email ?? '';

    _nameController = TextEditingController(text: initialName);
    _emailController = TextEditingController(text: initialEmail);
    _cityController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate() || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String city = _cityController.text.trim();

    // 1. Update AppAuthState and persistent SecureStorage
    await ref.read(appAuthStateProvider.notifier).updateProfile(
          userName: name,
          userEmail: email,
          city: city,
        );

    // 2. Refresh AuthController state with entered profile
    final AuthController authController = ref.read(authControllerProvider.notifier);
    final AuthFlowState currentFlow = ref.read(authControllerProvider);
    if (currentFlow.authSession != null) {
      final updatedUser = currentFlow.authSession!.user.copyWith(
        name: name,
        email: email,
      );
      final updatedSession = currentFlow.authSession!.copyWith(user: updatedUser);
      authController.updateSession(updatedSession);
    }

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
      context.go(RoutePaths.authSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepEmeraldBase, // Exact: #05241C
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // 1. Subtle Damask Wallpaper Pattern Overlay
          Opacity(
            opacity: 0.08,
            child: Image.asset(
              'assets/patterns/damask-pattern.jpg',
              fit: BoxFit.cover,
              repeat: ImageRepeat.repeat,
              color: AppColors.goldPrimary,
              colorBlendMode: BlendMode.screen,
              errorBuilder: (BuildContext ctx, Object error, StackTrace? st) {
                return const SizedBox.shrink();
              },
            ),
          ),

          // 2. Ambient Radial Glow
          Center(
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    AppColors.goldPrimary.withValues(alpha: 0.15),
                    const Color(0xFF0D4A3A).withValues(alpha: 0.20),
                    Colors.transparent,
                  ],
                  stops: const <double>[0.0, 0.45, 0.70],
                ),
              ),
            ),
          ),

          // 3. Main Form Container
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.space20,
                  vertical: AppSpacing.space20,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xD8041913),
                      borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                      border: Border.all(
                        color: AppColors.goldBorder,
                        width: 1.2,
                      ),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x73000000),
                          blurRadius: 36,
                          offset: Offset(0, 16),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.space24,
                      vertical: AppSpacing.space28,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // Swastik Jewel Logo
                          Center(
                            child: SvgPicture.asset(
                              'assets/icons/swastiklogo.svg',
                              width: 140,
                              fit: BoxFit.contain,
                              placeholderBuilder: (BuildContext context) {
                                return const Icon(
                                  Icons.diamond_outlined,
                                  size: 40,
                                  color: Color(0xFFCCA243),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Heading
                          Text(
                            'Complete Your Profile',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFF4E2AA),
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Subtitle
                          Text(
                            'Personalize your Kitty Vault passbook & legal bullion certificates',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF8FA499),
                              height: 1.45,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Field 1: Full Name
                          _buildFieldLabel('Full Name', isRequired: true),
                          const SizedBox(height: 6),
                          TextFormField(
                            key: const Key('input_profile_name'),
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: AppColors.goldPrimary,
                            decoration: _buildInputDecoration(
                              hintText: 'Enter your legal full name',
                              prefixIcon: Icons.person_outline_rounded,
                            ),
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

                          const SizedBox(height: 16),

                          // Field 2: Email Address
                          _buildFieldLabel('Email Address', isRequired: true),
                          const SizedBox(height: 6),
                          TextFormField(
                            key: const Key('input_profile_email'),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: AppColors.goldPrimary,
                            decoration: _buildInputDecoration(
                              hintText: 'e.g. patron@swastikjewel.com',
                              prefixIcon: Icons.email_outlined,
                            ),
                            validator: (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email address';
                              }
                              final RegExp emailRegex = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Field 3: City / Town (Optional)
                          _buildFieldLabel('City / Region', isRequired: false),
                          const SizedBox(height: 6),
                          TextFormField(
                            key: const Key('input_profile_city'),
                            controller: _cityController,
                            textCapitalization: TextCapitalization.words,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: AppColors.goldPrimary,
                            decoration: _buildInputDecoration(
                              hintText: 'e.g. Mumbai, Maharashtra',
                              prefixIcon: Icons.location_city_outlined,
                            ),
                          ),

                          const SizedBox(height: 26),

                          // Submit Action Button
                          _buildGoldButton(
                            text: 'Complete Profile & Enter Vault',
                            icon: Icons.arrow_forward_rounded,
                            isLoading: _isSubmitting,
                            onTap: _handleSubmit,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, {required bool isRequired}) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFE2D6BE),
          ),
        ),
        if (isRequired) ...<Widget>[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFFCCA243),
            ),
          ),
        ],
      ],
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.plusJakartaSans(
        fontSize: 13.5,
        color: const Color(0xFF637C71),
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: const Color(0xFFCCA243),
        size: 19,
      ),
      filled: true,
      fillColor: const Color(0xFF031A13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: const Color(0xFFCCA243).withValues(alpha: 0.35),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFCCA243),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFEF4444),
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xFFEF4444),
          width: 1.5,
        ),
      ),
      errorStyle: GoogleFonts.plusJakartaSans(
        fontSize: 11.5,
        color: const Color(0xFFEF4444),
      ),
    );
  }

  Widget _buildGoldButton({
    required String text,
    required IconData icon,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return Container(
      key: const Key('btn_profile_submit'),
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[
            Color(0xFFE8C87A),
            Color(0xFFCCA243),
            Color(0xFFB58E30),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x40CCA243),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05241C)),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            text,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF05241C),
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            icon,
                            size: 18,
                            color: const Color(0xFF05241C),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
