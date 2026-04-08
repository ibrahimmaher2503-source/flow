import 'package:flutter/material.dart';

abstract class AppColors {
  // Dark theme colors (existing)
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

  // Light theme colors (new) - WCAG AA compliant
  static const lightBackground = Color(0xFFF8F9FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceLight = Color(0xFFF1F3F5);
  static const lightTextPrimary = Color(0xFF1A1A1A);  // 16.9:1 on lightBackground (AAA)
  static const lightTextSecondary = Color(0xFF4B5563);  // 7.7:1 on lightBackground (AAA)
  static const lightTextMuted = Color(0xFF5F6B7D);  // 5.3:1 on lightBackground (AA)

  // Gradients (dark theme)
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

  // Gradients (light theme)
  static const cardGradientLight = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF1F3F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
