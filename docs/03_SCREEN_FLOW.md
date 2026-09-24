# Screen Flow & Granular Screen Inventory — Kitty App

**Project**: Swastik Jewellers Kitty App (Sub-Brand: Kitty Vault)  
**Primary Codebase**: `D:\kitty_app\`  
**Document Status**: Synchronized with Current Implementation  
**Last Audit Date**: 2026-09-23  

---

## 1. Master Screen Inventory

The application currently comprises 18 dedicated screen and modal surfaces:

```text
Authentication Stack:
  ├── /splash                     [SplashScreen]
  ├── /auth/login                 [LoginScreen]
  ├── /auth/phone                 [PhoneScreen]
  ├── /auth/otp                   [OtpScreen]
  ├── /auth/profile               [RegisterProfileScreen]
  └── /auth/success               [AuthSuccessScreen]

Application Shell Branches (StatefulShellRoute):
  ├── /home                       [HomeScreen] (Branch 0)
  ├── /coin-rates                 [CoinRatesScreen] (Branch 1)
  ├── /jewellery                  [JewelleryScreen] (Branch 2)
  ├── /calculator                 [CalculatorScreen] (Branch 3)
  ├── /dashboard                  [DashboardScreen] (Drawer Destination)
  ├── /passbook                   [PassbookScreen] (Drawer Destination)
  ├── /offers                     [OffersScreen] (Drawer Destination)
  └── /settings                   [SettingsScreen] (Drawer Destination)

Modal & Top-Level Stack Routes:
  ├── /kyc                        [KycScreen]
  ├── /checkout                   [CheckoutScreen & PickCashSheet]
  ├── /receipt/:id                [ReceiptScreen]
  ├── /notifications              [NotificationsScreen]
  └── /gokwik-gateway             [GoKwikGatewayScreen]
