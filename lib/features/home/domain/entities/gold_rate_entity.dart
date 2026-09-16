/// Pure domain entity representing live bullion gold ticker rates.
///
/// Preserves exact 3-decimal precision according to backend contract.
class LiveGoldRateEntity {
  const LiveGoldRateEntity({
    required this.ratePerGram, // 3-decimal precision (e.g. 7120.500)
    required this.purity, // e.g. "24K (999)"
    required this.purityFraction, // 0.999
    required this.currency,
    required this.change24h, // e.g. +45.250
    required this.changePct, // e.g. +0.64
    required this.isUp,
    required this.updatedAt,
  });

  final double ratePerGram;
  final String purity;
  final double purityFraction;
  final String currency;
  final double change24h;
  final double changePct;
  final bool isUp;
  final DateTime updatedAt;
}
