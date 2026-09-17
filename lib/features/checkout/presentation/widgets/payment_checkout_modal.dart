import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../providers/payment_state.dart';

/// Payment checkout modal card component matching approved UI design.
class PaymentCheckoutModal extends StatelessWidget {
  const PaymentCheckoutModal({
    super.key,
    required this.state,
    required this.onSelectMethod,
    required this.onConfirmPayment,
    required this.onClose,
  });

  final PaymentState state;
  final ValueChanged<PaymentMethodEnum> onSelectMethod;
  final VoidCallback onConfirmPayment;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final String formattedAmount = CurrencyFormatter.formatRupees(state.amount);

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
      padding: const EdgeInsets.all(AppSpacing.space24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Header Row with Title and Close Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Pay Kitty Installment',
                      key: const Key('checkout_modal_title'),
                      style: AppTypography.cardTitle(color: Colors.white).copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Month ${state.monthFor} Installment (${state.chitToken})',
                      key: const Key('checkout_modal_subtitle'),
                      style: AppTypography.labelMeta(
                        color: const Color(0xFF9EC0B4),
                      ).copyWith(fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('checkout_modal_close_btn'),
                icon: const Icon(Icons.close_rounded, color: Color(0xFFFAF8F2), size: 20),
                onPressed: state.isBusy ? null : onClose,
                splashRadius: 20,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.space16),

          // Payment Summary Box
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.space14,
              horizontal: AppSpacing.space16,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: AppRadius.border14,
              border: Border.all(
                color: const Color(0xFFC99A2E).withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'EMI AMOUNT DUE',
                  style: AppTypography.labelMeta(
                    color: const Color(0xFF8EAA9E),
                  ).copyWith(letterSpacing: 1.1, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedAmount,
                  key: const Key('checkout_modal_amount_text'),
                  style: AppTypography.amountDisplay(
                    color: const Color(0xFFFFE28A),
                  ).copyWith(fontSize: 28),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.space16),

          // Payment Methods Header
          Text(
            'SELECT PAYMENT METHOD',
            style: AppTypography.labelMeta(
              color: const Color(0xFF8EAA9E),
            ).copyWith(letterSpacing: 1.0, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: AppSpacing.space10),

          // Method 1: Instant UPI
          _buildMethodItem(
            key: const Key('checkout_method_upi'),
            icon: Icons.bolt_rounded,
            iconColor: const Color(0xFFFFD700),
            title: 'Instant UPI (GPay / PhonePe / Paytm)',
            subtitle: 'Instant zero-fee gold allocation',
            isSelected: state.selectedMethod == PaymentMethodEnum.online,
            onTap: () => onSelectMethod(PaymentMethodEnum.online),
          ),

          const SizedBox(height: AppSpacing.space10),

          // Method 2: Net Banking
          _buildMethodItem(
            key: const Key('checkout_method_netbanking'),
            icon: Icons.account_balance_rounded,
            iconColor: const Color(0xFF6EE7B7),
            title: 'Net Banking',
            subtitle: 'HDFC, ICICI, SBI & 40+ banks',
            isSelected: false,
            onTap: () => onSelectMethod(PaymentMethodEnum.online),
          ),

          const SizedBox(height: AppSpacing.space10),

          // Method 3: Debit / Credit Card
          _buildMethodItem(
            key: const Key('checkout_method_card'),
            icon: Icons.credit_card_rounded,
            iconColor: const Color(0xFF93C5FD),
            title: 'Debit / Credit Card',
            subtitle: 'Visa, Mastercard, RuPay',
            isSelected: false,
            onTap: () => onSelectMethod(PaymentMethodEnum.online),
          ),

          const SizedBox(height: AppSpacing.space20),

          // Error Message Display if any
          if (state.errorMessage != null && !state.isBusy)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.space12),
              child: Text(
                state.errorMessage!,
                key: const Key('checkout_modal_error_text'),
                style: AppTypography.labelMeta(
                  color: const Color(0xFFF87171),
                ).copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),

          // Confirm & Pay CTA Button
          ElevatedButton(
            key: const Key('btn_confirm_payment'),
            onPressed: state.isBusy ? null : onConfirmPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFECC97D),
              foregroundColor: const Color(0xFF05241C),
              disabledBackgroundColor: const Color(0xFFECC97D).withValues(alpha: 0.5),
              disabledForegroundColor: const Color(0xFF05241C).withValues(alpha: 0.7),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.space14),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.border12,
              ),
              elevation: 4,
            ),
            child: state.isInitiating
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05241C)),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.space10),
                      Text(
                        'Processing Secure UPI Payment...',
                        style: AppTypography.bodyBold(
                          color: const Color(0xFF05241C),
                        ).copyWith(fontSize: 14, fontWeight: FontWeight.w800),
                      ),
                    ],
                  )
                : Text(
                    'Confirm & Pay $formattedAmount',
                    style: AppTypography.bodyBold(
                      color: const Color(0xFF05241C),
                    ).copyWith(fontSize: 14.5, fontWeight: FontWeight.w800),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodItem({
    required Key key,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      key: key,
      onTap: state.isBusy ? null : onTap,
      borderRadius: AppRadius.border12,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space14,
          vertical: AppSpacing.space12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFC99A2E).withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: AppRadius.border12,
          border: Border.all(
            color: isSelected
                ? AppColors.goldPrimary
                : Colors.white.withValues(alpha: 0.1),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: AppSpacing.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: AppTypography.bodyBold(
                      color: Colors.white,
                    ).copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.labelMeta(
                      color: const Color(0xFF8EAA9E),
                    ).copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.goldPrimary
                      : Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.goldPrimary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
