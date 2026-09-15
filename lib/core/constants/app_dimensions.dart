import 'package:flutter/material.dart';

/// Centralized UI dimensions and constraints for Kitty App.
abstract final class AppDimensions {
  /// Maximum width of phone container viewport (440px).
  static const double maxContainerWidth = 440.0;

  /// Maximum width for wide views like Offers and Settings (480px).
  static const double maxWideContainerWidth = 480.0;

  /// Standard primary button height (50px).
  static const double primaryButtonHeight = 50.0;

  /// Compact button height (40px).
  static const double compactButtonHeight = 40.0;

  /// Input text field height (50px).
  static const double inputFieldHeight = 50.0;

  /// OTP single digit input box width (44px).
  static const double otpBoxWidth = 44.0;

  /// OTP single digit input box height (50px).
  static const double otpBoxHeight = 50.0;

  /// Header navigation bar height (56px).
  static const double headerBarHeight = 56.0;

  /// Gold live rate ticker height (36px).
  static const double goldTickerHeight = 36.0;

  /// Bottom navigation bar height (64px).
  static const double bottomNavHeight = 64.0;

  /// Small icon size (16px).
  static const double iconSm = 16.0;

  /// Medium icon size (24px).
  static const double iconMd = 24.0;

  /// Large icon size (32px).
  static const double iconLg = 32.0;

  /// Circular user avatar size (44px).
  static const double avatarSize = 44.0;

  /// Header drawer toggle icon diameter (40px).
  static const double headerActionDiameter = 40.0;
}

/// Centralized luxury shadows and ambient glows for Kitty App.
abstract final class AppShadows {
  /// Subtle card shadow for settings and light cards: 0 2px 8px rgba(0, 0, 0, 0.03)
  static const List<BoxShadow> cardSubtle = <BoxShadow>[
    BoxShadow(
      color: Color(0x08000000),
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  /// Elevated product card shadow: 0 6px 18px rgba(12, 43, 36, 0.04)
  static const List<BoxShadow> cardElevated = <BoxShadow>[
    BoxShadow(
      color: Color(0x0A0C2B24),
      offset: Offset(0, 6),
      blurRadius: 18,
    ),
  ];

  /// Luxury active emerald scheme card shadow: 0 14px 34px rgba(11, 48, 38, 0.22)
  static const List<BoxShadow> cardLuxury = <BoxShadow>[
    BoxShadow(
      color: Color(0x380B3026),
      offset: Offset(0, 14),
      blurRadius: 34,
    ),
  ];

  /// Primary gold action button glow: 0 4px 16px rgba(197, 155, 39, 0.35)
  static const List<BoxShadow> ctaGold = <BoxShadow>[
    BoxShadow(
      color: Color(0x59C59B27),
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
  ];

  /// Input focus gold glow
  static const List<BoxShadow> inputFocusGold = <BoxShadow>[
    BoxShadow(
      color: Color(0x33C59B27),
      offset: Offset(0, 0),
      blurRadius: 6,
      spreadRadius: 1,
    ),
  ];
}

/// Centralized animation durations for Kitty App.
abstract final class AppDurations {
  /// 150ms - Fast micro-interactions, button presses
  static const Duration fast = Duration(milliseconds: 150);

  /// 300ms - Standard screen transitions, drawer slides, modal open
  static const Duration normal = Duration(milliseconds: 300);

  /// 500ms - Slow fade-ins, gold gauge fill animation
  static const Duration slow = Duration(milliseconds: 500);

  /// 2500ms - Splash 3D faceted diamond loader animation cycle
  static const Duration splashAnimation = Duration(milliseconds: 2500);

  /// 15000ms - HTTP network timeout (15s)
  static const Duration networkTimeout = Duration(milliseconds: 15000);
}
