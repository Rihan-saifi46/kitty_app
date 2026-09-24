import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/providers/auth_state_provider.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../providers/payment_state.dart';

/// Clean frontend data model representing the future backend submission contract.
///
/// Sent to future endpoint: POST /api/v1/payments/cash-pickup
class CashPickupRequest {
  const CashPickupRequest({
    required this.requestId,
    required this.membershipId,
    required this.chitToken,
    required this.monthFor,
    required this.amount,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.pickupAddress,
    required this.city,
    required this.pincode,
    required this.preferredSlot,
    this.additionalNotes,
    required this.createdAt,
  });

  final String requestId;
  final String membershipId;
  final String chitToken;
  final int monthFor;
  final int amount;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String pickupAddress;
  final String city;
  final String pincode;
  final String preferredSlot;
  final String? additionalNotes;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'request_id': requestId,
        'membership_id': membershipId,
        'chit_token': chitToken,
        'month_for': monthFor,
        'amount': amount,
        'customer': <String, dynamic>{
          'name': customerName,
          'phone': customerPhone,
          'email': customerEmail,
        },
        'pickup_location': <String, dynamic>{
          'address': pickupAddress,
          'city': city,
          'pincode': pincode,
        },
        'schedule': <String, dynamic>{
          'preferred_slot': preferredSlot,
          'notes': additionalNotes,
        },
        'created_at': createdAt.toIso8601String(),
      };
}

/// Dedicated luxury bottom sheet/modal for scheduling doorstep cash pickup.
///
/// Satisfies Change 12: captures necessary pickup logistics with profile prefill,
/// inline validation, loading submission, and confirmed reference state.
class PickCashSheet extends ConsumerStatefulWidget {
  const PickCashSheet({
    super.key,
    required this.paymentState,
    required this.onClose,
    this.onPickupScheduled,
  });

  final PaymentState paymentState;
  final VoidCallback onClose;
  final ValueChanged<CashPickupRequest>? onPickupScheduled;

  static Future<void> show(
    BuildContext context, {
    required PaymentState paymentState,
    ValueChanged<CashPickupRequest>? onPickupScheduled,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) => PickCashSheet(
        paymentState: paymentState,
        onClose: () => Navigator.of(ctx).pop(),
        onPickupScheduled: onPickupScheduled,
      ),
    );
  }

  @override
  ConsumerState<PickCashSheet> createState() => _PickCashSheetState();
}

