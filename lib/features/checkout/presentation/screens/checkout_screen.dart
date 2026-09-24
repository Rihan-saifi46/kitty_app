import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/enums/app_enums.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../dashboard/presentation/providers/dashboard_controller.dart';
import '../providers/payment_controller.dart';
import '../providers/payment_state.dart';
import '../widgets/payment_checkout_modal.dart';
import '../widgets/payment_processing_view.dart';
import '../widgets/payment_result_view.dart';
import '../widgets/pick_cash_sheet.dart';

/// Arguments optionally passed to `/checkout` route.
class CheckoutArgs {
  const CheckoutArgs({
    required this.membershipId,
    required this.chitToken,
    required this.monthFor,
    required this.amount,
  });

  final String membershipId;
  final String chitToken;
  final int monthFor;
  final int amount;
}

/// Full Payment Checkout Screen for Phase 11.
///
/// Houses the luxury slide-up checkout modal, GoKwik initiation,
/// live bank status reconciliation polling, and authoritative outcome presentation.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({
    super.key,
    this.args,
  });

  final CheckoutArgs? args;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.args != null) {
        ref.read(paymentControllerProvider.notifier).setInstallmentContext(
              membershipId: widget.args!.membershipId,
              chitToken: widget.args!.chitToken,
              monthFor: widget.args!.monthFor,
              amount: widget.args!.amount,
            );
      } else {
        try {
          final dashboard = ref.read(dashboardControllerProvider);
          if (dashboard.isLoaded && dashboard.data != null) {
            final data = dashboard.data!;
            final next = data.nextInstallment;
            final int month = next?.month ?? ((data.monthsPaid ?? 8) + 1);
            final int amount = next?.amount ?? (data.customMonthlyEmi ?? 5000);
            ref.read(paymentControllerProvider.notifier).setInstallmentContext(
                  membershipId: data.membershipId ?? 'mem_994411',
                  chitToken: data.chitToken ?? '#SW-042',
                  monthFor: month,
                  amount: amount,
                );
          }
        } catch (_) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PaymentState paymentState = ref.watch(paymentControllerProvider);
    final PaymentController controller = ref.read(paymentControllerProvider.notifier);

    return PopScope(
      canPop: !paymentState.isBusy,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        if (paymentState.isPolling) {
          final bool? shouldLeave = await showDialog<bool>(
            context: context,
            builder: (BuildContext ctx) => AlertDialog(
              backgroundColor: const Color(0xFF0C2B22),
              title: const Text('Reconciliation In Progress', style: TextStyle(color: Colors.white)),
              content: const Text(
                'Your payment is currently being verified with the bank. If you leave, verification will continue in the background and your passbook will update upon completion.',
                style: TextStyle(color: Color(0xFF9EC0B4)),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Stay', style: TextStyle(color: AppColors.goldLight)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Leave', style: TextStyle(color: Colors.white60)),
                ),
              ],
            ),
          );
          if (shouldLeave == true && context.mounted) {
            context.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xCC05241C), // 80% opacity dark emerald overlay
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.space24),
              child: _buildCurrentStepView(context, paymentState, controller),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStepView(
    BuildContext context,
    PaymentState state,
    PaymentController controller,
  ) {
    // 1. Terminal Results (Success, Failed, Cancelled, Timeout, Error)
    if (state.isTerminal || state.isError) {
      return PaymentResultView(
        state: state,
        onRetry: () => controller.retry(context),
        onViewPassbook: () => context.go(RoutePaths.passbook),
        onReturnToDashboard: () => context.go(RoutePaths.dashboard),
        onClose: () {
          controller.reset();
          context.pop();
        },
      );
    }

    // 2. Active Polling View
    if (state.isPolling) {
      return PaymentProcessingView(state: state);
    }

    // 3. Initial / Initiating Modal View
    return PaymentCheckoutModal(
      state: state,
      onSelectChannel: (PaymentChannel channel) => controller.selectPaymentChannel(channel),
      onSelectMethod: (PaymentMethodEnum method) => controller.selectPaymentMethod(method),
      onConfirmPayment: () => controller.initiateAndPay(context),
      onProceedPickCash: () => PickCashSheet.show(
        context,
        paymentState: state,
        onPickupScheduled: (CashPickupRequest req) {
          // Future backend submission: POST /api/v1/payments/cash-pickup
        },
      ),
      onClose: () => context.pop(),
    );
  }
}
