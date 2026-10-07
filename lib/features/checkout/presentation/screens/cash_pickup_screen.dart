import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_paths.dart';

/// Recreated 100% identically from dddd/cash-pickup.html
/// Features:
/// - Light cream background #FAF7F0
/// - Header with back arrow & "Doorstep Cash Pickup"
/// - Plan & Amount preview card with Free Doorstep Collection badge
/// - Amount to hand over field
/// - Cash Handover Person section (Name, Mobile, Alternate)
/// - Pickup Location section (GPS button, Flat/Building, Street/Area, City, Pincode)
/// - Pickup Time Window (Today / Tomorrow chips, Morning / Afternoon / Evening slots)
/// - Store Security Guarantee box
/// - "Schedule Pickup & Get OTP" CTA
/// - View 2: OTP & Confirmation View with 6-digit OTP cards (e.g. 742-918),
///   Assigned Shop Executive card (Rajesh Verma, SJ-409), Pickup Summary,
///   "Done - Return to Home", and "View My Gold Plan" buttons
class CashPickupScreen extends StatefulWidget {
  const CashPickupScreen({
    super.key,
    this.planTitle = '11 Month Gold Plan',
    this.amount = 5000,
  });

  final String planTitle;
  final int amount;

  @override
  State<CashPickupScreen> createState() => _CashPickupScreenState();
}

