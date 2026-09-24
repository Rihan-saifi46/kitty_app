# Product Flow & Navigation Architecture — Kitty App

**Project**: Swastik Jewellers Kitty App (Sub-Brand: Kitty Vault)  
**Primary Codebase**: `D:\kitty_app\`  
**Document Status**: Synchronized with Current Implementation  
**Last Audit Date**: 2026-09-23  

---

## 1. Master Navigation Architecture

The Kitty App employs a multi-tiered navigation structure using **GoRouter 14.x**:

```mermaid
graph TD
    Splash["/splash<br>(Smooth Startup & Crest Dissolution)"] --> AuthCheck{"Session Exists?"}
    
    AuthCheck -- "No / Expired" --> Login["/auth/login<br>(Instagram SSO or Mobile)"]
    AuthCheck -- "Yes & Unverified" --> KYCGuard["/kyc<br>(Mandatory Compliance)"]
    AuthCheck -- "Yes & Verified" --> Shell["AppShellScaffold<br>(Protected Main Hub)"]
    
    subgraph AuthFlow ["Authentication Flow"]
        Login -->|Mobile Selected| Phone["/auth/phone<br>(10-Digit Mobile)"]
        Phone --> OTP["/auth/otp<br>(6-Digit Verification Grid)"]
        OTP --> ProfileCheck{"Profile Complete?"}
        ProfileCheck -- "No" --> Register["/auth/profile<br>(Name, Email, City)"]
        ProfileCheck -- "Yes" --> AuthSuccess["/auth/success<br>(Welcome Badge)"]
        Register --> AuthSuccess
        AuthSuccess --> KYCGuard
        Login -->|Instagram SSO| AuthSuccess
    end

    subgraph BottomDock ["4-Item Frosted Bottom Dock"]
        Shell --> Tab0["Tab 0: /home<br>(Brand Feed, Offers & Video)"]
        Shell --> Tab1["Tab 1: /coin-rates<br>(Gold/Silver Coins & Karats)"]
        Shell --> Tab2["Tab 2: /jewellery<br>(Fine Jewellery Showroom)"]
        Shell --> Tab3["Tab 3: /calculator<br>(Gold Valuation Calculator)"]
    end

    subgraph DrawerAndLinks ["Drawer & Contextual Navigation"]
        Shell --> Drawer["LuxuryNavDrawer"]
        Drawer --> Dashboard["/dashboard<br>(My Schemes Tracker)"]
        Drawer --> Passbook["/passbook<br>(12-Month Table/Cards)"]
        Drawer --> Offers["/offers<br>(Kitty Savings Schemes)"]
        Drawer --> KYC["/kyc<br>(Statutory Verification)"]
        Drawer --> Notifications["/notifications<br>(Alerts & Privileges)"]
        Drawer --> Settings["/settings<br>(Security, MPIN, Nominee)"]
    end

    subgraph PaymentPipeline ["Transactional Flows"]
        Dashboard -->|Pay Installment| Checkout["/checkout<br>(Payment Method Selector)"]
        Passbook -->|Pay Installment| Checkout
        Checkout -->|UPI / NetBanking / Card| Gateway["/gokwik-gateway<br>(Isolated WebView)"]
        Gateway --> Polling["Reconciliation Polling<br>(5 attempts x 3s)"]
        Polling --> SuccessResult["Payment Success Modal"]
        SuccessResult --> Receipt["/receipt/:id<br>(Official Tax Invoice)"]
        Passbook -->|View Receipt| Receipt
        Checkout -->|Pick Cash| PickCash["Pick Cash Sheet<br>(Address, Slot, OTP)"]
        PickCash --> CashSuccess["Cash Pickup Scheduled Modal"]
    end
