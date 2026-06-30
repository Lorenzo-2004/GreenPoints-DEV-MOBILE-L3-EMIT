// lib/presentation/widgets/common/glass_card.dart
import 'dart:ui'; // Obligatoire pour ImageFilter
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double blur;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
    this.blur = 30.0, // Flou prononcé pour l'effet blanc laiteux
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Sélection des couleurs depuis ton AppColors corrigé
    final glassColor = isDarkMode 
        ? AppColors.glassFillDark 
        : AppColors.glassFill;
    
    final glassBorderColor = isDarkMode
        ? AppColors.glassBorderDark
        : AppColors.glassBorder;
    
    final glassShadowColor = isDarkMode
        ? AppColors.glassShadowDark
        : AppColors.glassShadow;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: glassShadowColor,
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: -5, // Rend l'ombre plus propre
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: padding ?? const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: glassColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: glassBorderColor,
                  width: 1.5,
                ),
                // Effet de reflet interne spéculaire (Syntaxe Flutter 2026)
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: isDarkMode ? 0.05 : 0.3),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}