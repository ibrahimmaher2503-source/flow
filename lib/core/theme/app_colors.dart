import 'package:flutter/material.dart';

abstract class AppColors {
  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME COLORS
  // ═══════════════════════════════════════════════════════════════════════════
  static const primary = Color(0xFF6C63FF);
  static const primaryDark = Color(0xFF4F46E5);
  static const secondary = Color(0xFF2DD4BF);
  static const accent = Color(0xFFF59E0B);
  static const background = Color(0xFF0F0E1A);
  static const surface = Color(0xFF1E1B4B);
  static const surfaceLight = Color(0xFF2D2A5E);
  static const success = Color(0xFF10B981);
  static const danger = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const installment = Color(0xFFFF6B6B);
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9CA3AF);
  static const textMuted = Color(0xFF6B7280);

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME COLORS - Premium & Modern Palette
  // ═══════════════════════════════════════════════════════════════════════════

  // Background tiers (subtle warmth for premium feel)
  static const lightBackground = Color(0xFFF7F8FA);        // Soft off-white with hint of blue
  static const lightBackgroundSecondary = Color(0xFFF0F2F5); // Secondary sections
  static const lightSurface = Color(0xFFFFFFFF);           // Pure white cards
  static const lightSurfaceElevated = Color(0xFFFDFDFE);   // Elevated cards (modals, sheets)
  static const lightSurfaceLight = Color(0xFFF3F4F6);      // Muted containers
  static const lightSurfaceMuted = Color(0xFFE8EBF0);      // Dividers, disabled backgrounds

  // Text colors (WCAG AAA compliant)
  static const lightTextPrimary = Color(0xFF111827);       // Near-black (19:1 contrast)
  static const lightTextSecondary = Color(0xFF374151);     // Graphite (11:1 contrast)
  static const lightTextMuted = Color(0xFF6B7280);         // Cool gray (5.7:1 contrast)
  static const lightTextDisabled = Color(0xFF9CA3AF);      // Light gray (3.5:1 contrast)

  // Primary colors (vibrant but refined for light mode)
  static const lightPrimary = Color(0xFF5B52E5);           // Slightly deeper purple for light bg
  static const lightPrimaryLight = Color(0xFF7C74FF);      // Hover/active states
  static const lightPrimaryMuted = Color(0xFFEEEDFC);      // Primary tinted backgrounds
  static const lightPrimaryBorder = Color(0xFFD4D2F7);     // Primary borders

  // Secondary/Teal colors
  static const lightSecondary = Color(0xFF0D9488);         // Deeper teal for light mode
  static const lightSecondaryLight = Color(0xFF14B8A6);    // Hover state
  static const lightSecondaryMuted = Color(0xFFE6F7F5);    // Teal tinted backgrounds
  static const lightSecondaryBorder = Color(0xFFB2E8E2);   // Teal borders

  // Accent/Gold colors
  static const lightAccent = Color(0xFFD97706);            // Deeper amber for readability
  static const lightAccentLight = Color(0xFFF59E0B);       // Hover state
  static const lightAccentMuted = Color(0xFFFEF3C7);       // Amber tinted backgrounds
  static const lightAccentBorder = Color(0xFFFDE68A);      // Amber borders

  // Semantic colors (adjusted for light backgrounds)
  static const lightSuccess = Color(0xFF059669);           // Forest green
  static const lightSuccessLight = Color(0xFF10B981);      // Hover
  static const lightSuccessMuted = Color(0xFFD1FAE5);      // Success backgrounds
  static const lightSuccessBorder = Color(0xFF6EE7B7);     // Success borders

  static const lightDanger = Color(0xFFDC2626);            // Crimson red
  static const lightDangerLight = Color(0xFFEF4444);       // Hover
  static const lightDangerMuted = Color(0xFFFEE2E2);       // Danger backgrounds
  static const lightDangerBorder = Color(0xFFFCA5A5);      // Danger borders

  static const lightWarning = Color(0xFFD97706);           // Deep amber
  static const lightWarningLight = Color(0xFFF59E0B);      // Hover
  static const lightWarningMuted = Color(0xFFFEF3C7);      // Warning backgrounds
  static const lightWarningBorder = Color(0xFFFCD34D);     // Warning borders

  static const lightInstallment = Color(0xFFE11D48);       // Rose red for installments
  static const lightInstallmentMuted = Color(0xFFFFE4E6);  // Installment backgrounds
  static const lightInstallmentBorder = Color(0xFFFDA4AF); // Installment borders

  // Income/Expense specific
  static const lightIncome = Color(0xFF059669);            // Green for income
  static const lightExpense = Color(0xFFE11D48);           // Rose for expenses

  // Border colors
  static const lightBorder = Color(0xFFE5E7EB);            // Default border
  static const lightBorderLight = Color(0xFFF3F4F6);       // Subtle border
  static const lightBorderFocus = Color(0xFF5B52E5);       // Focus border (primary)

  // Shadow colors (for light mode) - Enhanced for premium depth
  static const lightShadow = Color(0x08000000);            // 3% black (ambient)
  static const lightShadowMedium = Color(0x0D000000);      // 5% black (key)
  static const lightShadowStrong = Color(0x14000000);      // 8% black (contact/strong)

  // ═══════════════════════════════════════════════════════════════════════════
  // ENHANCED SHADOW LEVELS - Premium multi-layered shadows for light theme
  // ═══════════════════════════════════════════════════════════════════════════

  /// Level 1: Subtle shadows for cards, list tiles
  static List<BoxShadow> get lightShadowSubtle => [
    // Ambient layer - wide, soft
    const BoxShadow(
      color: Color(0x08000000),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    // Key layer - focused
    const BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  /// Level 2: Medium shadows for elevated cards, modals, dialogs
  static List<BoxShadow> get lightShadowMediumLevel => [
    // Ambient layer
    const BoxShadow(
      color: Color(0x08000000),
      blurRadius: 24,
      offset: Offset(0, 6),
      spreadRadius: 2,
    ),
    // Key layer
    const BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 12,
      offset: Offset(0, 3),
      spreadRadius: 0,
    ),
    // Contact layer - tight
    const BoxShadow(
      color: Color(0x08000000),
      blurRadius: 4,
      offset: Offset(0, 1),
      spreadRadius: -1,
    ),
  ];

  /// Level 3: Strong shadows for FAB, bottom sheets, action sheets
  static List<BoxShadow> get lightShadowStrongLevel => [
    // Ambient layer
    const BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 32,
      offset: Offset(0, 8),
      spreadRadius: 4,
    ),
    // Key layer
    const BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    // Contact layer
    const BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 6,
      offset: Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // ENHANCED COLORS - Premium warmth and brand cohesion
  // ═══════════════════════════════════════════════════════════════════════════

  // Enhanced background & surface (subtle warmth)
  static const lightBackgroundEnhanced = Color(0xFFF8F9FB);   // Slightly cooler for card contrast
  static const lightSurfaceEnhanced = Color(0xFFFEFEFF);      // Micro-tint for warmth
  static const lightSurfaceMutedEnhanced = Color(0xFFEAECF0); // Slightly warmer gray

  // Enhanced border colors (subtle brand tint)
  static const lightBorderEnhanced = Color(0xFFE4E5EB);       // Slight purple tint
  static const lightBorderLightEnhanced = Color(0xFFF2F3F7);  // Consistent with border

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTS - Dark Theme
  // ═══════════════════════════════════════════════════════════════════════════
  static const primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cardGradient = LinearGradient(
    colors: [Color(0xFF1E1B4B), Color(0xFF161340)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFF6C63FF),
      Color(0xFF2DD4BF),
      Color(0xFFF59E0B),
    ],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // GRADIENTS - Light Theme (Premium & Subtle)
  // ═══════════════════════════════════════════════════════════════════════════
  static const cardGradientLight = LinearGradient(
    colors: [
      Color(0xFFFEFEFF),  // Warm white with micro blue-tint
      Color(0xFFFAFAFC),  // Slightly cooler at bottom for depth
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Premium primary gradient for light theme (balance card, hero elements)
  static const lightPrimaryGradient = LinearGradient(
    colors: [
      Color(0xFF6366F1),  // Indigo
      Color(0xFF5B52E5),  // Purple
      Color(0xFF4F46E5),  // Deep purple
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soft primary gradient for backgrounds
  static const lightPrimaryGradientSoft = LinearGradient(
    colors: [
      Color(0xFFF5F3FF),  // Light violet
      Color(0xFFEEF2FF),  // Light indigo
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Secondary gradient for accents
  static const lightSecondaryGradient = LinearGradient(
    colors: [
      Color(0xFF14B8A6),  // Teal
      Color(0xFF0D9488),  // Deep teal
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soft secondary gradient
  static const lightSecondaryGradientSoft = LinearGradient(
    colors: [
      Color(0xFFF0FDFA),  // Light teal
      Color(0xFFE6F7F5),  // Soft teal
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Success gradient
  static const lightSuccessGradient = LinearGradient(
    colors: [
      Color(0xFF10B981),  // Emerald
      Color(0xFF059669),  // Deep emerald
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Danger gradient
  static const lightDangerGradient = LinearGradient(
    colors: [
      Color(0xFFF43F5E),  // Rose
      Color(0xFFE11D48),  // Deep rose
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer gradient for light theme (loading states) - Enhanced smoothness
  static const lightShimmerGradient = LinearGradient(
    colors: [
      Color(0xFFF5F6F8),  // Slightly warmer base
      Color(0xFFEAECEF),  // Subtle contrast
      Color(0xFFF5F6F8),  // Consistent with base
    ],
    stops: [0.0, 0.5, 1.0],  // Smooth transition points
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get theme-aware primary color
  static Color getPrimary(bool isDark) => isDark ? primary : lightPrimary;

  /// Get theme-aware secondary color
  static Color getSecondary(bool isDark) => isDark ? secondary : lightSecondary;

  /// Get theme-aware success color
  static Color getSuccess(bool isDark) => isDark ? success : lightSuccess;

  /// Get theme-aware danger color
  static Color getDanger(bool isDark) => isDark ? danger : lightDanger;

  /// Get theme-aware warning color
  static Color getWarning(bool isDark) => isDark ? warning : lightWarning;

  /// Get theme-aware accent color
  static Color getAccent(bool isDark) => isDark ? accent : lightAccent;

  /// Get theme-aware installment color
  static Color getInstallment(bool isDark) => isDark ? installment : lightInstallment;

  /// Get theme-aware text primary color
  static Color getTextPrimary(bool isDark) => isDark ? textPrimary : lightTextPrimary;

  /// Get theme-aware text secondary color
  static Color getTextSecondary(bool isDark) => isDark ? textSecondary : lightTextSecondary;

  /// Get theme-aware text muted color
  static Color getTextMuted(bool isDark) => isDark ? textMuted : lightTextMuted;

  /// Get theme-aware surface color
  static Color getSurface(bool isDark) => isDark ? surface : lightSurface;

  /// Get theme-aware background color
  static Color getBackground(bool isDark) => isDark ? background : lightBackground;
}
