# Frontend UI/UX Design System Specification — Kitty App

**Project**: Swastik Jewellers Kitty App (Sub-Brand: Kitty Vault)  
**Primary Codebase**: `D:\kitty_app\`  
**Document Status**: Synchronized with Current Implementation  
**Last Audit Date**: 2026-09-23  

---

## 1. Dual-Surface Luxury Design Philosophy

The Kitty App visual architecture is organized around a **Dual-Surface Luxury Paradigm** that resolves the conflict between royal sensory brand prestige and daytime financial legibility:

```text
┌────────────────────────────────────────────────────────┐
│ SURFACE 1: DEEP EMERALD HERITAGE (#05241C)            │
│ Royal Indian Heritage, High-Security, High-Prestige   │
│ Used on: Splash, Login, KYC, Checkout Modals, Drawer   │
└────────────────────────────────────────────────────────┘
                           ▲
                           │ Contextual Transition
                           ▼
┌────────────────────────────────────────────────────────┐
│ SURFACE 2: WARM LUXURY ALABASTER (#FAF7F2)            │
│ Daytime Financial Clarity, Tactile Warmth, Legibility │
│ Used on: Home, Passbook, Coins, Jewellery, Calculator  │
└────────────────────────────────────────────────────────┘
```

---

## 2. Color System & Design Tokens (`AppColors`)

### 2.1 Surface 1: Brand Emerald & Royal Green Palette
| Token Name | Hex Code | Visual Application |
| :--- | :--- | :--- |
| `deepEmeraldBase` | `#05241C` | Full-screen background for Splash, Login, and KYC screens. |
| `emeraldCard` | `#092B22` | Glassmorphic card surface on dark emerald views. |
| `emeraldCardAlt` | `#0B3026` | Alternate nested card background. |
| `emeraldPrimary` | `#064E3B` | Active filter buttons, tab indicators. |
| `emeraldContainer` | `#0C2B24` | Circular icon backdrops and container surfaces. |
| `emeraldTextSubtle`| `#9FB8AE` | Secondary labels and captions on dark emerald cards. |
| `emeraldBorder` | `rgba(16, 185, 129, 0.20)` | Subtle emerald card borders and separator lines. |

### 2.2 Surface 2: Official Warm Luxury Palette
| Token Name | Hex Code | Visual Application |
| :--- | :--- | :--- |
| `alabasterSilk` / `homeCanvasBg` | `#FAF7F2` | Warm Alabaster Silk base background for Home, Passbook, Calculator. |
| `creamIvoryCard` | `#F4F0EA` | Polished Cream Ivory card surface for active scheme and offers. |
| `warmLinenInset` | `#EDE8DF` | Subtle inner inset container for metrics and product presentation trays. |
| `honeyGoldAccent` | `#DCA237` | Primary luxury CTA buttons ("See Active Scheme", "Book Coin"), circular gauge arc. |
| `champagneFoil` | `#F3E0B5` | `#SW-042` chip pill, 24K gold rate banner pill, "Royal Club" badge. |
| `espressoCharcoal` | `#2B2521` | High-contrast numbers (₹40,000), patron greeting, primary headings. |
| `warmTaupeBrown` | `#6E6259` | Metric labels ("TOTAL DEPOSITED", "8 of 12 installments"). |
| `deepUmberBronze` | `#26211E` | High-contrast secondary CTAs ("Explore Plan", "View All"). |

### 2.3 Universal Brand Metallic Gold Tokens
| Token Name | Hex Code | Visual Application |
| :--- | :--- | :--- |
| `goldPrimary` | `#C59B27` | Brand crest accents, verified status icons, gold tier badges. |
| `goldGradientStart` | `#E6C275` | Primary CTA button gradient start point. |
| `goldGradientEnd` | `#CCA043` | Primary CTA button gradient end point. |
| `goldLight` | `#DFC178` | Shimmer highlights and metallic card border glows. |
| `goldSubtle` | `rgba(197, 155, 39, 0.12)` | Subtle tinted circular icon backgrounds. |
| `goldBorder` | `rgba(197, 155, 39, 0.28)` | Specular card borders and focus rings. |

---

## 3. Typography Hierarchy (`AppTypography`)

The app enforces a three-family typography hierarchy:

```text
Cinzel (Serif)           ──► Royal Brand Titles, Scheme Names, Display Headers
Playfair Display (Serif)  ──► Luxury Editorial Subtitles, Patron Greetings
Montserrat (Sans-Serif)   ──► Numbers, Financial Ledgers, Buttons, Meta Labels
```

| Text Style Method | Font Family | Size | Weight | Tracking | Primary Usage |
| :--- | :--- | :-: | :-: | :-: | :--- |
| `displayBrand()` | Cinzel | 26px | 700 (Bold) | -0.2px | Top section branding, modal headers |
| `heroTitle()` | Cinzel | 22px | 700 (Bold) | +0.4px | Active scheme pass title, hero banners |
| `displaySubtitle()` | Playfair Display | 18px | 600 (SemiBold) | +0.3px | Editorial banners, patron greetings |
| `cardTitle()` | Montserrat | 17px | 700 (Bold) | 0.0px | Card titles, screen sub-headers |
| `sectionHeading()` | Montserrat | 15px | 600 (SemiBold) | 0.0px | Section headers, table column titles |
| `bodyBold()` | Montserrat | 14px | 700 (Bold) | +0.2px | Primary button labels, table numbers |
| `bodyRegular()` | Montserrat | 14px | 400 (Regular) | 0.0px | Descriptive text, terms, modal bodies |
| `caption()` | Montserrat | 12px | 400 (Regular) | 0.0px | Supporting text, timestamps, subtitles |
| `kickerCaps()` | Montserrat | 11px | 800 (ExtraBold) | +1.5px | Uppercase section kickers, status pills |
| `labelMeta()` | Montserrat | 10px | 500 (Medium) | 0.0px | Bottom dock labels, tiny badges |

---

## 4. Spacing, Corner Radius & Elevations

### 4.1 Spacing Scale (`AppSpacing`)
* `space4` (4px), `space8` (8px), `space12` (12px), `space14` (14px), `space16` (16px), `space20` (20px), `space24` (24px), `space32` (32px), `space64` (64px).

### 4.2 Corner Radius Scale (`AppRadius`)
* `border4` (4px), `border8` (8px), `border12` (12px), `border16` (16px — standard card), `border20` (20px — modals and buttons), `border32` (32px — pills and badges).

### 4.3 Shadow & Elevation System
* **Dark Surface Elevation**: Specular top hairline border (`1px` with `goldBorder`) paired with dual ambient drop shadow:
  ```dart
  BoxShadow(color: Color(0x33000000), blurRadius: 18, offset: Offset(0, 8))
  ```
* **Warm Luxury Card Elevation**: Subtle warm drop shadow:
  ```dart
  BoxShadow(color: Color(0x062B2521), blurRadius: 10, offset: Offset(0, 3))
  ```

---

## 5. Motion, Physics & Micro-Animations

1. **Hardware-Accelerated 3D Diamond Particle Canvas (`Diamond3dPainter`)**:
   - Renders 24-frame diamond facet rotation with depth-sorted vertex shading on Splash.
2. **Smooth Startup & Crest Dissolution Transition**:
   - Immediate non-blank root canvas (`#05241C`) eliminates white/unpainted first frames.
   - Refined scale trajectory ($0.95 \rightarrow 1.15$) with gentle opacity dissolution into the central Swastik brand crest.
3. **3D Multi-Gem Constellation (`JewelryConstellationPainter`)**:
   - Renders orbiting solitaire diamonds, rings, and bangles with starlight sparkles on Login and KYC screens. Continuous 24-second parametric rotation loop.
4. **Circular Installment Gauge (`KittyCircularProgressGauge`)**:
   - Animates sweep angle from 0° to target arc over 800ms using `Curves.easeOutCubic`.
5. **Card Entrance Transitions**:
   - Fast luxury ease (260ms, `Cubic(0.16, 1.0, 0.3, 1.0)`): Cards scale from 0.97 to 1.0 while fading and translating 12px upward.
6. **OTP Shake Animation**:
   - On invalid submission, triggers a 400ms damped sinusoidal horizontal shake ($\pm 8$px) accompanied by system haptic feedback.
7. **Store Video Pulsing Play Button**:
   - Continuous 2-second breathing pulse animation (scale 0.95 to 1.08) inviting interaction.

---

## 6. Granular Component Design Specifications (2026-09-24)

### 6.1 Top Header (`HeaderNavBar`)
* **Live Gold Rate Ticker**: Compact pill aligned to the **LEFT** of the header (`fontSize: 11px`, `fontWeight: w900`, pulsing green indicator).
* **Brand Logo**: Authentic Swastik Jewellers SVG crest positioned in the **CENTER**.
* **Action Controls**: Aligned to the **RIGHT** featuring the Notification Bell (with unread badge counter) and the Hamburger Menu navigation button (`Icons.menu_rounded`).

### 6.2 Curated Product Inset Trays (`HomeCuratedProductGrid`)
* **Presentation Tray**: Inset luxury tray (`height: 112`, padding: 8, `color: AppColors.warmLinenInset`, `borderRadius: 14`) displaying jewelry photographs with natural aspect ratio and zero clipping.

### 6.3 Bullion Coin Cards (`CoinRatesScreen`)
* **Dual Metal Selector**: High-contrast tab toggle between Gold Coins and Silver Coins.
* **Rectangular Denomination Cards**: 1g, 2g, 3g, 4g, 5g cards with metal pill, weight heading, and real-time live rate.
* **Dynamic Karat Selector**: 24K / 22K selector displayed dynamically ONLY for Gold; strictly hidden for Silver.

### 6.4 Gold Valuation Calculator (`CalculatorScreen`)
* **Dual Calculation Modes**: "Shop by Gram" and "Shop by Money" tabs with instantaneous bi-directional calculation against live gold rates.
* **Live Valuation Output Card**: Displays applied karat benchmark, computed weight/amount, and breakdown.

### 6.5 Interactive Payment Selector & Doorstep "Pick Cash" (`PaymentCheckoutModal`, `PickCashSheet`)
* **Active Method Glow**: Selected payment channel displays an active 1.5px gold border and subtle champagne glow.
* **Pick Cash Modal**: Dedicated bottom sheet capturing patron address, city, 6-digit postal code, slot chips, and generating a 6-digit handover OTP.