class _PickCashSheetState extends ConsumerState<PickCashSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _notesController;

  final List<String> _slots = const <String>[
    'Today Evening (4 PM - 7 PM)',
    'Tomorrow Morning (10 AM - 1 PM)',
    'Tomorrow Evening (4 PM - 7 PM)',
  ];

  late String _selectedSlot;
  bool _isSubmitting = false;
  bool _isSuccess = false;
  String? _errorMessage;
  CashPickupRequest? _completedRequest;
  String _generatedOtp = '4821';

  @override
  void initState() {
    super.initState();
    _selectedSlot = _slots.first;

    final AppAuthState auth = ref.read(appAuthStateProvider);
    _nameController = TextEditingController(text: auth.userName.isNotEmpty ? auth.userName : 'Rihan Saifi');
    _phoneController = TextEditingController(text: auth.userPhone.isNotEmpty ? auth.userPhone : '+91 98765 43210');
    _emailController = TextEditingController(text: 'rihan.saifi@swastikgold.in');
    _addressController = TextEditingController();
    _cityController = TextEditingController(text: 'New Delhi');
    _pincodeController = TextEditingController(text: '110001');
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    // Simulate brief network submission to prepare frontend contract
    await Future<void>.delayed(const Duration(milliseconds: 650));

    if (!mounted) return;

    final int randRef = 100000 + math.Random().nextInt(899999);
    final int randOtp = 1000 + math.Random().nextInt(8999);
    final String reqId = 'PCK-$randRef';

    final CashPickupRequest request = CashPickupRequest(
      requestId: reqId,
      membershipId: widget.paymentState.membershipId,
      chitToken: widget.paymentState.chitToken,
      monthFor: widget.paymentState.monthFor,
      amount: widget.paymentState.amount,
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      customerEmail: _emailController.text.trim(),
      pickupAddress: _addressController.text.trim(),
      city: _cityController.text.trim(),
      pincode: _pincodeController.text.trim(),
      preferredSlot: _selectedSlot,
      additionalNotes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
      createdAt: DateTime.now(),
    );

    setState(() {
      _isSubmitting = false;
      _isSuccess = true;
      _completedRequest = request;
      _generatedOtp = randOtp.toString();
    });

    widget.onPickupScheduled?.call(request);
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;
    final String formattedAmount = CurrencyFormatter.formatRupees(widget.paymentState.amount);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.90,
      ),
      margin: EdgeInsets.only(
        bottom: keyboardPadding,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF05241C), // Deep Emerald Base
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(color: Color(0xFFC99A2E), width: 1.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space20,
            vertical: AppSpacing.space16,
          ),
          child: _isSuccess
              ? _buildSuccessView(context, formattedAmount)
              : _buildFormView(context, formattedAmount),
        ),
      ),
    );
  }

  Widget _buildFormView(BuildContext context, String formattedAmount) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Drag Handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.space14),

          // Header
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.goldPrimary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.goldPrimary.withValues(alpha: 0.4),
                  ),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  color: AppColors.goldPrimary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Doorstep Cash Pickup',
                      key: const Key('pick_cash_sheet_title'),
                      style: AppTypography.cardTitle(color: Colors.white).copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Authorized Swastik executive collects at your doorstep',
                      style: AppTypography.labelMeta(
                        color: const Color(0xFF9EC0B4),
                      ).copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: const Key('pick_cash_close_btn'),
                icon: const Icon(Icons.close_rounded, color: Colors.white70),
                onPressed: _isSubmitting ? null : widget.onClose,
                splashRadius: 20,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.space14),

          // Scheme & Amount Summary Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: AppRadius.border12,
              border: Border.all(
                color: AppColors.goldBorder.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'ACTIVE SCHEME',
                      style: AppTypography.labelMeta(
                        color: const Color(0xFF8EAA9E),
                      ).copyWith(letterSpacing: 0.8, fontSize: 10.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Month ${widget.paymentState.monthFor} (${widget.paymentState.chitToken})',
                      style: AppTypography.bodyBold(color: Colors.white).copyWith(fontSize: 13),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'CASH AMOUNT',
                      style: AppTypography.labelMeta(
                        color: const Color(0xFF8EAA9E),
                      ).copyWith(letterSpacing: 0.8, fontSize: 10.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formattedAmount,
                      key: const Key('pick_cash_amount_text'),
                      style: AppTypography.amountDisplay(
                        color: const Color(0xFFFFE28A),
                      ).copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.space16),

          // Section 1: Patron Details (Prefilled from auth)
          _buildFieldLabel('Patron Name'),
          TextFormField(
            key: const Key('pick_cash_input_name'),
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration('Full Name', Icons.person_outline_rounded),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.space12),

          Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildFieldLabel('Contact Phone'),
                    TextFormField(
                      key: const Key('pick_cash_input_phone'),
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: _inputDecoration('+91 Phone', Icons.phone_outlined),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        if (value.replaceAll(RegExp(r'\D'), '').length < 10) {
                          return '10 digits min';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildFieldLabel('Email Address'),
                    TextFormField(
                      key: const Key('pick_cash_input_email'),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: _inputDecoration('Email', Icons.mail_outline_rounded),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.space12),

          // Section 2: Address & Pincode
          _buildFieldLabel('Pickup Address / Doorstep Location'),
          TextFormField(
            key: const Key('pick_cash_input_address'),
            controller: _addressController,
            maxLines: 2,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: _inputDecoration('House/Flat No., Street, Landmark', Icons.home_outlined),
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please provide complete doorstep address for verification';
              }
              if (value.trim().length < 8) {
                return 'Address is too brief (minimum 8 characters)';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.space12),

          Row(
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildFieldLabel('City'),
                    TextFormField(
                      key: const Key('pick_cash_input_city'),
                      controller: _cityController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: _inputDecoration('City', Icons.location_city_outlined),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) return 'City required';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.space12),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildFieldLabel('Pincode'),
                    TextFormField(
                      key: const Key('pick_cash_input_pincode'),
                      controller: _pincodeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: _inputDecoration('6 Digits', Icons.pin_drop_outlined).copyWith(
                        counterText: '',
                      ),
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) return 'Required';
                        if (value.trim().length != 6) return '6 digits';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.space14),

          // Section 3: Preferred Slot Chips
          _buildFieldLabel('Select Preferred Pickup Slot'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _slots.map((String slot) {
              final bool isSelected = _selectedSlot == slot;
              return ChoiceChip(
                label: Text(
                  slot,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF05241C) : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color(0xFFECC97D),
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                side: BorderSide(
                  color: isSelected ? AppColors.goldPrimary : Colors.white12,
                ),
                onSelected: (bool selected) {
                  if (selected) {
                    setState(() => _selectedSlot = slot);
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.space12),

          // Section 4: Special Instructions
          _buildFieldLabel('Special Instructions (Optional)'),
          TextFormField(
            key: const Key('pick_cash_input_notes'),
            controller: _notesController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: _inputDecoration('e.g. Call before arrival, leave with security', Icons.note_alt_outlined),
          ),

          const SizedBox(height: AppSpacing.space14),

          // Statutory Compliance Notice
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.goldPrimary.withValues(alpha: 0.08),
              borderRadius: AppRadius.border8,
              border: Border.all(
                color: AppColors.goldPrimary.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(Icons.verified_user_outlined, color: AppColors.goldLight, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Swastik Field Executive will carry official digital ID. A secure 4-digit verification OTP will be issued upon booking.',
                    style: AppTypography.labelMeta(color: const Color(0xFFC7D9D1)).copyWith(
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_errorMessage != null) ...<Widget>[
            const SizedBox(height: AppSpacing.space10),
            Text(
              _errorMessage!,
              key: const Key('pick_cash_error_text'),
              style: const TextStyle(color: Color(0xFFF87171), fontSize: 12.5),
              textAlign: TextAlign.center,
            ),
          ],

          const SizedBox(height: AppSpacing.space16),

          // Actions
          ElevatedButton(
            key: const Key('btn_submit_pick_cash'),
            onPressed: _isSubmitting ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFECC97D),
              foregroundColor: const Color(0xFF05241C),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.space14),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.border12,
              ),
              elevation: 4,
            ),
            child: _isSubmitting
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF05241C)),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Scheduling Doorstep Pickup...',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  )
                : const Text(
                    'Confirm Cash Pickup Request',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5),
                  ),
          ),
          const SizedBox(height: AppSpacing.space8),
          TextButton(
            key: const Key('btn_cancel_pick_cash'),
            onPressed: _isSubmitting ? null : widget.onClose,
            child: const Text(
              'Cancel / Back to Payment Methods',
              style: TextStyle(color: Color(0xFF9EC0B4), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, String formattedAmount) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppSpacing.space16),
        Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              border: Border.all(color: const Color(0xFF10B981), width: 2),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: Color(0xFF10B981),
              size: 38,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.space16),
        Text(
          'Doorstep Pickup Scheduled!',
          key: const Key('pick_cash_success_title'),
          textAlign: TextAlign.center,
          style: AppTypography.cardTitle(color: Colors.white).copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Reference ID: ${_completedRequest?.requestId ?? "PCK-849201"}',
          key: const Key('pick_cash_ref_id'),
          textAlign: TextAlign.center,
          style: AppTypography.labelMeta(color: const Color(0xFFFFD700)).copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 13.5,
          ),
        ),
        const SizedBox(height: AppSpacing.space16),

        // Verification OTP Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: AppRadius.border14,
            border: Border.all(
              color: AppColors.goldBorder.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            children: <Widget>[
              Text(
                'HANDOVER VERIFICATION OTP',
                style: AppTypography.labelMeta(color: const Color(0xFF8EAA9E)).copyWith(
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _generatedOtp,
                key: const Key('pick_cash_otp_text'),
                style: const TextStyle(
                  fontFamily: 'Cinzel',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFFFE28A),
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Only share this 4-digit OTP with the Swastik Field Executive once cash is physically collected and counted.',
                textAlign: TextAlign.center,
                style: AppTypography.labelMeta(color: const Color(0xFFC7D9D1)).copyWith(
                  fontSize: 11.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.space14),

        // Pickup Summary Details
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            borderRadius: AppRadius.border12,
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            children: <Widget>[
              _buildSummaryRow('Amount Due', formattedAmount),
              const Divider(color: Colors.white12, height: 16),
              _buildSummaryRow('Patron', _nameController.text),
              const Divider(color: Colors.white12, height: 16),
              _buildSummaryRow('Pickup Slot', _selectedSlot),
              const Divider(color: Colors.white12, height: 16),
              _buildSummaryRow('Address', '${_addressController.text}, ${_cityController.text} - ${_pincodeController.text}'),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.space20),

        ElevatedButton(
          key: const Key('btn_pick_cash_done'),
          onPressed: widget.onClose,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFECC97D),
            foregroundColor: const Color(0xFF05241C),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.space14),
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.border12,
            ),
          ),
          child: const Text(
            'Done / View In Passbook',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: AppTypography.labelMeta(color: const Color(0xFF8EAA9E)).copyWith(fontSize: 12),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        label,
        style: AppTypography.labelMeta(color: const Color(0xFFC7D9D1)).copyWith(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 13),
      prefixIcon: Icon(icon, color: AppColors.goldLight, size: 18),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.06),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: AppRadius.border10,
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.border10,
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: AppRadius.border10,
        borderSide: BorderSide(color: AppColors.goldPrimary, width: 1.2),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: AppRadius.border10,
        borderSide: BorderSide(color: Color(0xFFF87171), width: 1.2),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: AppRadius.border10,
        borderSide: BorderSide(color: Color(0xFFF87171), width: 1.2),
      ),
      errorStyle: const TextStyle(color: Color(0xFFF87171), fontSize: 11),
    );
  }
}
