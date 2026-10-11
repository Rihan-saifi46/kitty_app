import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_constants.dart';
import '../../../../core/routing/route_paths.dart';

/// Destination / Launch Choice Screen.
///
/// Displayed on EVERY application launch (for authenticated patrons)
/// and immediately following successful registration / statutory KYC.
///
/// Layout:
/// - Scaffold Background: Warm Pearl / Light Parchment (#FAF7F2 - Gold Plans baseline)
/// - Top Heading ONLY: "Welcome to Swastik Jewels" (Playfair Display 28px bold #0A221C)
/// - 3 Luxury Destination Cards matching the approved visual structure:
///   1. "Shop Gold" -> Enters internal Kitty App Gold Plans (/offers)
///   2. "View on Instagram" -> Official Swastik Jewels Instagram external link
///   3. "Shop Jewellery" -> Official Swastik Jewels jewellery website catalog external link
class OnboardingChoiceScreen extends ConsumerWidget {
  const OnboardingChoiceScreen({super.key});

  static const String _officialInstagramUrl =
      'https://www.instagram.com/swastikjewellers_official/';
  static const String _fallbackInstagramUrl =
      'https://instagram.com/swastikjewel';

  Future<void> _launchInstagram(BuildContext context) async {
    await HapticFeedback.lightImpact();
    final Uri primaryUri = Uri.parse(_officialInstagramUrl);
    final Uri fallbackUri = Uri.parse(_fallbackInstagramUrl);

    try {
      final bool launched = await launchUrl(
        primaryUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      try {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open Instagram profile.'),
              backgroundColor: Color(0xFF063B2C),
            ),
          );
        }
      }
    }
  }

  void _navigateToShopGold(BuildContext context) {
    HapticFeedback.lightImpact();
    context.go(RoutePaths.offers);
  }

  Future<void> _launchShopJewellery(BuildContext context) async {
    await HapticFeedback.lightImpact();
    final Uri websiteUri = Uri.parse(AppConstants.jewelleryCatalogUrl);
    try {
      final bool launched = await launchUrl(
        websiteUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open Swastik Jewellers website.'),
            backgroundColor: Color(0xFF063B2C),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open Swastik Jewellers website.'),
            backgroundColor: Color(0xFF063B2C),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        // On hardware back press, default to entering the Gold experience
        _navigateToShopGold(context);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF7F2), // Exact Gold Plans Background
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 12),

                    // Top Main Heading
                    Center(
                      child: Text(
                        'Welcome to Swastik Jewels',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0A221C),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Destination 1: View Gold Schemes
                    _buildDestinationCard(
                      iconPath: 'assets/icons/gold-plans.svg',
                      title: 'View Gold Schemes',
                      description:
                          'Explore gold savings schemes, lock in live rates & grow wealth.',
                      onTap: () => _navigateToShopGold(context),
                    ),

                    const SizedBox(height: 16),

                    // Destination 2: Shop Jewellery
                    _buildDestinationCard(
                      iconPath: 'assets/icons/explore-jewellery.svg',
                      title: 'Shop Jewellery',
                      description:
                          'Browse handcrafted bridal, gold & diamond jewellery collections.',
                      onTap: () => _launchShopJewellery(context),
                    ),

                    const SizedBox(height: 16),

                    // Destination 3: View Our Instagram
                    _buildDestinationCard(
                      iconPath: 'assets/icons/instagram.svg',
                      title: 'View Our Instagram',
                      description:
                          'Follow our daily jewellery showcases, stories & latest designs.',
                      onTap: () => _launchInstagram(context),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Destination Card:
  /// - Icon placed at the top center of each card
  /// - Heading below the icon, centered
  /// - Description below the heading, centered
  Widget _buildDestinationCard({
    required String iconPath,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFEFE6DB)),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 14,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF2E5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFEFE2CF)),
                    ),
                    padding: const EdgeInsets.all(13),
                    child: SvgPicture.asset(
                      iconPath,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF9A7342),
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0A221C),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF55605B),
                    height: 1.45,
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