```

---

## 2. Detailed End-to-End User Flows

### 2.1 Authentication & Onboarding Flow
1. **Splash Entry (`/splash`)**:
   - Renders with non-blank emerald canvas root (`AppColors.emeraldDeep`) ensuring seamless first-frame painting.
   - Smooth 3D diamond rotation with natural breathing scale (0.95 to 1.15) softly dissolving into the central Swastik crest.
   - Concurrently checks `SecureStorageService` for active JWT session token and user profile.
   - Navigates smoothly to `/home` if authenticated, or `/auth/login` if session is absent/expired.
2. **Login Selection (`/auth/login`)**:
   - Patron selects between **Continue with Instagram** (Instagram SSO branded button) or **Continue with Mobile**.
3. **Mobile Phone Entry (`/auth/phone`)**:
   - Patron enters their 10-digit Indian mobile number with country code picker.
   - Triggers `POST /api/v1/auth/send-otp`. Upon success, navigates to `/auth/otp`.
4. **OTP Verification (`/auth/otp`)**:
   - Patron enters the 6-digit verification code with auto-advance across cells.
   - Features 30-second resend countdown timer and auto-shake feedback on incorrect submission.
5. **First-Time Profile Registration (`/auth/profile`)**:
   - If profile is incomplete, patron enters **Full Legal Name**, **Email Address**, and **City**.
6. **Authentication Welcome Splash (`/auth/success`)**:
   - Displays patron name, membership tier chip ("Tier 1 Verified Member"), and gold "Enter Vault" CTA.

---

### 2.2 Home Brand Feed Flow (`/home`)
1. **Sticky Top Header (`HeaderNavBar`)**:
   - Left-aligned live 24K gold rate pill with pulsing indicator.
   - Center authentic Swastik brand SVG crest.
   - Right-aligned notification bell with badge counter and hamburger drawer trigger.
2. **Promotional Offers Carousel (`HomeOffersCarousel`)**:
   - Positioned at the top of the feed right below the header/KYC banner for maximum promotional impact.
3. **Active Jewel Plan Card (`HomeActiveKittyCard`)**:
   - Displays active scheme summary and "See Active Scheme" button that navigates directly to `/dashboard` ("My Schemes").
4. **Store Video Showcase Section (`HomeStoreVideoSection`)**:
   - Showroom craftsmanship video player with play/pause, progress tracking, and audio mute.
5. **Curated For You Product Grid (`HomeCuratedProductGrid`)**:
   - 2-column showcase with luxury inset presentation trays (`height: 112`) keeping image aspect ratios balanced without card clipping.
6. **Daily Bullion Rate Trust Strip (`HomeGoldRateStrip`)**:
   - Hallmark and BIS trust guarantees.

---

### 2.3 Bullion & Coin Rates Flow (`/coin-rates`)
1. **Gold Coins vs. Silver Coins Tab Switcher**:
   - High-contrast toggle between **Gold Coins** and **Silver Coins**.
2. **Rectangular Coin Rate Cards (1g to 5g)**:
   - Dedicated rectangular cards for 1g, 2g, 3g, 4g, and 5g weights displaying metal type, weight, and dynamic live rate.
3. **Custom Weight & Purity Selection**:
   - Numeric gram input for custom coin weights.
   - **Karat Selector (24K / 22K)**: Dynamically rendered ONLY when Gold Coins is active.
   - For Silver Coins, the Karat selector is strictly hidden to respect bullion metallurgy standards.

---

### 2.4 Jewellery Catalog Flow (`/jewellery`)
1. **Authentic Photography Showcase**:
   - Real, authentic showroom product photographs with smooth fade-in loading and graceful icon fallbacks.
2. **Metal & Category Selectors**:
   - Dual dropdowns for **Gold Jewellery** and **Diamond Jewellery** across 6 categories: Rings, Pendants, Necklace, Earrings, Bangles, and Bracelets.

---

### 2.5 Gold Valuation Calculator Flow (`/calculator`)
1. **Dedicated Bottom Dock Tab**:
   - Accessible via Tab 3 of the bottom navigation bar.
2. **Dual Reactive Input Modes**:
   - **Shop by Gram**: User enters weight (e.g. 5.5g) $\rightarrow$ computes applicable gold rate $\rightarrow$ outputs Total Valuation Amount.
   - **Shop by Money**: User enters budget (e.g. ₹50,000) $\rightarrow$ computes applicable gold rate $\rightarrow$ outputs Estimated Weight in grams.
3. **Purity / Karat Selector**:
   - Toggle between 24K (Pure Gold), 22K (Standard Jewellery 916), and 18K (Diamond Studded).
4. **Defensive States**:
   - Fully supports empty states, decimal values, zero input, large values, instant reset, and soft keyboard dismissal.

---

### 2.6 Kitty Scheme Dashboard Flow (`/dashboard`)
1. **3-Pillar Metric Summary**:
   - High-contrast summary cards: Total Deposited, Bonus Gold Accrued, Next Due Date.
2. **Active Scheme Card**:
   - Circular animated progress gauge and installment timeline.
3. **Pay Installment CTA**:
   - Launches `/checkout` payment sheet.

---

### 2.7 Passbook & Digital Receipt Flow (`/passbook`)
1. **Dual-Mode Layout Switcher**:
   - **Table View**: Classic financial ledger with columns for Month, Due Date, Paid Date, Amount, Method, and Action.
   - **Card View**: Touch-optimized vertical stack of monthly payment tiles.
2. **Pay Installment Flow**:
   - Tapping "Pay Installment" on due installments opens `/checkout` with interactive payment channel selection.
3. **Digital Tax Receipt**:
   - Clicking "Receipt" on paid installments opens `/receipt/:id` tax invoice.

---

### 2.8 Payment Checkout & Doorstep "Pick Cash" Flow (`/checkout`)
1. **Interactive Payment Method Selection**:
   - Supports **UPI**, **Net Banking**, **Debit/Credit Card**, and **Pick Cash**.
   - Tapping any method updates active radio border, gold glow, and selection state.
2. **Online Gateway Flow**:
   - UPI, Net Banking, or Card opens GoKwik gateway webview followed by reconciliation polling.
3. **Doorstep "Pick Cash" Pipeline**:
   - Selecting "Pick Cash" opens `PickCashSheet`.
   - Pre-populates patron name, phone, email, and active scheme installment amount.
   - Captures pickup address, city, 6-digit postal pincode, and preferred time slot (Morning, Afternoon, Evening).
   - Validates PMLA compliance limits (₹1,99,999 cash collection maximum).
   - Generates unique reference code (`PCK-XXXXXX`) and 6-digit physical handover verification OTP.

