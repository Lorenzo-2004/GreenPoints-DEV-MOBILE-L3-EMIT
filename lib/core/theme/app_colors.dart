import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primaires Emerald Modern
  static const Color primary       = Color(0xFF059669);
  static const Color primaryDark   = Color(0xFF064E3B);
  static const Color primaryLight  = Color(0xFFD1FAE5);
  static const Color accent        = Color(0xFF34D399);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF064E3B), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF0D9488)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Niveaux
  static const Color levelGraine   = Color(0xFFD1FAE5);
  static const Color levelPousse   = Color(0xFF6EE7B7);
  static const Color levelRameau   = Color(0xFF34D399);
  static const Color levelArbre    = Color(0xFF059669);
  static const Color levelForet    = Color(0xFF047857);
  static const Color levelGardien  = Color(0xFF064E3B);

  // Sémantiques
  static const Color success       = Color(0xFF059669);
  static const Color warning       = Color(0xFFF59E0B);
  static const Color error         = Color(0xFFDC2626);
  static const Color info          = Color(0xFF0C447C);

  // Neutres
  static const Color background    = Color(0xFFF8FAFC);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color textPrimary   = Color(0xFF1A1A18);
  static const Color textSecondary = Color(0xFF6B6B67);
  static const Color border        = Color(0xFFE2DFD8);
}