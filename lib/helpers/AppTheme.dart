import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFD4B8E0);
  static const Color cardBackground = Color(0xFFE8D5F5);
  static const Color primary = Color(0xFF7C3AED);
  static const Color accent = Color(0xFFF5E642);
  static const Color accent_grey = Color(0xFF535457);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGrey = Color(0xFF6B7280);
  static const Color correct = Color(0xFFEF4444);
  static const Color optionBorder = Color(0xFFBB86FC);
  static const Color inputFill = Color(0xFFF3E8FF);
  static const Color divider = Color(0xFFE0C8F0);
  static const Color successGreen = Color(0xFF22C55E);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color tileUnselected = Color(0xFFF9F0FF);
  static const Color tileBorderUnselected = Color(0xFFDDD0EC);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 26,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textGrey,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 16,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0.5,
  );
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    fontFamily: 'Nunito',
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
    ),
  );
}