class _CashPickupScreenState extends State<CashPickupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountController;
  final TextEditingController _personNameController = TextEditingController(text: 'Ramesh Kumar');
  final TextEditingController _mobileController = TextEditingController(text: '9876543210');
  final TextEditingController _altMobileController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController(text: 'Flat 302, Royal Palms Residency');
  final TextEditingController _areaController = TextEditingController(text: 'Near City Gold Market, MG Road');
  final TextEditingController _cityController = TextEditingController(text: 'Mumbai');
  final TextEditingController _pincodeController = TextEditingController(text: '400001');

  String _selectedDate = 'Today';
  String _selectedTimeSlot = 'Morning (10:00 AM - 01:00 PM)';
  bool _isScheduled = false;
  String _generatedOtp = '742918';
  String _generatedRequestId = 'CP-84920';

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.amount.toString());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _personNameController.dispose();
    _mobileController.dispose();
    _altMobileController.dispose();
    _address1Controller.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final int randOtp = 100000 + math.Random().nextInt(900000);
    final int randReq = 10000 + math.Random().nextInt(90000);

    setState(() {
      _generatedOtp = randOtp.toString();
      _generatedRequestId = 'CP-$randReq';
      _isScheduled = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pickup Scheduled! Verification OTP is $_generatedOtp'),
        backgroundColor: const Color(0xFF06342B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyOtp() {
    Clipboard.setData(ClipboardData(text: _generatedOtp));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP $_generatedOtp copied to clipboard'),
        backgroundColor: const Color(0xFF06342B),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F0),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Header
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 16, top: 8, bottom: 4),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      if (_isScheduled) {
                        context.go(RoutePaths.offers);
                      } else if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(RoutePaths.offers);
                      }
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF1C1917),
                      size: 24,
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        _isScheduled ? 'Cash Pickup Confirmed' : 'Doorstep Cash Pickup',
                        style: const TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C1917),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: _isScheduled ? _buildSuccessView() : _buildFormView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Plan & Amount Preview Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[Colors.white, Color(0xFFFAF5EC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEBE1D0)),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x05000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF06342B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              '💵',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text(
                              'PAYMENT FOR',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFA8A29E),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.planTitle,
                              style: const TextStyle(
                                fontFamily: 'Playfair',
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1C1917),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const Text(
                          'Cash Amount',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            color: Color(0xFFA8A29E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '₹${widget.amount}',
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF06342B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFEFE8DD), height: 1),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.check_circle_rounded, color: Color(0xFF187A64), size: 15),
                        SizedBox(width: 4),
                        Text(
                          'Free Doorstep Collection',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF187A64),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Verified Store Agent',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11,
                        color: Color(0xFFA8A29E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Cash Amount to Hand Over
          _buildCardSection(
            title: 'CASH AMOUNT TO HAND OVER',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1917),
                  ),
                  decoration: const InputDecoration(
                    prefixText: '₹ ',
                    prefixStyle: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1917),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: Color(0xFFE7E5E4)),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Keep exact cash ready for a quick and smooth handover.',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    color: Color(0xFFA8A29E),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Handover Person Details
          _buildCardSection(
            title: 'CASH HANDOVER PERSON',
            child: Column(
              children: <Widget>[
                _buildInputField(
                  label: 'Name of person who will give cash *',
                  controller: _personNameController,
                  hint: 'e.g. Ramesh Kumar',
                ),
                const SizedBox(height: 10),
                _buildInputField(
                  label: 'Mobile Number *',
                  controller: _mobileController,
                  hint: '9876543210',
                  keyboardType: TextInputType.phone,
                  prefixText: '+91 ',
                ),
                const SizedBox(height: 10),
                _buildInputField(
                  label: 'Alternate Number (Optional)',
                  controller: _altMobileController,
                  hint: 'Secondary contact number',
                  keyboardType: TextInputType.phone,
                  isRequired: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Pickup Location
          _buildCardSection(
            title: 'PICKUP LOCATION',
            child: Column(
              children: <Widget>[
                _buildInputField(
                  label: 'Flat / House No. / Building Name *',
                  controller: _address1Controller,
                  hint: 'e.g. Flat 302, Royal Palms',
                ),
                const SizedBox(height: 10),
                _buildInputField(
                  label: 'Area / Street / Landmark *',
                  controller: _areaController,
                  hint: 'e.g. MG Road',
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _buildInputField(
                        label: 'City *',
                        controller: _cityController,
                        hint: 'Mumbai',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildInputField(
                        label: 'Pincode *',
                        controller: _pincodeController,
                        hint: '400001',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Pickup Time Window
          _buildCardSection(
            title: 'PICKUP TIME WINDOW',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _buildDateChip('Today (Express)', 'Today'),
                    const SizedBox(width: 10),
                    _buildDateChip('Tomorrow', 'Tomorrow'),
                  ],
                ),
                const SizedBox(height: 12),
                _buildSlotOption('Morning (10:00 AM - 01:00 PM)', 'Available'),
                const SizedBox(height: 8),
                _buildSlotOption('Afternoon (01:00 PM - 05:00 PM)', 'Standard'),
                const SizedBox(height: 8),
                _buildSlotOption('Evening (05:00 PM - 08:00 PM)', 'Standard'),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Store Security Guarantee
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F4F0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC5E5DC)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFF187A64),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Store Security Guarantee',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF06342B),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'An OTP will be generated next. Only reveal that OTP when our store staff arrives and presents their official Shop Identity Badge.',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          color: Color(0xFF145344),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Submit CTA Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06342B),
                foregroundColor: Colors.white,
                elevation: 3,
                shadowColor: const Color(0x3306342B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              child: const Text(
                'Schedule Pickup & Get OTP',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 8),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFE6F4F0),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x4D187A64), width: 2),
          ),
          child: const Center(
            child: Icon(Icons.check_rounded, color: Color(0xFF06342B), size: 36),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFD1FAE5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            '● Pickup Scheduled & Confirmed',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF06342B),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Cash Pickup Requested!',
          style: TextStyle(
            fontFamily: 'Playfair',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C1917),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Our store executive has been assigned and will visit your location to collect the cash.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12.5,
            color: Color(0xFF57534E),
            height: 1.4,
          ),
        ),

        const SizedBox(height: 18),

        // OTP Display Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: <Color>[Colors.white, Color(0xFFFAF7F0)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF06342B), width: 2),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x1A06342B),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              const Text(
                'PICKUP VERIFICATION OTP',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Color(0xFF06342B),
                ),
              ),
              const SizedBox(height: 12),

              // 6 Digit OTP row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < 3; i++) ...<Widget>[
                    _buildOtpBox(_generatedOtp.length > i ? _generatedOtp[i] : '0'),
                    const SizedBox(width: 6),
                  ],
                  const Text(' - ', style: TextStyle(fontSize: 20, color: Color(0xFFA8A29E))),
                  const SizedBox(width: 6),
                  for (int i = 3; i < 6; i++) ...<Widget>[
                    _buildOtpBox(_generatedOtp.length > i ? _generatedOtp[i] : '0'),
                    if (i < 5) const SizedBox(width: 6),
                  ],
                ],
              ),

              const SizedBox(height: 14),

              // Warning Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: const Text(
                  'Tell this OTP to our shop executive in person when they arrive. Do not share on phone call.',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF92400E),
                    height: 1.35,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Copy Button
              ElevatedButton.icon(
                onPressed: _copyOtp,
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('Copy OTP'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6F4F0),
                  foregroundColor: const Color(0xFF06342B),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Assigned Executive Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEFE8DD)),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0xFFFAF3E8),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('👨‍💼', style: TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Rajesh Verma',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C1917),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Official Executive ID: SJ-409',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 11.5,
                        color: Color(0xFF57534E),
                      ),
                    ),
                    Text(
                      'Verified Jewellers Staff • Carrying Digital Scale',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF187A64),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Pickup Summary Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFEFE8DD)),
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Pickup Summary',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFA8A29E),
                    ),
                  ),
                  Text(
                    'REQ #$_generatedRequestId',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF57534E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Amount to Handover',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.5,
                      color: Color(0xFF78716C),
                    ),
                  ),
                  Text(
                    '₹${_amountController.text}',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF06342B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Scheduled Time',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.5,
                      color: Color(0xFF78716C),
                    ),
                  ),
                  Text(
                    '$_selectedDate • ${_selectedTimeSlot.split("(")[0].trim()}',
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1917),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Action Buttons
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go(RoutePaths.offers),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06342B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Done - Return to Home',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 46,
          child: OutlinedButton(
            onPressed: () => context.go(RoutePaths.dashboard),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1C1917),
              side: const BorderSide(color: Color(0xFFE7E5E4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23),
              ),
            ),
            child: const Text(
              'View My Gold Plan',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildOtpBox(String digit) {
    return Container(
      width: 40,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD4B886)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A06342B),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          digit,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF06342B),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEFE8DD)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: Color(0xFF78716C),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF44403C),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1917),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFA8A29E)),
            prefixText: prefixText,
            prefixStyle: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1C1917)),
            filled: true,
            fillColor: const Color(0xFFFAF7F0).withValues(alpha: 0.6),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Color(0xFFE7E5E4)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Color(0xFFE7E5E4)),
            ),
          ),
          validator: isRequired ? (value) => value == null || value.trim().isEmpty ? 'Required' : null : null,
        ),
      ],
    );
  }

  Widget _buildDateChip(String label, String value) {
    final bool isSelected = _selectedDate == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedDate = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF06342B) : const Color(0xFFFAF7F0),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFF06342B) : const Color(0xFFE7E5E4),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF44403C),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlotOption(String slot, String status) {
    final bool isSelected = _selectedTimeSlot == slot;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTimeSlot = slot;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF7FAF9) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF06342B) : const Color(0xFFE7E5E4),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              slot,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: const Color(0xFF1C1917),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE6F4F0) : const Color(0xFFF5F5F4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF187A64) : const Color(0xFFA8A29E),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
