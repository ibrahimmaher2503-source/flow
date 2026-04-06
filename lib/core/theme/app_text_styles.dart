import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  static const display = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const sectionTitle = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const cardTitle = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const body = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const caption = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textMuted,
  );

  static const amountPlus = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.secondary,
  );

  static const amountMinus = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.danger,
  );

  static const amountDebt = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.installment,
  );
}
