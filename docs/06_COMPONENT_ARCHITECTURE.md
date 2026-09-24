# Reusable Component Architecture — Kitty App

**Project**: Swastik Jewellers Kitty App (Sub-Brand: Kitty Vault)  
**Primary Codebase**: `D:\kitty_app\`  
**Document Status**: Synchronized with Current Implementation  
**Last Audit Date**: 2026-09-23  

---

## 1. Component Hierarchy & System Overview

All reusable UI components are encapsulated under `lib/shared/widgets/` and domain feature widget folders, engineered for zero unwanted rebuilds, responsive touch targets ($\ge 48$px), and luxury visual aesthetics.

---

## 2. Master Reusable Component Catalog

### 2.1 Navigation & Shell Components

#### `AppBottomNavBar`
* **File**: `lib/shared/widgets/navigation/app_bottom_nav_bar.dart`
* **Purpose**: Fixed bottom frosted-glass navigation dock.
* **Items (4 Destinations)**:
  1. Home (`Icons.storefront_outlined`)
  2. Coin Rates (`Icons.monetization_on_outlined`)
  3. Jewellery (`Icons.diamond_outlined`)
  4. Calculator (`Icons.calculate_outlined`)
* **Styling**: `BackdropFilter(sigma: 18)`, `creamIvoryCard` background with 85% opacity, `honeyGoldAccent` active indicators, and haptic feedback on tab selection (`HapticFeedback.selectionClick()`). (KYC and Menu tabs were removed to reduce dock clutter).

#### `HeaderNavBar`
* **File**: `lib/shared/widgets/navigation/header_nav_bar.dart`
* **Purpose**: Sticky luxury top application header.
* **Elements**:
  - **Left**: Live 24K gold rate ticker pill (`24K: ₹7550/g`) aligned to the LEFT with compact font (`11px`) and pulsating green status indicator.
  - **Center**: Authentic Swastik Jewellers brand crest (`assets/icons/swastiklogo.svg`).
  - **Right**: Notification Bell with unread badge counter (`NotificationBellBadge`) and 3-lines hamburger menu toggle (`Icons.menu_rounded`) opening the navigation drawer.

#### `LuxuryNavDrawer`
* **File**: `lib/shared/widgets/navigation/luxury_nav_drawer.dart`
* **Purpose**: Slide-out navigation drawer with high-prestige branding.
* **Elements**:
  - Patron Profile Card: Circular initial avatar, customer name, phone number, and "Tier 1 Verified" gold chip.
  - Primary Navigation Links: Home, My Kitty Scheme, Passbook Ledger, Kitty Offers & Plans, Notifications (with unread badge), KYC Compliance, Settings & Security.
  - Concierge & Showroom Contact Footer.

---

### 2.2 Brand & Showcase Components

#### `HomeStoreVideoSection`
* **File**: `lib/features/home/presentation/widgets/home_store_video_section.dart`
* **Purpose**: Interactive store experience and showroom craftsmanship video player on the Home feed.
* **Key Capabilities**:
  - Play / Pause toggle with a continuous 2-second breathing pulse animation on the play icon.
  - Video scrub progress bar.
  - Audio mute/unmute toggle.
  - Administrative upload action (`_handleUploadVideo`) using `ImagePicker.pickVideo()` with duration constraint (max 5 minutes) and floating feedback snackbar.

#### `HomeActiveKittyCard`
* **File**: `lib/features/home/presentation/widgets/home_active_kitty_card.dart`
* **Purpose**: Hero card presenting the customer's active gold savings scheme.
* **Elements**: Scheme name, `#SW-042` chip pill, Total Deposited (₹40,000), Monthly EMI (₹5,000), progress indicator ("8 of 12 installments"), and prominent "See Active Scheme" button navigating directly to `/dashboard` ("My Schemes").

#### `HomeCuratedProductGrid`
* **File**: `lib/features/home/presentation/widgets/home_curated_product_grid.dart`
* **Purpose**: 2-column showcase of curated jewelry products featuring luxury inset presentation trays (`height: 112`, padding: 8, `AppColors.warmLinenInset`) that optimize image display size and preserve natural aspect ratio without clipping.

#### `HomeGoldRateStrip`
* **File**: `lib/features/home/presentation/widgets/home_gold_rate_strip.dart`
* **Purpose**: Authoritative bullion benchmark rate card displaying 22K and 24K live rates paired with the official BIS 999 Hallmark trust badge.

