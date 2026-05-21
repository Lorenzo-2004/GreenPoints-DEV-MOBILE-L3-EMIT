import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary       = Color(0xFF2563EB);
  static const Color primaryDark   = Color(0xFF1D4ED8);
  static const Color primaryLight  = Color(0xFFDBEAFE);

  static const Color accent        = Color(0xFF3B82F6);

  static const Color night         = Color(0xFF111827);
  static const Color darkSurface   = Color(0xFF1F2937);

  static const Color white         = Color(0xFFFFFFFF);
  static const Color softWhite     = Color(0xFFF9FAFB);
  static const Color cardWhite     = Color(0xFFFFFFFF);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFFDBEAFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF111827), Color(0xFF1F2937)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF3F4F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color level1 = Color(0xFFDBEAFE);
  static const Color level2 = Color(0xFFBFDBFE);
  static const Color level3 = Color(0xFF93C5FD);
  static const Color level4 = Color(0xFF60A5FA);
  static const Color level5 = Color(0xFF3B82F6);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);
  static const Color info    = Color(0xFF3B82F6);

  static const Color background = Color(0xFFF9FAFB);
  static const Color surface    = Color(0xFFFFFFFF);

  static const Color textPrimary   = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color border = Color(0xFFE5E7EB);

  static const Color shadow = Color(0x1A000000);

  static const Color glass = Color(0x33FFFFFF);
}