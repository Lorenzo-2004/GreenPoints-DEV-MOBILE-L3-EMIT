import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primaires — Gradient 3 couleurs bleu
  static const Color primary      = Color(0xFF1E40AF); // bleu profond
  static const Color primaryMid   = Color(0xFF3B82F6); // bleu vif
  static const Color primaryLight = Color(0xFF93C5FD); // bleu clair

  static const Color primaryDark  = Color(0xFF1E3A8A); // bleu très foncé
  static const Color accent       = Color(0xFF60A5FA); // bleu accent

  // ── Mode sombre
  static const Color night        = Color(0xFF0A0A0A); // fond très foncé (iOS 26)
  static const Color darkSurface  = Color(0xFF1C1C1E); // surface foncée (iOS 26)
  static const Color darkCard     = Color(0xFF2C2C2E); // carte foncée

  // ── Gradients 
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF1E3A8A), // bleu nuit
      Color(0xFF2563EB), // bleu roi
      Color(0xFF60A5FA), // bleu ciel
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [
      Color(0xFF1E3A8A),
      Color(0xFF2563EB),
      Color(0xFF60A5FA),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient subtleGradient = LinearGradient(
    colors: [
      Color(0xFFEFF6FF), // bleu 50
      Color(0xFFDBEAFE), // bleu 100
      Color(0xFFBFDBFE), // bleu 200
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF0F7FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Glassmorphism (style iOS 26)
  static const Color glassFill         = Color(0xCCFFFFFF); // 80% blanc
  static const Color glassFillSubtle   = Color(0xB3FFFFFF); // 70% blanc
  static const Color glassFillDark     = Color(0x33FFFFFF); // 20% blanc (sur fond sombre)
  static const Color glassFillVibrant  = Color(0xE6FFFFFF); // 90% blanc (vibrant)

  // Bordure glass — effet de flou
  static const Color glassBorder       = Color(0x66FFFFFF); // 40% blanc
  static const Color glassBorderLight  = Color(0x80FFFFFF); // 50% blanc
  static const Color glassBorderSubtle = Color(0x33DBEAFE); // 20% bleu 100
  static const Color glassBorderDark   = Color(0x33FFFFFF); // 20% blanc (fond sombre)

  // Ombre glass bleue
  static const Color glassShadow       = Color(0x1A2563EB); // 10% bleu
  static const Color glassShadowDeep   = Color(0x332563EB); // 20% bleu
  static const Color glassShadowDark   = Color(0x1AFFFFFF); // 10% blanc (fond sombre)

  // ── Niveaux 
  static const Color level1 = Color(0xFFDBEAFE);
  static const Color level2 = Color(0xFF93C5FD);
  static const Color level3 = Color(0xFF3B82F6);
  static const Color level4 = Color(0xFF2563EB);
  static const Color level5 = Color(0xFF1E3A8A);

  // ── Sémantiques 
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);
  static const Color info    = Color(0xFF3B82F6);

  // ── Surfaces & fond 
  static const Color background    = Color(0xFFFFFFFF); // fond blanc pur
  static const Color backgroundAlt = Color(0xFFF8FAFF); // blanc teinté bleu
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color surfaceAlt    = Color(0xFFF0F7FF); // bleu 50 clair

  // ── Textes 
  static const Color textPrimary   = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary  = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark    = Color(0xFFF0F0F0); // texte sur fond sombre

  // ── Bordures & ombres 
  static const Color border       = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFDBEAFE);
  static const Color shadow       = Color(0x0F0F172A);
}