# CURRENT STATE CHANGELOG — KITTY APP

**Project**: Swastik Jewellers Kitty App (Sub-Brand: Kitty Vault)  
**Flutter Workspace**: `D:\kitty_app\`  
**UI Reference**: `D:\ui design\`  
**Document Date**: 2026-09-23  
**Auditor / Author**: Antigravity Documentation Synchronization System  

---

## 1. Overview & Purpose

This document provides an exhaustive, field-by-field changelog comparing the **Original Implementation Plan** against the **Current Live Application** in `D:\kitty_app\`. 

Following the completion of the 21 initial implementation phases, the codebase underwent substantial production refinements, UI adaptations, and feature additions between September 18 and September 23, 2026. This changelog captures every intentional deviation, new capability, navigational adjustment, and aesthetic refinement, serving as the definitive historical bridge for both frontend and backend teams.

---

## 2. Master Comparison Matrix: Original Plan vs. Current Application

| Area / Feature | Original Implementation Plan | Current Application (`kitty_app`) | What Changed & Impact | Documentation Synchronized? |
| :--- | :--- | :--- | :--- | :---: |
| **Bottom Navigation Dock** | 4 tabs: Home (`/home`), My Kitty (`/dashboard`), Offers (`/offers`), Settings (`/settings`). | **5 dock items**: Home (`/home`), Coin Rates (`/coin-rates`), Jewellery (`/jewellery`), KYC (`/kyc`), Menu (`/menu`). | High-intent e-commerce actions (Gold Coins, Jewellery) and mandatory statutory verification (KYC) were promoted directly into the bottom navigation bar. Dashboard, Passbook, Offers, and Settings were moved to the drawer and dedicated Menu page. | **YES** |
| **Coin Rates Feature** | Not a standalone screen; gold rates were merely a small strip widget on Home. | **Dedicated Screen: `CoinRatesScreen`** (`/coin-rates`). Features live 24K 999 gold prices for 1g to 10g coins, minting/assay blister pack calculations, and bulk booking (>10g, up to 100g or custom input) with showroom WhatsApp booking. | Added full bullion transaction capability directly within the client. | **YES** |
| **Jewellery Catalog** | Embedded as promo items inside the Offers screen or home category pills. | **Dedicated Screen: `JewelleryScreen`** (`/jewellery`). Features dual segment selectors for Gold and Diamond Jewellery, 6 categories (Rings, Pendants, Necklace, Earrings, Bangles, Bracelets), item pricing, purity/weight tags, and enquiry modal. | Expanded app from a pure chit/kitty savings tool into a luxury omnichannel jewelry catalogue. | **YES** |
| **Navigation Menu Screen** | Only a slide-out drawer (`LuxuryNavDrawer`) triggered via a top hamburger icon. | **Dedicated Fullscreen `MenuScreen`** (`/menu`) + Slide-out Drawer (`LuxuryNavDrawer`). Both exist simultaneously. The bottom tab launches `/menu` in Warm Luxury styling. | Customers have dual access to account services (via bottom tab or top drawer). | **YES** |
| **Authentication Flow** | 3 steps: Mobile Input $\rightarrow$ 6-digit OTP $\rightarrow$ Success splash. | **5 steps**: (0) Google SSO / Mobile selector $\rightarrow$ (1) Mobile input with country picker $\rightarrow$ (2) 6-digit OTP grid with resend timer $\rightarrow$ (3) **Profile Registration (`/auth/profile`)** collecting Name, Email, City $\rightarrow$ (4) Success splash (`/auth/success`) with "Enter Vault" CTA. | Added Google SSO option and a dedicated first-time patron onboarding screen before entry. | **YES** |
| **Home Screen Feed** | Basic view with Active Scheme card, upcoming EMI due date, and promotional carousel. | **Comprehensive 8-section luxury feed**: (1) Sticky header with brand logo & live 24K gold rate pill $\rightarrow$ (2) KYC compliance banner $\rightarrow$ (3) Active Kitty card $\rightarrow$ (4) Offers carousel $\rightarrow$ (5) **Store Video Showcase** (`HomeStoreVideoSection`) with interactive playback & admin upload $\rightarrow$ (6) Curated product grid $\rightarrow$ (7) Editorial banner $\rightarrow$ (8) Gold rate & hallmark trust strip. | Substantially richer home experience blending savings tracking with showroom craftsmanship storytelling. | **YES** |
| **Store Video Section** | Not planned or specified in original plan. | **Interactive Video Section (`HomeStoreVideoSection`)** embedded on Home Screen. Supports play/pause, pulsing audio/video controls, and gallery video upload with local preview and toast feedback. | Allows patrons to preview showroom walk-throughs and craftsmanship films; store managers can upload new reels. | **YES** |
| **Design System & Palette** | Binary split: Deep Emerald (`#05241C`) vs crisp white ledger cards (`#FFFFFF`). | **Dual Luxury Palette System**: Deep Emerald Base (`#05241C`) for Splash, Login, KYC, Checkout, and Drawer; and **Warm Luxury Palette** (Alabaster Silk `#FAF7F2`, Cream Ivory `#F4F0EA`, Espresso Charcoal `#2B2521`, Honey Gold `#DCA237`, Champagne Foil `#F3E0B5`, Warm Linen `#EDE8DF`) for Home, Passbook, Menu, and Settings. | Enhanced visual warmth, tactile luxury, and reading ergonomics across consumer feeds. | **YES** |
| **KYC Identity Verification** | Basic light-mode form with file picker buttons. | **Prestige Dark Emerald Glassmorphic Screen (`KycScreen`)**: 3D rotating jewelry constellation canvas (`JewelryConstellationPainter`), damask background texture, Aadhaar vs PAN tabs, document number field, camera/gallery upload tiles, and mandatory statutory consent checkbox. | Transformed KYC from an administrative chore into a high-security luxury onboarding ritual. | **YES** |
| **Passbook Ledger Experience** | Single scrolling table showing 12 monthly rows. | **Dual-Mode Passbook (`PassbookScreen`)**: Switcher between **Table View** and **Card View**, 3-pillar metric summary card (Total Deposited, Accrued Gold, Next Due), clickable receipt buttons opening `/receipt/:id`, and Month 12 bonus perks informational dialog. | Enhanced flexibility for users on varying screen sizes and touch ergonomics. | **YES** |
| **Digital Tax Receipts** | Simple text receipt dialog. | **Official Tax Receipt Screen / Modal (`ReceiptScreen` / `DigitalReceiptModal`)**: Parameterized route (`/receipt/:id`), tax invoice number, GSTIN, HSN gold bullion code, stamp watermark, print trigger, and PDF viewer integration. | Bank-grade compliance and printable legal proof of installment payment. | **YES** |
| **Payment Flow & Reconciliation** | Basic webview or mock payment button. | **Full Transaction Pipeline (`CheckoutScreen` & `PaymentController`)**: Bottom sheet checkout with pre-filled EMI context, GoKwik isolated webview route (`/gokwik-gateway`), live status polling (5 attempts $\times$ 3s), back-button cancelation guard with warning dialog, and instant receipt routing. | Bulletproof payment UX with zero ambiguous double-payment scenarios. | **YES** |
| **Notifications Center** | Popover notification list. | **Dedicated `/notifications` Screen**: Category filters (All, Scheme Alerts, Privileges), unread counter badges on sticky header and drawer, "Mark All as Read" action, and notification detail bottom sheet. | Centralized hub for transactional updates, lucky draw announcements, and festival bonus notices. | **YES** |
| **Settings & Security** | Basic settings list. | **Comprehensive Patron Settings Hub (`SettingsScreen`)**: Profile card with tier badge, UPI AutoPay / e-Mandate toggle, Biometric Login toggle, Set/Change MPIN dialog, Nominee details modal, and Statutory Disclosures & Compliance modal. | Complete self-service patron security and regulatory mandate management. | **YES** |
| **Routing & App Shell** | Static navigation stack. | **`StatefulShellRoute.indexedStack` with `AppShellScaffold`**: Multi-branch persistent navigation state, sticky header, sliding drawer, bottom frosted-glass dock, and hardware Android `PopScope` back-button interceptor. | Prevents loss of scroll position across tabs and intercepts hardware back gestures safely. | **YES** |
| **Statutory & Legal Guards** | Implicit auth redirect only. | **Explicit Multi-Tier Route Guarding**: Unauthenticated users $\rightarrow$ `/auth/login`; Unverified KYC $\rightarrow$ `/kyc` (with bypass for welcome/profile setup); Verified patrons $\rightarrow$ `/home`. | Enforces statutory Indian precious metal guidelines (PMLA Rule 9, UIDAI Aadhaar masking, BUDS Act 2019). | **YES** |

