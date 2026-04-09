import 'package:flutter/material.dart';

abstract class AppColors {
  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME COLORS (Updated with new palette)
  // ═══════════════════════════════════════════════════════════════════════════
  static const primary = Color(0xFF9991C1);
  static const primaryDark = Color(0xFF443D69);
  static const secondary = Color(0xFF2DD4BF);
  static const accent = Color(0xFFF59E0B);
  static const background = Color(0xFF120F26);
  static const surface = Color(0xFF1A1531);
  static const surfaceLight = Color(0xFF231D43);
  static const success = Color(0xFF10B981);
  static const danger = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const installment = Color(0xFFFF6B6B);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9991C1);
  static const textMuted = Color(0xFF696383);

  // ═══════════════════════════════════════════════════════════════════════════
  // MATERIAL DESIGN 3 - LIGHT THEME COLORS
  // Mapped from custom purple tonal palette
  // ═══════════════════════════════════════════════════════════════════════════

  // ─────────────────────────────────────────────────────────────────────────
  // SURFACE CONTAINER SYSTEM (M3 Elevation Tokens)
  // ─────────────────────────────────────────────────────────────────────────
  static const lightBackground = Color(0xFFFCFAFF);              // Background
  static const lightBackgroundSecondary = Color(0xFFF6F3FE);     // Surface Dim
  static const lightSurface = Color(0xFFFFFFFF);                 // Surface Bright
  static const lightSurfaceContainerLowest = Color(0xFFFFFFFF);  // Tone 100
  static const lightSurfaceContainerLow = Color(0xFFFAF7FE);    // Tone 97
  static const lightSurfaceContainer = Color(0xFFF4F0FF);        // Tone 94 - Card/soft surface
  static const lightSurfaceContainerHigh = Color(0xFFF1EBFD);    // Tone 92
  static const lightSurfaceContainerHighest = Color(0xFFECE6F9); // Tone 90
  static const lightSurfaceElevated = Color(0xFFF9F4FF);         // For modals/sheets
  static const lightSurfaceLight = Color(0xFFF3EEFE);            // Muted containers
  static const lightSurfaceMuted = Color(0xFFE7E1F4);            // Dividers, disabled

  // ─────────────────────────────────────────────────────────────────────────
  // TEXT COLORS (M3 On-Surface Tokens)
  // ─────────────────────────────────────────────────────────────────────────
  static const lightTextPrimary = Color(0xFF120F26);         // Dark primary - On-Surface
  static const lightTextSecondary = Color(0xFF443D69);       // Muted purple - On-Surface-Variant
  static const lightTextMuted = Color(0xFF696383);           // Muted mid tone - Outline
  static const lightTextDisabled = Color(0xFF9991C1);        // Muted purple light - Disabled

  // ─────────────────────────────────────────────────────────────────────────
  // PRIMARY COLOR PALETTE (Deep Purple Seed)
  // ─────────────────────────────────────────────────────────────────────────
  static const lightPrimary = Color(0xFF2A244C);             // Deep purple - Primary
  static const lightPrimaryLight = Color(0xFF443D69);        // Muted purple - hover/pressed
  static const lightPrimaryDark = Color(0xFF1F1A38);         // Darker variant
  static const lightOnPrimary = Color(0xFFFFFFFF);           // On-Primary (white)
  static const lightPrimaryContainer = Color(0xFFE7E1F4);    // Secondary surface - Container
  static const lightOnPrimaryContainer = Color(0xFF120F26);  // Dark primary - On-Container
  static const lightPrimaryMuted = Color(0xFFF4F0FF);        // Soft surface - tinted bg
  static const lightPrimaryBorder = Color(0xFFC9C1E0);       // Accent lavender - borders

  // ─────────────────────────────────────────────────────────────────────────
  // SECONDARY COLOR PALETTE (Teal Seed)
  // ─────────────────────────────────────────────────────────────────────────
  static const lightSecondary = Color(0xFF006A62);           // Secondary (tone 40)
  static const lightSecondaryLight = Color(0xFF00897B);      // Tone 45
  static const lightOnSecondary = Color(0xFFFFFFFF);         // On-Secondary
  static const lightSecondaryContainer = Color(0xFF74F8E8);  // Secondary Container
  static const lightOnSecondaryContainer = Color(0xFF00201D);// On-Secondary-Container
  static const lightSecondaryMuted = Color(0xFFE0F7F5);      // Teal tinted backgrounds
  static const lightSecondaryBorder = Color(0xFFA0E8DF);     // Teal borders

  // ─────────────────────────────────────────────────────────────────────────
  // TERTIARY/ACCENT COLOR PALETTE (Amber/Gold)
  // ─────────────────────────────────────────────────────────────────────────
  static const lightAccent = Color(0xFFA95000);              // Tertiary (tone 40)
  static const lightAccentLight = Color(0xFFC66A10);         // Tone 50
  static const lightOnAccent = Color(0xFFFFFFFF);            // On-Tertiary
  static const lightAccentContainer = Color(0xFFFFDBC8);     // Tertiary Container
  static const lightOnAccentContainer = Color(0xFF351000);   // On-Tertiary-Container
  static const lightAccentMuted = Color(0xFFFFF0E6);         // Amber tinted backgrounds
  static const lightAccentBorder = Color(0xFFFFCCAA);        // Amber borders

  // ─────────────────────────────────────────────────────────────────────────
  // SEMANTIC COLORS - SUCCESS (Green)
  // ─────────────────────────────────────────────────────────────────────────
  static const lightSuccess = Color(0xFF006D3C);
  static const lightSuccessLight = Color(0xFF00895C);
  static const lightOnSuccess = Color(0xFFFFFFFF);
  static const lightSuccessContainer = Color(0xFF9CF6B6);
  static const lightOnSuccessContainer = Color(0xFF00210E);
  static const lightSuccessMuted = Color(0xFFE6F8EC);
  static const lightSuccessBorder = Color(0xFF80E0A0);

  // ─────────────────────────────────────────────────────────────────────────
  // SEMANTIC COLORS - ERROR/DANGER (M3 Error)
  // ─────────────────────────────────────────────────────────────────────────
  static const lightDanger = Color(0xFFBA1A1A);
  static const lightDangerLight = Color(0xFFDE3730);
  static const lightOnDanger = Color(0xFFFFFFFF);
  static const lightDangerContainer = Color(0xFFFFDAD6);
  static const lightOnDangerContainer = Color(0xFF410002);
  static const lightDangerMuted = Color(0xFFFFF0EF);
  static const lightDangerBorder = Color(0xFFFFA8A0);

  // ─────────────────────────────────────────────────────────────────────────
  // SEMANTIC COLORS - WARNING (Orange)
  // ─────────────────────────────────────────────────────────────────────────
  static const lightWarning = Color(0xFFA95000);
  static const lightWarningLight = Color(0xFFC66A10);
  static const lightOnWarning = Color(0xFFFFFFFF);
  static const lightWarningContainer = Color(0xFFFFDBC8);
  static const lightOnWarningContainer = Color(0xFF351000);
  static const lightWarningMuted = Color(0xFFFFF4E6);
  static const lightWarningBorder = Color(0xFFFFCC99);

  // ─────────────────────────────────────────────────────────────────────────
  // SEMANTIC COLORS - INSTALLMENT (Rose/Pink)
  // ─────────────────────────────────────────────────────────────────────────
  static const lightInstallment = Color(0xFFC00040);
  static const lightInstallmentLight = Color(0xFFE01060);
  static const lightOnInstallment = Color(0xFFFFFFFF);
  static const lightInstallmentContainer = Color(0xFFFFD9DE);
  static const lightOnInstallmentContainer = Color(0xFF400012);
  static const lightInstallmentMuted = Color(0xFFFFF0F3);
  static const lightInstallmentBorder = Color(0xFFFFAABB);

  // ─────────────────────────────────────────────────────────────────────────
  // INCOME/EXPENSE SPECIFIC
  // ─────────────────────────────────────────────────────────────────────────
  static const lightIncome = Color(0xFF006D3C);
  static const lightIncomeContainer = Color(0xFF9CF6B6);
  static const lightOnIncomeContainer = Color(0xFF00210E);
  static const lightExpense = Color(0xFFC00040);
  static const lightExpenseContainer = Color(0xFFFFD9DE);
  static const lightOnExpenseContainer = Color(0xFF400012);

  // ─────────────────────────────────────────────────────────────────────────
  // SEMANTIC COLORS - INFO (Blue)
  // ─────────────────────────────────────────────────────────────────────────
  static const lightInfo = Color(0xFF0061A6);
  static const lightInfoLight = Color(0xFF2079C4);
  static const lightOnInfo = Color(0xFFFFFFFF);
  static const lightInfoContainer = Color(0xFFD2E4FF);
  static const lightOnInfoContainer = Color(0xFF001C38);
  static const lightInfoMuted = Color(0xFFE8F1FF);
  static const lightInfoBorder = Color(0xFF99C4F0);

  // ─────────────────────────────────────────────────────────────────────────
  // BORDER & OUTLINE COLORS (M3 Outline Tokens)
  // ─────────────────────────────────────────────────────────────────────────
  static const lightBorder = Color(0xFF696383);              // Muted mid tone
  static const lightBorderVariant = Color(0xFFC9C1E0);      // Accent lavender
  static const lightBorderLight = Color(0xFFE3DDF3);         // Light tone
  static const lightBorderFocus = Color(0xFF2A244C);         // Focus border (primary)

  // ─────────────────────────────────────────────────────────────────────────
  // SHADOW COLORS
  // ─────────────────────────────────────────────────────────────────────────
  static const lightShadow = Color(0x0A120F26);              // 4% dark primary
  static const lightShadowMedium = Color(0x14120F26);        // 8% dark primary
  static const lightShadowStrong = Color(0x1F120F26);        // 12% dark primary

  // ═══════════════════════════════════════════════════════════════════════════
  // ENHANCED SHADOW LEVELS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Level 1: Subtle shadows for cards, list tiles
  static List<BoxShadow> get lightShadowSubtle => [
    const BoxShadow(
      color: Color(0x08120F26),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Color(0x0D120F26),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  /// Level 2: Medium shadows for elevated cards, modals
  static List<BoxShadow> get lightShadowMediumLevel => [
    const BoxShadow(
      color: Color(0x08120F26),
      blurRadius: 24,
      offset: Offset(0, 6),
      spreadRadius: 2,
    ),
    const BoxShadow(
      color: Color(0x0D120F26),
      blurRadius: 12,
      offset: Offset(0, 3),
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Color(0x08120F26),
      blurRadius: 4,
      offset: Offset(0, 1),
      spreadRadius: -1,
    ),
  ];

  /// Level 3: Strong shadows for FAB, bottom sheets
  static List<BoxShadow> get lightShadowStrongLevel => [
    const BoxShadow(
      color: Color(0x0A120F26),
      blurRadius: 32,
      offset: Offset(0, 8),
      spreadRadius: 4,
    ),
    const BoxShadow(
      color: Color(0x0F120F26),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    const BoxShadow(
      color: Color(0x0A120F26),
      blurRadius: 6,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // ENHANCED COLORS - Premium warmth and brand cohesion
  // ═══════════════════════════════════════════════════════════════════════════
  static const lightBackgroundEnhanced = Color(0xFFFAF7FE);
  static const lightSurfaceEnhanced = Color(0xFFFCFAFF);
  static const lightSurfaceMutedEnhanced = Color(0xFFE3DDF3);

  static const lightBorderEnhanced = Color(0xFFC9C1E0);
  static const lightBorderLightEnhanced = Color(0xFFE7E1F4);

  // ═══════════════════════════════════════════════════════════════════════════
  // DEPRECATED GRADIENTS - Use solid colors instead for cleaner design
  // ═══════════════════════════════════════════════════════════════════════════

  // Dark theme - solid colors instead of gradients
  @deprecated
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF9991C1), Color(0xFF9991C1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @deprecated
  static const cardGradient = LinearGradient(
    colors: [Color(0xFF1A1531), Color(0xFF1A1531)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @deprecated
  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFF9991C1),
      Color(0xFF2DD4BF),
      Color(0xFFF59E0B),
    ],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // DEPRECATED LIGHT THEME GRADIENTS - Use solid colors for cohesion
  // ═══════════════════════════════════════════════════════════════════════════

  @deprecated
  static const cardGradientLight = LinearGradient(
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @deprecated
  static const lightPrimaryGradient = LinearGradient(
    colors: [
      Color(0xFF443D69),
      Color(0xFF2A244C),
      Color(0xFF1F1A38),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @deprecated
  static const lightPrimaryGradientSoft = LinearGradient(
    colors: [
      Color(0xFFF4F0FF),
      Color(0xFFE7E1F4),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @deprecated
  static const lightSecondaryGradient = LinearGradient(
    colors: [
      Color(0xFF00897B),
      Color(0xFF006A62),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @deprecated
  static const lightSecondaryGradientSoft = LinearGradient(
    colors: [
      Color(0xFFE0F7F5),
      Color(0xFF74F8E8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );

  @deprecated
  static const lightSuccessGradient = LinearGradient(
    colors: [
      Color(0xFF00895C),
      Color(0xFF006D3C),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @deprecated
  static const lightDangerGradient = LinearGradient(
    colors: [
      Color(0xFFDE3730),
      Color(0xFFBA1A1A),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @deprecated
  static const lightWarningGradient = LinearGradient(
    colors: [
      Color(0xFFC66A10),
      Color(0xFFA95000),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @deprecated
  static const lightShimmerGradient = LinearGradient(
    colors: [
      Color(0xFFF3EEFE),
      Color(0xFFE7E1F4),
      Color(0xFFF3EEFE),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // INTERACTIVE STATES - Light Theme (M3 State Layers)
  // ═══════════════════════════════════════════════════════════════════════════

  static Color lightHoverOverlay(Color baseColor) => baseColor.withValues(alpha: 0.08);
  static Color lightFocusOverlay(Color baseColor) => baseColor.withValues(alpha: 0.12);
  static Color lightPressedOverlay(Color baseColor) => baseColor.withValues(alpha: 0.12);
  static Color lightDraggedOverlay(Color baseColor) => baseColor.withValues(alpha: 0.16);

  static const lightPrimaryHover = Color(0x142A244C);       // 8% primary
  static const lightPrimaryPressed = Color(0x1F2A244C);     // 12% primary
  static const lightSecondaryHover = Color(0x14006A62);     // 8% secondary
  static const lightSecondaryPressed = Color(0x1F006A62);   // 12% secondary
  static const lightDangerHover = Color(0x14BA1A1A);        // 8% danger
  static const lightDangerPressed = Color(0x1FBA1A1A);      // 12% danger

  // ═══════════════════════════════════════════════════════════════════════════
  // CARD SURFACE TINTS
  // ═══════════════════════════════════════════════════════════════════════════
  static const lightSurfacePrimaryTint = Color(0xFFF9F4FF);
  static const lightSurfaceSecondaryTint = Color(0xFFF5FFFE);
  static const lightSurfaceTertiaryTint = Color(0xFFFFF8F5);
  static const lightSurfaceErrorTint = Color(0xFFFFF8F7);

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  static Color getPrimary(bool isDark) => isDark ? primary : lightPrimary;
  static Color getSecondary(bool isDark) => isDark ? secondary : lightSecondary;
  static Color getSuccess(bool isDark) => isDark ? success : lightSuccess;
  static Color getDanger(bool isDark) => isDark ? danger : lightDanger;
  static Color getWarning(bool isDark) => isDark ? warning : lightWarning;
  static Color getAccent(bool isDark) => isDark ? accent : lightAccent;
  static Color getInstallment(bool isDark) => isDark ? installment : lightInstallment;
  static Color getIncome(bool isDark) => isDark ? success : lightIncome;
  static Color getExpense(bool isDark) => isDark ? danger : lightExpense;
  static Color getInfo(bool isDark) => isDark ? const Color(0xFF60A5FA) : lightInfo;
  static Color getTextPrimary(bool isDark) => isDark ? textPrimary : lightTextPrimary;
  static Color getTextSecondary(bool isDark) => isDark ? textSecondary : lightTextSecondary;
  static Color getTextMuted(bool isDark) => isDark ? textMuted : lightTextMuted;
  static Color getSurface(bool isDark) => isDark ? surface : lightSurface;
  static Color getBackground(bool isDark) => isDark ? background : lightBackground;

  static Color getSurfaceContainerLow(bool isDark) =>
      isDark ? surface : lightSurfaceContainerLow;

  static Color getSurfaceContainerHigh(bool isDark) =>
      isDark ? surfaceLight : lightSurfaceContainerHigh;

  static Color getBorder(bool isDark) => isDark
      ? Colors.white.withValues(alpha: 0.1)
      : lightBorderVariant;

  static List<BoxShadow> getCardShadows(bool isDark) => isDark
      ? [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ]
      : lightShadowSubtle;

  static Color getColoredContainer(Color baseColor, bool isDark) {
    if (isDark) {
      return baseColor.withValues(alpha: 0.15);
    }
    return Color.alphaBlend(
      baseColor.withValues(alpha: 0.12),
      lightSurface,
    );
  }

  static Color getTransactionColor(bool isIncome, bool isDark) =>
      isIncome ? getIncome(isDark) : getExpense(isDark);

  static Color getTransactionContainer(bool isIncome, bool isDark) {
    if (isDark) {
      return isIncome
          ? success.withValues(alpha: 0.15)
          : danger.withValues(alpha: 0.15);
    }
    return isIncome ? lightSuccessMuted : lightDangerMuted;
  }
}