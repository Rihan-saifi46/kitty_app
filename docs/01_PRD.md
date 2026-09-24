# Product Requirements Document (PRD) — Kitty App

**Project**: Swastik Jewellers Kitty App (Sub-Brand: Kitty Vault)  
**Platform**: Flutter Mobile (Android & iOS) + Web  
**Primary Codebase**: `D:\kitty_app\`  
**Document Status**: Synchronized with Current Implementation  
**Last Audit Date**: 2026-09-23  

---

## 1. Executive Summary & Brand Positioning

The **Swastik Jewel Kitty App** is a luxury digital gold savings and jewelry shopping platform developed for **Swastik Jewellers** (Lucknow, India). 

The application modernizes the traditional Indian jewelry chit/kitty scheme model into a high-trust digital passbook while functioning as an omnichannel bullion rate card and showroom jewelry showcase.

### Historical Context & Evolution
* **Original Plan**: Conceived primarily as a 12-month installment savings tracker with a 4-tab bottom navigation dock (`Home`, `My Kitty`, `Offers`, `Settings`).
* **Intermediate Implementation**: Expanded to 5 bottom dock destinations (`Home`, `Coin Rates`, `Jewellery`, `KYC`, `Menu`).
* **Current Implementation (`CURRENT - 2026-09-24`)**: Refined to a focused **4-tab bottom dock** (`Home`, `Coin Rates`, `Jewellery`, `Calculator`). KYC and Menu were removed from the bottom dock to avoid screen clutter (accessible via the luxury drawer and contextual banners). Features a dedicated Gold Valuation Calculator, dual-metal Gold vs. Silver coin rates with dynamic Karat selector (Gold only), real jewelry product imagery, reorganized Home feed (Offers carousel at top, "See Active Scheme" CTA), Instagram SSO login abstraction, interactive payment method selector, and doorstep "Pick Cash" cash collection pipeline.

---

## 2. Feature Classification

### 2.1 Core Implemented Features (`CURRENT`)

| Feature Category | Description | Primary Route | Key Widgets |
| :--- | :--- | :--- | :--- |
| **Authentication & Onboarding** | Multi-tier flow with Instagram SSO abstraction, Mobile input, 6-digit OTP verification grid, first-time Patron Profile Registration, and biometric auth session. | `/auth/login`<br>`/auth/profile`<br>`/auth/success` | `LoginScreen`, `PhoneScreen`, `OtpScreen`, `RegisterProfileScreen`, `AuthSuccessScreen`, `JewelryConstellationPainter` |
| **App Shell & Dock Navigation** | Persistent `StatefulShellRoute` with sticky top header (left-aligned 24K gold rate pill, centered Swastik logo, right-aligned notification bell & hamburger menu), slide-out luxury drawer, and 4-item frosted glass bottom dock (`Home`, `Coin Rates`, `Jewellery`, `Calculator`). | `/home` (Shell) | `AppShellScaffold`, `HeaderNavBar`, `LuxuryNavDrawer`, `AppBottomNavBar` |
| **Home Brand Feed** | Reorganized luxury brand feed: Header with left-aligned gold ticker, KYC reminder, Promotional Offers Carousel at top, Active Jewel Plan card with "See Active Scheme" CTA, Store Video Showcase, Curated 2-column product grid with reduced luxury inset images, and Gold Rate Trust strip. | `/home` | `HomeScreen`, `HomeOffersCarousel`, `HomeActiveKittyCard`, `HomeStoreVideoSection`, `HomeCuratedProductGrid`, `HomeGoldRateStrip` |
| **Bullion & Coin Rate Card** | Gold Coins vs. Silver Coins tab selector, rectangular 1g, 2g, 3g, 4g, 5g coin rate cards, and custom weight calculator with dynamic Karat selector for Gold (24K/22K); Karat selector dynamically hidden for Silver. | `/coin-rates` | `CoinRatesScreen`, `_CoinRatesScreenState`, booking modal |
| **Jewellery Showroom Catalog** | Omnichannel fine jewelry catalog using authentic photographs with segmented Gold & Diamond tabs across 6 categories: Rings, Pendants, Necklace, Earrings, Bangles, and Bracelets with purity, weight, pricing, and smooth image loading fallbacks. | `/jewellery` | `JewelleryScreen`, category chips, item cards, reservation modal |
| **Gold Valuation Calculator** | Dedicated valuation calculator accessible via bottom dock with dual reactive input modes: "Shop by Gram" and "Shop by Money", real-time gold rate and weight/amount computation, Karat selector (24K, 22K, 18K), and defensive state handling. | `/calculator` | `CalculatorScreen`, `_CalculatorScreenState` |
| **Kitty Scheme Dashboard** | Active savings tracker ("My Schemes") with circular animated progress gauge, 2x2 stats grid, installment timeline, and next installment due countdown. | `/dashboard` | `DashboardScreen`, `DashboardHeroCard`, `DashboardStatsGrid`, `DashboardNextEmiCard` |
| **Passbook Ledger & Statements** | 12-month installment ledger with instant Table View vs Card View switcher, 3-pillar summary strip, receipt triggers, and Month 12 bonus perks info. | `/passbook` | `PassbookScreen`, `PassbookTimelineTable`, `PassbookCardsList`, `PassbookSummaryCard`, `PassbookPerksDialog` |
| **Digital Tax Receipts** | Parameterized official tax invoice receipt with GSTIN, HSN codes, official watermark stamp, print trigger, and PDF viewer. | `/receipt/:id` | `ReceiptScreen`, `DigitalReceiptModal` |
| **Statutory KYC Compliance** | High-security identity verification with 3D jewel constellation background, Aadhaar & PAN tab switcher, document number field, file/camera upload, and mandatory consent checkbox (accessible via drawer and Home banner). | `/kyc` | `KycScreen`, `KycUploadCard`, `KycDocNumberField`, `KycConsentCheckbox` |
| **Offers & Scheme Catalog** | Scheme tier catalog (e.g. Swastik Suvarna Varsha 11+1, Dhanvriddhi), duration tabs (All, 6 Months, 11 Months), enrollment dialog, and customer trust guarantees (Jewellery category removed to eliminate duplication). | `/offers` | `OffersScreen`, `OffersSchemeCard`, `OffersDurationTabs`, `OffersEnrollmentDialog` |
| **Settings & Security Center** | Patron profile card with tier badge, UPI AutoPay toggle, Biometric Login toggle, MPIN dialog, Nominee details modal, and legal terms modal. | `/settings` | `SettingsScreen`, `PatronProfileCard`, `SettingsGroupCard`, `MpinDialog`, `NomineeDetailsModal` |
| **In-App Notifications** | Centralized notification feed with category filters (All, Scheme Alerts, Privileges), unread counter badges, and "Mark All as Read" action. | `/notifications` | `NotificationsScreen`, `NotificationItemTile`, `NotificationDetailSheet` |
| **Payment Checkout Pipeline** | Modal checkout bottom sheet, active payment method selector (UPI, Net Banking, Card, Pick Cash), GoKwik integration, live polling reconciliation (5 attempts $\times$ 3s), and cancelation protection. | `/checkout` | `CheckoutScreen`, `PaymentCheckoutModal`, `PaymentProcessingView`, `PaymentResultView` |
| **Doorstep Cash Pickup ("Pick Cash")** | Dedicated luxury sheet capturing address, city, 6-digit pincode, time slot chips, patron details, statutory limits, and generating confirmation OTP. | Modal Sheet | `PickCashSheet` |

### 2.2 Deprecated / Refactored Concepts (`DEPRECATED / NO LONGER USED`)
* **5-Tab Bottom Dock with KYC and Menu**: Replaced by 4 focused tabs (`Home`, `Coin Rates`, `Jewellery`, `Calculator`). KYC is accessible via navigation drawer and Home prompt banner; Menu is accessible via navigation drawer.
* **Google SSO Button**: Replaced with "Continue with Instagram" on login.
* **Jewellery category in Kitty Schemes**: Removed from `/offers` as fine jewelry has a dedicated showroom tab.
* **Abrupt 3D Diamond Flyout**: Replaced with smooth startup canvas background and subtle crest scale transition.

---

## 3. Screen Inventory & Route Matrix

| Route Path | Screen Class | Access Level | Shell Status |
| :--- | :--- | :--- | :--- |
| `/splash` | `SplashScreen` | Public | Fullscreen Standalone |
| `/auth/login` | `LoginScreen` | Public | Fullscreen Standalone |
| `/auth/phone` | `PhoneScreen` | Public | Slide-in Sub-Route |
| `/auth/otp` | `OtpScreen` | Public | Slide-in Sub-Route |
| `/auth/profile` | `RegisterProfileScreen` | Authenticated (Initial) | Fullscreen Sub-Route |
| `/auth/success` | `AuthSuccessScreen` | Authenticated | Fullscreen Standalone |
| `/home` | `HomeScreen` | Protected | Shell Branch 0 |
| `/coin-rates` | `CoinRatesScreen` | Protected | Shell Branch 1 |
| `/jewellery` | `JewelleryScreen` | Protected | Shell Branch 2 |
| `/calculator` | `CalculatorScreen` | Protected | Shell Branch 3 |
| `/dashboard` | `DashboardScreen` | Protected | Shell Standalone Branch |
| `/passbook` | `PassbookScreen` | Protected | Shell Standalone Branch |
| `/offers` | `OffersScreen` | Protected | Shell Standalone Branch |
| `/settings` | `SettingsScreen` | Protected | Shell Standalone Branch |
| `/kyc` | `KycScreen` | Protected | Root Modal Route |
| `/checkout` | `CheckoutScreen` | Protected | Root Modal Sheet |
| `/receipt/:id` | `ReceiptScreen` | Protected | Root Modal Route |
| `/notifications` | `NotificationsScreen` | Protected | Root Push Route |
| `/gokwik-gateway` | `GoKwikGatewayScreen` | Protected | Root Modal WebView |

---

## 4. Input Forms & Validation Matrix

| Screen | Input Field | Format / Rules | Client Validation Error Message |
| :--- | :--- | :--- | :--- |
| **Login / Phone** | Mobile Number | Exactly 10 digits; Indian prefix `[6-9]`. Formatted as `XXXXX XXXXX`. | "Please enter a valid 10-digit mobile number." |
| **OTP Screen** | OTP Code | Exactly 6 numeric digits `[0-9]{6}`. Auto-advances across cells. | "Invalid OTP. Please check and retry." (Shakes grid) |
| **Register Profile** | Full Name | 2 to 50 characters, alpha + spaces only. | "Please enter your full legal name." |
| **Register Profile** | Email Address | Valid RFC-5322 email regex. | "Please enter a valid email address." |
| **Register Profile** | City | 2 to 40 characters. | "Please enter your city." |
| **KYC Screen** | Document Type | Selection: `AADHAAR` or `PAN`. | Required. |
| **KYC Screen** | Aadhaar Number | Exactly 12 numeric digits. Masked as `XXXX XXXX 1234`. | "Enter valid 12-digit Aadhaar number." |
| **KYC Screen** | PAN Card Number | Exactly 10 alphanumeric characters `[A-Z]{5}[0-9]{4}[A-Z]{1}`. | "Enter valid 10-character PAN number." |
| **KYC Screen** | Document Images | Front and back images; max 5MB; JPG/PNG. | "Please upload clear image of your document." |
| **KYC Screen** | Statutory Consent | Boolean checkbox must be checked. | "Statutory consent is required under UIDAI & PMLA rules." |
| **Coin Rates** | Custom Bulk Grams | Integer $\ge 11$ and $\le 1000$. | "Custom quantity must be between 11g and 1000g." |
| **Settings** | MPIN | Exactly 4 numeric digits. Confirmation must match. | "MPINs do not match." |
| **Settings** | Nominee Details | Name, relationship, contact number. | "Nominee name and relationship are required." |