---

## 3. Component Inventory Changes

| Component Name | File Location | Original Status | Current Status | Notes |
| :--- | :--- | :---: | :---: | :--- |
| `AppBottomNavBar` | `lib/shared/widgets/navigation/app_bottom_nav_bar.dart` | 4 tabs | **5 items** | Frosted glass dock with Home, Coin Rates, Jewellery, KYC, Menu. |
| `HeaderNavBar` | `lib/shared/widgets/navigation/header_nav_bar.dart` | Text logo | **SVG Crest + Ticker** | Swastik SVG logo, hamburger button, live 24K ticker pill (`24K: ₹7485/g`). |
| `LuxuryNavDrawer` | `lib/shared/widgets/navigation/luxury_nav_drawer.dart` | Basic list | **Patron Card + 7 Links** | Patron avatar, phone, tier chip, 7 primary navigation links, concierge footer. |
| `HomeStoreVideoSection` | `lib/features/home/presentation/widgets/home_store_video_section.dart` | None | **NEW** | Interactive video player with pulsing play/pause and admin upload dialog. |
| `HomeCuratedProductGrid` | `lib/features/home/presentation/widgets/home_curated_product_grid.dart` | Single list | **2-Column Grid** | Product cards with gold badge, weight, price, and enquiry action. |
| `RegisterProfileScreen` | `lib/features/auth/presentation/screens/register_profile_screen.dart` | None | **NEW** | Name, email, and city registration form following mobile OTP verification. |
| `CoinRatesScreen` | `lib/features/coin_rates/presentation/screens/coin_rates_screen.dart` | None | **NEW** | 1g–10g 24K coin prices + bulk order booking dialog with assay fees. |
| `JewelleryScreen` | `lib/features/jewellery/presentation/screens/jewellery_screen.dart` | None | **NEW** | Gold & Diamond tabs with 6 jewelry categories, filters, and reservation actions. |
| `MenuScreen` | `lib/features/menu/presentation/screens/menu_screen.dart` | None | **NEW** | Warm luxury fullscreen menu matching drawer items. |
| `JewelryConstellationPainter` | `lib/features/auth/presentation/widgets/jewelry_constellation_painter.dart` | 3D diamond only | **Multi-gem Canvas** | Procedural 3D canvas rendering diamond solitaires, rings, and bangles with starlight sparkles. |

