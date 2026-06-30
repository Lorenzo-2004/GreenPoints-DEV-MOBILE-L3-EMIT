import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/badge/badge_model.dart';

class BadgeCard extends StatelessWidget {
  final BadgeModel badge;
  final VoidCallback? onTap;

  const BadgeCard({
    super.key,
    required this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: badge.isUnlocked 
              ? (isDark ? AppColors.glassFillDark : AppColors.glassFillVibrant)
              : (isDark ? AppColors.darkCard : AppColors.glassFill),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: badge.isUnlocked 
                ? badge.color 
                : (isDark ? AppColors.glassBorderDark : AppColors.glassBorder),
            width: badge.isUnlocked ? 1.5 : 1,
          ),
          boxShadow: badge.isUnlocked
              ? [
                  BoxShadow(
                    color: badge.color.withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: isDark ? AppColors.glassShadowDark : AppColors.glassShadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: badge.isUnlocked
                        ? LinearGradient(
                            colors: [badge.color, badge.color.withValues(alpha: 0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: badge.isUnlocked ? null : (isDark ? AppColors.darkCard : AppColors.border),
                    shape: BoxShape.circle,
                    border: badge.isUnlocked
                        ? Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5)
                        : null,
                  ),
                  child: Icon(
                    badge.icon,
                    size: 36,
                    color: badge.isUnlocked ? Colors.white : AppColors.textSecondary,
                  ),
                ),
                if (!badge.isUnlocked)
                  const Icon(
                    Icons.lock_outline,
                    size: 24,
                    color: AppColors.textSecondary,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              badge.title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: badge.isUnlocked 
                    ? (isDark ? AppColors.textOnDark : AppColors.textPrimary) 
                    : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              badge.description,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isDark ? AppColors.textSecondary : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: badge.isUnlocked
                    ? badge.color.withValues(alpha: 0.12)
                    : (isDark ? AppColors.glassBorderDark : AppColors.border),
                borderRadius: BorderRadius.circular(12),
                border: badge.isUnlocked
                    ? Border.all(color: badge.color.withValues(alpha: 0.2), width: 0.5)
                    : null,
              ),
              child: Text(
                badge.isUnlocked ? 'Debloque' : badge.progressText,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: badge.isUnlocked ? badge.color : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}