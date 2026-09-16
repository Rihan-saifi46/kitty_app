/// Centralized route names for GoRouter named navigation.
///
/// Matches the master navigation hierarchy from NAVIGATION.md.
enum AppRoute {
  // Public
  splash('splash'),
  login('login'),
  phone('phone'),
  otp('otp'),
  authSuccess('authSuccess'),

  // Shell Tabs
  home('home'),
  dashboard('dashboard'),
  passbook('passbook'),
  offers('offers'),
  settings('settings'),

  // Supporting / Stack Routes
  notifications('notifications'),
  kyc('kyc'),
  checkout('checkout'),
  receipt('receipt'),
  gokwikGateway('gokwikGateway'),

  // Fallback
  notFound('notFound');

  const AppRoute(this.name);

  /// String identifier matching GoRoute.name.
  final String name;
}
