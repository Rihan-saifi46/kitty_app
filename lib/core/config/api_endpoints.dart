/// Canonical REST URI endpoints for Kitty App adhering to Frozen Backend Contract v1.0.
abstract final class ApiEndpoints {
  // Base path
  static const String apiVersion = '/api/v1';

  // ---------------------------------------------------------------------------
  // Authentication (/api/v1/auth/*)
  // ---------------------------------------------------------------------------

  /// Request OTP for mobile login.
  static const String authSendOtp = '$apiVersion/auth/send-otp';

  /// Verify 6-digit OTP and obtain 30-day JWT.
  static const String authVerifyOtp = '$apiVersion/auth/verify-otp';

  /// Resend OTP after 30-second countdown.
  static const String authResendOtp = '$apiVersion/auth/resend-otp';

  /// Fetch authenticated user profile.
  static const String authMe = '$apiVersion/auth/me';

  /// Invalidate server session.
  static const String authLogout = '$apiVersion/auth/logout';

  // ---------------------------------------------------------------------------
  // KYC Compliance (/api/v1/kyc/*)
  // ---------------------------------------------------------------------------

  /// Upload statutory KYC identity document (Aadhaar/PAN).
  static const String kycUpload = '$apiVersion/kyc/upload';

  /// Query KYC document verification status.
  static const String kycStatus = '$apiVersion/kyc/status';

  // ---------------------------------------------------------------------------
  // Home & Catalog Discovery (/api/v1/*)
  // ---------------------------------------------------------------------------

  /// Live gold rate ticker (24K & 22K per gram).
  static const String ratesLive = '$apiVersion/rates/live';

  /// Active promo banner carousel cards.
  static const String homePromos = '$apiVersion/home/promos';

  /// Curated featured jewelry showcase catalog.
  static const String catalogFeatured = '$apiVersion/catalog/featured';

  // ---------------------------------------------------------------------------
  // Memberships & Dashboard (/api/v1/memberships/*)
  // ---------------------------------------------------------------------------

  /// User active scheme hero, next EMI due, and 2x2 stats grid.
  static const String membershipsDashboard = '$apiVersion/memberships/my-dashboard';

  /// 12-month passbook ledger and payment status nodes.
  static String membershipPassbook(String membershipId) =>
      '$apiVersion/memberships/$membershipId/passbook';

  /// Available scheme catalog and filter tiers.
  static const String schemesCatalog = '$apiVersion/schemes/catalog';

  /// Enroll in a new chit scheme plan.
  static const String schemeEnroll = '$apiVersion/memberships/enroll';

  // ---------------------------------------------------------------------------
  // Payments & Checkout (/api/v1/payments/*)
  // ---------------------------------------------------------------------------

  /// Initialize GoKwik payment order.
  static const String paymentsInitiateGokwik = '$apiVersion/payments/initiate-gokwik';

  /// Poll GoKwik payment transaction status by order ID.
  static String paymentsStatus(String orderId) => '$apiVersion/payments/status/$orderId';

  // ---------------------------------------------------------------------------
  // Digital Receipts & User Profile (/api/v1/*)
  // ---------------------------------------------------------------------------

  /// Download monthly digital payment receipt PDF.
  static String receiptDownloadPdf(String receiptId) => '$apiVersion/receipts/$receiptId/pdf';

  /// User profile details and preferences.
  static const String userProfile = '$apiVersion/users/profile';

  /// In-app notification center feed.
  static const String notifications = '$apiVersion/notifications';
}