```

---

## 2. Granular Screen Specifications

### 2.1 Splash Screen (`/splash`)
* **Class**: `SplashScreen` (`lib/features/splash/presentation/screens/splash_screen.dart`)
* **Entry Point**: App launch, deep link without session, or route reset.
* **Exit Points**:
  - `/home`: Valid authenticated session exists and KYC is compliant.
  - `/kyc`: Valid session exists but statutory KYC is pending.
  - `/auth/login`: No active session or token has expired.
* **Key Components**: Emerald background canvas root (`AppColors.emeraldDeep`), `Diamond3dPainter` (hardware-accelerated canvas particle system), Swastik Jewellers crest logo, gold progress indicator.
* **Current Behavior**: Renders on an immediate solid deep emerald background eliminating blank white frames. Diamond performs a gentle breathing scale (0.95 to 1.15) and smoothly dissolves into the central Swastik brand crest while resolving session credentials from `SecureStorageService`.

---

### 2.2 Login Screen (`/auth/login`)
* **Class**: `LoginScreen` (`lib/features/auth/presentation/screens/login_screen.dart`)
* **Entry Point**: App launch without session, logout action from Settings.
* **Exit Points**:
  - `/auth/phone`: Patron clicks "Continue with Mobile Number".
  - `/auth/success`: Patron completes Instagram SSO authentication abstraction.
* **Key Components**: `JewelryConstellationPainter` (3D rotating solitaire and bangle background), damask wallpaper texture, glassmorphic card container, "Continue with Instagram" branded button with royal gradient icon, "Or" divider, Mobile auth button.
* **Current Behavior**: Multi-step container supporting both Instagram SSO abstraction (`authController.loginWithInstagram()`) and mobile OTP authentication.

---

### 2.3 Mobile Phone Screen (`/auth/phone`)
* **Class**: `PhoneScreen` (`lib/features/auth/presentation/screens/phone_screen.dart`)
* **Entry Point**: Clicked "Continue with Mobile Number" on Login screen.
* **Exit Points**:
  - `/auth/otp`: Successful OTP dispatch.
  - `/auth/login`: Back arrow pressed.
* **Key Components**: Country code selector (+91 India default), 10-digit phone field with auto-spacing (`XXXXX XXXXX`), clear button, "Send OTP" CTA.
* **Current Behavior**: Dispatches `POST /api/v1/auth/send-otp`. Disables CTA until 10 valid digits are entered.

---

### 2.4 OTP Verification Screen (`/auth/otp`)
* **Class**: `OtpScreen` (`lib/features/auth/presentation/screens/otp_screen.dart`)
* **Entry Point**: Dispatched OTP from Phone screen.
* **Exit Points**:
  - `/auth/profile`: Unregistered new user needing profile completion.
  - `/auth/success`: Existing verified user with complete profile.
  - `/auth/phone`: Edit mobile number tapped.
* **Key Components**: 6-cell PIN input grid, resend timer countdown (30s), error shake animation, "Verify OTP" button.
* **Current Behavior**: In sandbox/mock mode, testing OTP `123456` verifies immediately. On error, triggers haptic feedback and card shake.

---

### 2.5 Register Profile Screen (`/auth/profile`)
* **Class**: `RegisterProfileScreen` (`lib/features/auth/presentation/screens/register_profile_screen.dart`)
* **Entry Point**: Successful OTP verification for first-time user.
* **Exit Points**:
  - `/auth/success`: Profile submitted successfully.
* **Key Components**: Full Name field, Email Address field, City field, "Complete Registration" luxury CTA.
* **Current Behavior**: Persists profile details in `SecureStorageService` and updates Riverpod `appAuthStateProvider`.

---

### 2.6 Home Screen (`/home` — Shell Tab 0)
* **Class**: `HomeScreen` (`lib/features/home/presentation/screens/home_screen.dart`)
* **Entry Point**: Main app entry post-authentication; Bottom Dock Tab 0.
* **Exit Points**:
  - `/checkout`: "PAY INSTALLMENT" tapped on active scheme card.
  - `/dashboard`: "See Active Scheme" tapped on Active Jewel Plan card.
  - `/offers`: "View All Offers" tapped.
  - `/kyc`: "Verify Identity" tapped on KYC reminder banner.
* **Key Components**:
  1. `HeaderNavBar`: Sticky header with left-aligned 24K gold rate ticker pill (`24K: ₹7550/g`), centered Swastik SVG logo, right-aligned notification bell with badge counter, and hamburger drawer trigger.
  2. `HomeKycReminderBanner`: Warning card shown if patron is not KYC-verified.
  3. `HomeOffersCarousel`: Promotional scheme banners positioned prominently at the top of the feed.
  4. `HomeActiveKittyCard`: Scheme summary card with deposited amount, months paid, and "See Active Scheme" CTA navigating to `/dashboard` ("My Schemes").
  5. `HomeStoreVideoSection`: Showroom tour video player with play/pause and admin upload button.
  6. `HomeCuratedProductGrid`: 2-column showcase of curated jewelry products featuring luxury inset presentation trays (`height: 112`) that optimize image sizing without card clipping.
  7. `HomeGoldRateStrip`: Daily gold rate breakdown and BIS 999 Hallmark trust badge.
* **States**:
  - *Loading*: `HomeSkeletonLoader` with gold shimmer.
  - *Error*: `KittyErrorState` with retry button.
  - *Loaded*: Smooth pull-to-refresh custom scroll view.

---

### 2.7 Coin Rates Screen (`/coin-rates` — Shell Tab 1)
* **Class**: `CoinRatesScreen` (`lib/features/coin_rates/presentation/screens/coin_rates_screen.dart`)
* **Entry Point**: Bottom Dock Tab 1.
* **Key Components**:
  - Gold Coins vs. Silver Coins tab selector with animated selection state.
  - 1g, 2g, 3g, 4g, 5g rectangular coin rate cards displaying metal type, weight, and dynamic live rate.
  - Custom weight selection section with dynamic Karat selector (24K / 22K) shown strictly for Gold; hidden for Silver.
  - Booking confirmation dialog with showroom concierge booking trigger.
* **User Actions**: Switch between Gold and Silver; tap coin cards; select custom grams and purity.

---

### 2.8 Jewellery Screen (`/jewellery` — Shell Tab 2)
* **Class**: `JewelleryScreen` (`lib/features/jewellery/presentation/screens/jewellery_screen.dart`)
* **Entry Point**: Bottom Dock Tab 2.
* **Key Components**:
  - Authentic showroom photography with smooth fade-in loading and graceful fallback.
  - Metal Type dropdown cards: **Gold Jewellery** (22K 916) vs **Diamond Jewellery** (Natural VVS-EF).
  - 6 category chips: Rings, Pendants, Necklace, Earrings, Bangles, Bracelets.
  - 2-column item grid with purity, weight, pricing, and "Best Seller" badges.
  - Reservation enquiry dialog with showroom WhatsApp concierge.

---

### 2.9 Calculator Screen (`/calculator` — Shell Tab 3)
* **Class**: `CalculatorScreen` (`lib/features/calculator/presentation/screens/calculator_screen.dart`)
* **Entry Point**: Bottom Dock Tab 3.
* **Key Components**:
  - Dual Input Modes: **Shop by Gram** and **Shop by Money**.
  - Purity selector chips: 24K (Pure Gold), 22K (916 Hallmarked), 18K (Diamond Jewellery).
  - Real-time valuation output card displaying Applied Rate, Weight in Grams, and Total Valuation in INR.
  - Clear/reset button and soft keyboard dismissal on background tap.
  - Defensive states for empty input, zero, decimals, and extreme values.

---

### 2.10 Dashboard Screen (`/dashboard`)
* **Class**: `DashboardScreen` (`lib/features/dashboard/presentation/screens/dashboard_screen.dart`)
* **Entry Point**: Navigation Drawer, or "See Active Scheme" on Home active scheme card.
* **Key Components**:
  - `DashboardHeroCard`: Circular SVG progress gauge, total saved, accrued gold weight.
  - `DashboardStatsGrid`: 2x2 grid (Months Paid, Jeweler Bonus, Next Due, Total Goal).
  - `DashboardNextEmiCard`: Upcoming installment countdown and one-tap checkout button.
  - `Passbook Link Card`: Quick navigation row to `/passbook`.

---

### 2.11 Passbook Screen (`/passbook`)
* **Class**: `PassbookScreen` (`lib/features/passbook/presentation/screens/passbook_screen.dart`)
* **Entry Point**: Navigation Drawer or Dashboard passbook link.
* **Key Components**:
  - `PassbookSummaryCard`: 3 pillars (Total Deposited, Accrued Gold, Next Due Date).
  - `PassbookControlsRow`: Segmented switcher between **Table View** and **Card View**.
  - `PassbookTimelineTable`: 12-month installment table with receipt action triggers.
  - `PassbookCardsList`: Touch-optimized vertical stack of installment cards.
  - `PassbookPerksDialog`: Modal explaining Month 12 jeweler bonus terms.

---

### 2.12 KYC Screen (`/kyc` — Modal & Drawer Route)
* **Class**: `KycScreen` (`lib/features/kyc/presentation/screens/kyc_screen.dart`)
* **Entry Point**: Navigation Drawer, KYC reminder banner on Home, or Auth Guard redirect.
* **Key Components**:
  - 3D rotating jewelry constellation canvas (`JewelryConstellationPainter`).
  - Document Tab Switcher: **Aadhaar Card** vs **PAN Card**.
  - `KycDocNumberField`: Document number input with auto-formatting and masking.
  - `KycUploadCard`: Front & Back document image picker (Camera or Gallery).
  - `KycConsentCheckbox`: Statutory consent checkbox required under UIDAI and PMLA guidelines.
  - `KycStatusViews`: Verification status states (`NOT_SUBMITTED`, `PENDING`, `VERIFIED`, `REJECTED`).

---

### 2.13 Checkout Screen (`/checkout`)
* **Class**: `CheckoutScreen` (`lib/features/checkout/presentation/screens/checkout_screen.dart`)
* **Entry Point**: "Pay Installment" button on Home, Dashboard, or Passbook.
* **Key Components**:
  - Pre-filled installment context (Membership ID, Chit Token, Month number, Due Amount).
  - Interactive Payment Method Selector: UPI, Net Banking, Card, Pick Cash with active border/glow feedback.
  - GoKwik payment integration bridge for online methods.
  - `PickCashSheet`: Dedicated modal sheet for doorstep cash pickup with address validation, slot selection, and handover OTP.
  - Animated live reconciliation polling overlay (5 attempts $\times$ 3s).
  - Cancelation protection dialog: Warns user if attempting back button while bank verification is active.
  - Success outcome view with direct link to view digital tax receipt.

---

### 2.14 Digital Receipt Screen / Modal (`/receipt/:id`)
* **Class**: `ReceiptScreen` (`lib/features/receipt/presentation/screens/receipt_screen.dart`)
* **Entry Point**: Clicked "Receipt" in Passbook or "View Receipt" following checkout success.
* **Key Components**:
  - Tax invoice number, GSTIN, HSN gold bullion code.
  - Customer name, membership ID, chit token (`#SW-042`).
  - Payment mode (UPI/Card/NetBanking/Cash), transaction reference number, timestamp.
  - Official Swastik Jewellers watermark verification stamp.
  - Print / PDF export action buttons.
