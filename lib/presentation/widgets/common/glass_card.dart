// lib/presentation/widgets/common/glass_card.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final glassColor = isDarkMode 
        ? AppColors.glassFillDark 
        : AppColors.glassFill;
    
    final glassBorderColor = isDarkMode
        ? AppColors.glassBorderDark
        : AppColors.glassBorder;
    
    final glassShadowColor = isDarkMode
        ? AppColors.glassShadowDark
        : AppColors.glassShadow;

    final widget = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: glassColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: glassBorderColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: glassShadowColor,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: widget,
      );
    }
    return widget;
  }
}