/// Live Gold Rate Data Transfer Object.
class LiveGoldRateDto {
  const LiveGoldRateDto({
    required this.ratePerGram,
    required this.purity,
    required this.purityFraction,
    required this.currency,
    required this.change24h,
    required this.changePct,
    required this.isUp,
    required this.updatedAt,
  });

  factory LiveGoldRateDto.fromJson(Map<String, dynamic> json) {
    return LiveGoldRateDto(
      ratePerGram: (json['ratePerGram'] as num?)?.toDouble() ?? 0.0,
      purity: json['purity'] as String? ?? '24K (999)',
      purityFraction: (json['purityFraction'] as num?)?.toDouble() ?? 0.999,
      currency: json['currency'] as String? ?? 'INR',
      change24h: (json['change24h'] as num?)?.toDouble() ?? 0.0,
      changePct: (json['changePct'] as num?)?.toDouble() ?? 0.0,
      isUp: json['isUp'] as bool? ?? true,
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  final double ratePerGram;
  final String purity;
  final double purityFraction;
  final String currency;
  final double change24h;
  final double changePct;
  final bool isUp;
  final String updatedAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ratePerGram': ratePerGram,
        'purity': purity,
        'purityFraction': purityFraction,
        'currency': currency,
        'change24h': change24h,
        'changePct': changePct,
        'isUp': isUp,
        'updatedAt': updatedAt,
      };
}