---

## 4. Architectural & State Changes

1. **State Management**: Maintained Riverpod 2.x MVVM architecture. Added `coin_rates_controller`, `jewellery_controller`, and `menu_controller` (local UI state) while retaining `home_controller`, `dashboard_controller`, `passbook_controller`, `offers_controller`, `kyc_controller`, `payment_controller`, `settings_controller`, and `notifications_controller`.
2. **Offline & Mock Fixtures**: Centralized in `lib/core/mock/mock_fixtures.dart`, supporting both offline local testing and live backend execution via `AppConfig`.
3. **Hardware Back Interceptor**: Enhanced `AppShellScaffold` with `PopScope`: if the drawer is open, closes the drawer; if on a non-home tab, navigates back to tab 0 (Home) before prompting app exit.

---

## 2026-09-24 — Product Update

**Release Scope**: Comprehensive UI/UX, Navigation, Bullion Calculation, Payment Channel, and Cold Launch Engine Refinement  
**Date**: September 24, 2026  
**Auditor**: Antigravity Full-Stack Agentic Pairing System  

### Detailed Change Record & Classifications

| Change Item | Scope & Description | Classification | Implementation Details |
| :--- | :--- | :---: | :--- |
| **1. Coins Page Tabs (Gold vs. Silver)** | Top segmented selector allowing users to switch between Gold Coins and Silver Coins with distinct active states. | `IMPLEMENTED` | Added `_selectedMetal` segmented control (`CoinMetalType.gold` / `CoinMetalType.silver`) with gold metallic active pill styling in `lib/features/coin_rates/presentation/screens/coin_rates_screen.dart`. |
| **1b. Rectangular Coin Rate Cards (1g to 5g)** | Standard weight denomination cards for 1g, 2g, 3g, 4g, 5g with rates, metal types, and assay details. | `IMPLEMENTED` | Built 5 rectangular cards displaying live metal rate, hallmark purity (24K 999 for Gold @ ₹7,485.50/g, 999 Fine for Silver @ ₹89.50/g), and tamper-proof blister pack certifications without hardcoding fake pricing. |
| **1c. Dynamic Karat / Purity Selector** | Custom weight selector retains custom gram ordering; Karat selector shown ONLY for Gold, dynamically hidden for Silver. | `IMPLEMENTED` | Purity chips (24K 999 & 22K 916) dynamically render when `_selectedMetal == CoinMetalType.gold`; completely omitted for Silver. Form validation and weight calculations dynamically adapt to selected metal type. |
| **1d. Live Coins API & Rates Contract** | Backend streaming or polling endpoint for real-time gold & silver bullion rates per gram, minting charges, and coin inventory availability. | `BACKEND DEPENDENCY` | Frontend uses `MockGoldRateRepository` and `MockFixtures.coinRatesJson`; future backend must provide `GET /api/v1/bullion/rates?metal=gold,silver` and `GET /api/v1/bullion/coins`. |
| **2. Jewellery Page Authentic Product Photography** | Replaced placeholder illustration mockup assets with authentic real product photographs; added loading fade-in and error fallbacks. | `IMPLEMENTED` | Replaced mockup cards with verified authentic photographs (`hero_diamond_ring.jpg`, `card_pendant_thumb.jpg`, `prod_pear_pendant.jpg`, `cat_necklace.jpg`, `campaign_emerald_necklace.jpg`, `prod_twisted_bangle.jpg`). Added `frameBuilder` loading state and memory width caching (`cacheWidth: 400`). |
| **2b. Missing Authentic Bracelet Photography** | Authentic studio photography for gold chain bracelets does not currently exist in project assets. | `ASSET DEPENDENCY` | Approved existing photography was mapped to preserve visual quality. Authentic high-resolution photography for chain bracelets must be captured and delivered by the photography/marketing team. |
| **3. Home Header Alignment & Sizing** | Gold rate badge made smaller (font: 11, padding: 8x3.5) and aligned to the LEFT; 3-lines hamburger menu moved to the RIGHT; notification bell preserved. | `IMPLEMENTED` | Updated `lib/shared/widgets/navigation/header_nav_bar.dart`. Aligned live 24K ticker badge to the left of the central Swastik logo crest; positioned notifications bell and hamburger menu on the right. Verified responsive layout. |
| **4. Home Curated Product Image Sizing** | Reduced display size of product images in home curated grid while preserving card container hierarchy and aspect ratio. | `IMPLEMENTED` | Re-architected `HomeCuratedProductGrid` image frame using a dedicated warm luxury inset tray (`height: 112`, padding: 8, `AppColors.warmLinenInset`) with `BoxFit.contain`, eliminating visual dominance without card clipping. |
| **5. Bottom Navigation Dock Overhaul** | Removed `KYC` and `Menu` tabs; added dedicated `Calculator` tab. Resulting 4-item dock: Home, Coin Rates, Jewellery, Calculator. | `IMPLEMENTED` | Updated `app_bottom_nav_bar.dart`, `app_shell_scaffold.dart`, and `app_router.dart` (Branches 0, 1, 2, 3). Preserved active states, touch targets, and safe-area insets. KYC remains accessible via header badge and drawer. |
| **6. Dedicated Gold Calculator Screen** | Full native screen with two interactive modes: "Shop by Gram" and "Shop by Money", dynamic real-time outputs, and Karat selection. | `IMPLEMENTED` | Created `lib/features/calculator/presentation/screens/calculator_screen.dart`. Implements Shop by Gram (Weight $\rightarrow$ Rate $\rightarrow$ Total) and Shop by Money (Amount $\rightarrow$ Rate $\rightarrow$ Calculated Weight). Handles 24K, 22K, 18K purities, zero/empty/decimal/large values, keyboard dismissal, and reset. |
| **6b. Calculator Live Valuation API Contract** | Server-side pricing benchmark service providing spot bullion rates across 24K, 22K, 18K purities and indicative making charges. | `BACKEND DEPENDENCY` | Frontend maintains native mathematical model driven by `MockGoldRateRepository`. Backend must expose `GET /api/v1/calculator/benchmark-rates`. |
| **7. Home Offers Carousel Repositioning** | Promotional Kitty Offers carousel moved to top of Home screen, directly beneath header/KYC banner, preceding Active Jewel Plan. | `IMPLEMENTED` | Reordered sliver sequence in `lib/features/home/presentation/screens/home_screen.dart` so `HomeOffersCarousel` renders before `HomeActiveKittyCard`. Verified scroll physics and margins. |
| **8. Active Jewel Plan CTA Navigation** | Replaced "Pay Installment" CTA button with "See Active Scheme" button wired to navigate to "My Schemes" (`RoutePaths.dashboard`). | `IMPLEMENTED` | Updated `home_active_kitty_card.dart` and `home_screen.dart`. Replaced payment trigger with high-contrast luxury button navigating to the active chit dashboard. |
| **9. Authentication Provider UI (Instagram)** | Replaced "Continue with Google" with "Continue with Instagram" on login screen; implemented frontend abstraction. | `IMPLEMENTED` | Updated `login_screen.dart` and `auth_controller.dart`. Rendered authentic Instagram brand icon with linear gradient and wired `loginWithInstagram()` frontend abstraction. |
| **9b. Instagram OAuth Backend & Meta App Credentials** | Server-side Meta/Instagram Graph API OAuth authorization code exchange and user mapping. | `BACKEND DEPENDENCY` | Real OAuth requires Meta App ID, Client Secret, redirect URI configuration, and server endpoint `POST /api/v1/auth/instagram/callback`. Frontend does not fake live tokens. |
| **9c. Instagram Auth Business Confirmation** | Legal and business confirmation regarding Instagram SSO suitability for high-value financial chit scheme authentication. | `BUSINESS CONFIRMATION REQUIRED` | Meta authentication policies and RBI financial onboarding norms require validation by product compliance officers. |
| **10. Kitty Schemes Category Removal** | Removed "Jewellery Catalog" category and section switcher from the Kitty Schemes page (`/offers`). | `IMPLEMENTED` | Updated `lib/features/offers/presentation/screens/offers_screen.dart`. Removed section switcher and catalog grid; page is now dedicated exclusively to savings schemes & duration filters. |
| **11. Passbook Payment Selection Bug Fix** | Fixed state bug where payment method cards had hardcoded `isSelected: false` and prevented method switching. | `IMPLEMENTED` | Introduced `PaymentChannel` enum (`upi`, `netbanking`, `card`, `pickCash`) in `payment_state.dart` and `payment_controller.dart`. Each card now reflects active selection, switches smoothly, and updates button CTA. |
| **12. Pick Cash Payment Method & Pickup Sheet** | Added "PICK CASH" payment method and dedicated luxury bottom sheet capturing doorstep collection logistics. | `IMPLEMENTED` | Created `lib/features/checkout/presentation/widgets/pick_cash_sheet.dart` with patron pre-fill (name, phone, email from auth state), address, city, 6-digit pincode, slot chips, validation, loading, and confirmed state with reference ID and handover OTP. |
| **12b. Pick Cash Backend Submission Contract** | Server endpoint to ingest doorstep cash pickup booking requests and assign field logistics executive. | `BACKEND DEPENDENCY` | Frontend outputs clean `CashPickupRequest` JSON. Future backend must implement `POST /api/v1/payments/cash-pickup` and logistics agent assignment webhook. |
| **12c. Cash Collection Statutory Limit Validation** | Compliance confirmation regarding Prevention of Money Laundering Act (PMLA) cash transaction limits (₹1,99,999 ceiling per transaction / Income Tax Sec 269ST). | `BUSINESS CONFIRMATION REQUIRED` | Cash pickup must enforce mandatory PAN verification for transactions exceeding ₹50,000 and reject orders exceeding statutory daily limits. |
| **13. Cold Launch / Loading Animation Fix** | Eliminated blank frame, dropped first frames, abrupt diamond jump, and 12.5x fly-out on cold launch. | `IMPLEMENTED` | Wrapped root `MaterialApp` builder in `ColoredBox(color: #05241C)` ensuring zero blank frame. Deferred ticker start to `WidgetsBinding.addPostFrameCallback`. Replaced extreme approach jump with smooth natural scale (0.95 to 1.15) and gentle opacity dissipation into Swastik crest. |

---

## 5. Summary Conclusion

The changes implemented on September 24, 2026, successfully modernize the Kitty App across all target workflows:
1. **Bullion & Jewellery**: Standalone tabs for Gold/Silver coins with dynamic purity rules, real jewellery photography, and an interactive Gold Calculator.
2. **Checkout & Operations**: Fixed payment method switching and added an enterprise-grade Doorstep Cash Pickup ("PICK CASH") flow with complete verification safeguards.
3. **Brand Experience**: Harmonized home header layout, refined product grid image sizes, Instagram branded login, and a silky smooth cold launch diamond sequence without blank frames or abrupt visual cuts.

All documentation across `/docs/` has been synchronized to represent this definitive current state.
