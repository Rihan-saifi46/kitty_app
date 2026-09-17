import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../providers/payment_state.dart';

/// Luxury payment processing and reconciliation polling view.
class PaymentProcessingView extends StatelessWidget {
  const PaymentProcessingView({
    super.key,
    required this.state,
  });

  final PaymentState state;

  @override
  Widget build(BuildContext context) {
    final String formattedAmount = CurrencyFormatter.formatRupees(state.amount);
    final String orderId = state.order?.orderId ?? 'gokwik_ord_771829';

    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.space16),
      decoration: BoxDecoration(
        color: const Color(0xFF05241C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.goldBorder.withValues(alpha: 0.35),
          width: 1.2,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 48,
            offset: Offset(0, 20),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.space28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Animated Gold Spinner with Shield
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.goldPrimary.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.goldBorder.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: const Center(
              child: SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.goldPrimary),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.space20),

          // Polling Step Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'RECONCILIATION STEP ${state.pollCount}/5',
              style: AppTypography.labelMeta(
                color: AppColors.goldLight,
              ).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.8),
            ),
          ),

          const SizedBox(height: AppSpacing.space12),

          // Dynamic Message
          Text(
            state.pollingMessage,
            key: const Key('payment_polling_message_text'),
            style: AppTypography.cardTitle(
              color: Colors.white,
            ).copyWith(fontSize: 17, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.space8),

          Text(
            'Securely confirming bank settlement with Swastik Gold Vault.',
            style: AppTypography.bodySmall(
              color: const Color(0xFF8EAA9E),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppSpacing.space20),

          // Details Box
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.space16,
              vertical: AppSpacing.space12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: AppRadius.border12,
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Amount',
                      style: AppTypography.labelMeta(color: const Color(0xFF8EAA9E)),
                    ),
                    Text(
                      formattedAmount,
                      style: AppTypography.labelMeta(color: const Color(0xFFFFE28A)).copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Order Ref',
                      style: AppTypography.labelMeta(color: const Color(0xFF8EAA9E)),
                    ),
                    Text(
                      orderId,
                      style: AppTypography.labelMeta(color: Colors.white70).copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.space16),

          // Safety Reassurance
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFF8EAA9E),
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                'Please do not close this window',
                style: AppTypography.labelMeta(
                  color: const Color(0xFF8EAA9E),
                ).copyWith(fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
