/// Centralized URI route path definitions for Kitty App.
///
/// Strictly matches the routes formalised in NAVIGATION.md and FRONTEND_IMPLEMENTATION_PLAN.md.
abstract final class RoutePaths {
  // ---------------------------------------------------------------------------
  // Public & Authentication Branch
  // ---------------------------------------------------------------------------

  /// Initial splash entry screen with 3D diamond animation and session check.
  static const String splash = '/splash';

  /// Primary login screen (Choice between Mobile Number and Google SSO).
  static const String login = '/auth/login';

  /// Mobile phone number entry view.
  static const String phone = '/auth/phone';

  /// 6-digit OTP verification view.
  static const String otp = '/auth/otp';

  /// Profile information registration screen (after phone/OTP verification).
  static const String profile = '/auth/profile';

  /// Authentication confirmation screen.
  static const String authSuccess = '/auth/success';

  // ---------------------------------------------------------------------------
  // Protected Application Shell Tabs (StatefulShellRoute)
  // ---------------------------------------------------------------------------

  /// Tab 1: Home Screen (Brand showcase, promo carousel, category pills).
  static const String home = '/home';

  /// Tab: Coin Rates Screen (1gm to 10gm gold coin prices, bulk coin booking).
  static const String coinRates = '/coin-rates';

  /// Tab: Jewellery Screen (Gold & Diamond jewellery dropdowns & categories).
  static const String jewellery = '/jewellery';

  /// Tab: Gold Valuation Calculator Screen (Shop by Gram & Shop by Money).
  static const String calculator = '/calculator';

  /// Tab: Menu Screen (Patron profile, drawer links, concierge, logout).
  static const String menu = '/menu';

  /// Tab: Active Kitty Scheme Dashboard (Hero card, circular gauge, stats).
  static const String dashboard = '/dashboard';

  /// Tab: Passbook Screen (12-month installment timeline table / cards).
  static const String passbook = '/passbook';

  /// Tab: Offers Screen (Curated savings schemes, plan enrollment).
  static const String offers = '/offers';

  /// Tab: Settings Screen (Security, MPIN, Biometrics, Nominee, Logout).
  static const String settings = '/settings';

  // ---------------------------------------------------------------------------
  // Protected Stack & Modal Routes
  // ---------------------------------------------------------------------------

  /// Notifications center screen.
  static const String notifications = '/notifications';

  /// KYC identity verification screen (Aadhaar / PAN upload).
  static const String kyc = '/kyc';

  /// Payment checkout bottom sheet / modal.
  static const String checkout = '/checkout';

  /// Digital tax receipt modal / screen. Parameterized by receipt ID.
  static const String receipt = '/receipt/:id';

  /// Helper to generate parameterized receipt URI.
  static String receiptWithId(String id) => '/receipt/$id';

  /// Third-party payment gateway isolated WebView host.
  static const String gokwikGateway = '/gokwik-gateway';
}
