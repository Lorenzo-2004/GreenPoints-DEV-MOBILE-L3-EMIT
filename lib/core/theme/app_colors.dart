import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primaires — Gradient iOS 26 Ultra-Visible
  static const Color primary       = Color(0xFF0052FF); // Bleu Électrique
  static const Color primaryMid    = Color(0xFF00C2FF); // Cyan Vibrant
  static const Color primaryLight  = Color(0xFF7000FF); // Violet Royal

  static const Color primaryDark   = Color(0xFF002885); 
  static const Color accent        = Color(0xFF00F0FF); 

  // ── Mode sombre (iOS 26 Deep Black)
  static const Color night         = Color(0xFF000000); 
  static const Color darkSurface   = Color(0xFF121214); 
  static const Color darkCard      = Color(0xFF1C1C1E); 

  // ── Gradients (Visibilité Maximale)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF0033FF),
      Color(0xFF00D1FF),
      Color(0xFF7000FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.1, 0.6, 1.0],
  );

  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [
      Color(0xFF0033FF),
      Color(0xFF00D1FF),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient subtleGradient = LinearGradient(
    colors: [
      Color(0xFFF0F7FF),
      Color(0xFFDBEAFE),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Glassmorphism (Style iOS 26 Crystal)
  static const Color glassFill         = Color(0x1AFFFFFF); // 10% blanc
  static const Color glassFillSubtle   = Color(0x0DFFFFFF); // 5% blanc
  static const Color glassFillDark     = Color(0x33000000); // 20% noir
  static const Color glassFillVibrant  = Color(0x4DFFFFFF); // 30% blanc

  static const Color glassBorder       = Color(0x80FFFFFF); // 50% blanc
  static const Color glassBorderLight  = Color(0x4DFFFFFF); // 30% blanc
  static const Color glassBorderSubtle = Color(0x1AFFFFFF); // 10% blanc
  static const Color glassBorderDark   = Color(0x26FFFFFF); // 15% blanc

  static const Color glassShadow       = Color(0x330033FF); 
  static const Color glassShadowDeep   = Color(0x4D000000); 
  static const Color glassShadowDark   = Color(0x66000000);

  // ── Niveaux 
  static const Color level1 = Color(0xFFE0F2FE);
  static const Color level2 = Color(0xFF7DD3FC);
  static const Color level3 = Color(0xFF38BDF8);
  static const Color level4 = Color(0xFF0EA5E9);
  static const Color level5 = Color(0xFF0369A1);

  // ── Sémantiques 
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);
  static const Color info    = Color(0xFF00D1FF);

  // ── Surfaces & fond 
  static const Color background    = Color(0xFFFFFFFF); 
  static const Color backgroundAlt = Color(0xFFF8FAFF); 
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color surfaceAlt    = Color(0xFFF0F9FF); 

  // ── Textes 
  static const Color textPrimary   = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary  = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark    = Color(0xFFF8FAFF); 

  // ── Bordures & ombres 
  static const Color border        = Color(0xFFE2E8F0);
  static const Color borderSubtle  = Color(0xFFF1F5F9);
  static const Color shadow        = Color(0x1A0F172A);
}