---

### 2.3 Valuation & Transactional Components (2026-09-24)

#### `CalculatorScreen`
* **File**: `lib/features/calculator/presentation/screens/calculator_screen.dart`
* **Purpose**: Dedicated gold valuation calculator accessible via bottom dock.
* **Features**:
  - "Shop by Gram" and "Shop by Money" reactive mode switchers.
  - Karat selection chips (24K, 22K, 18K).
  - Dynamic computation card (Weight $\leftrightarrow$ Rate $\leftrightarrow$ Total Valuation).
  - Defensive states: Empty state, active calculation, invalid input, zero handling, decimals, and soft keyboard dismissal.

#### `PickCashSheet`
* **File**: `lib/features/checkout/presentation/widgets/pick_cash_sheet.dart`
* **Purpose**: Dedicated luxury bottom sheet for doorstep cash pickup collection.
* **Features**:
  - Pre-populates patron name, phone, email, and installment amount.
  - Address, city, and 6-digit postal pincode input fields with form validation.
  - Preferred pickup slot selector chips (Morning, Afternoon, Evening).
  - PMLA statutory compliance validation (under ₹2,00,000 ceiling).
  - Confirmation outcome card with pickup reference code (`PCK-XXXXXX`) and 6-digit physical handover OTP.


---

### 2.3 Progress & Metrics Components

#### `KittyCircularProgressGauge`
* **File**: `lib/shared/widgets/progress/kitty_circular_progress_gauge.dart`
* **Purpose**: Animated circular progress gauge displaying installment completion.
* **Props**: `completedMonths` (int), `totalMonths` (int), `radius` (double), `strokeWidth` (double).
* **Physics**: Sweeps from 0° to target arc over 800ms using `Curves.easeOutCubic`.

#### `PassbookSummaryCard`
* **File**: `lib/features/passbook/presentation/widgets/passbook_summary_card.dart`
* **Purpose**: 3-pillar metric summary strip for the Passbook ledger.
* **Pillars**:
  1. Total Deposited (₹40,000)
  2. Bonus Gold Accrued (5.482g)
  3. Next Due Date (15 Oct 2026)

#### `PassbookControlsRow`
* **File**: `lib/features/passbook/presentation/widgets/passbook_controls_row.dart`
* **Purpose**: Segmented control switcher between **Table View** and **Card View**.

---

### 2.4 Transaction & Receipt Components

#### `DigitalReceiptModal` / `ReceiptScreen`
* **File**: `lib/features/receipt/presentation/widgets/digital_receipt_modal.dart`
* **Purpose**: Parameterized official GST tax invoice voucher.
* **Elements**:
  - Tax invoice number, GSTIN, HSN gold bullion code.
  - Patron details, scheme membership ID, chit token (`#SW-042`).
  - Transaction reference number, bank payment gateway mode, paid date/time.
  - Swastik Jewellers official watermark verification stamp.
  - Action buttons: "Print Receipt" (triggers native printing) and "Close".

---

### 2.5 3D Procedural Canvas Engines

#### `Diamond3dPainter`
* **File**: `lib/features/splash/presentation/widgets/diamond_3d_painter.dart`
* **Purpose**: CustomPainter rendering 3D rotating diamond particle physics on the splash screen without external 3D engine overhead.

#### `JewelryConstellationPainter`
* **File**: `lib/features/auth/presentation/widgets/jewelry_constellation_painter.dart`
* **Purpose**: Continuous 24-second parametric rotation loop rendering solitaire diamond rings, bangles, and starburst sparkles on the Login and KYC screens.

---

### 2.6 Universal Feedback & Button Components

| Component | Location | Variants / States |
| :--- | :--- | :--- |
| `KittyPrimaryButton` | `lib/shared/widgets/buttons/kitty_primary_button.dart` | Default, Loading (gold spinner), Disabled. |
| `KittyEmptyState` | `lib/shared/widgets/feedback/kitty_empty_state.dart` | Configurable icon, title, description, and action button. |
| `KittyErrorState` | `lib/shared/widgets/feedback/kitty_error_state.dart` | Dark & Light surface variants with retry callback. |
| `KittyShimmer` | `lib/shared/widgets/feedback/kitty_shimmer.dart` | Metallic gold shimmering skeleton placeholder. |
