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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: badge.isUnlocked ? AppColors.surface : AppColors.surface.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: badge.isUnlocked ? badge.color : AppColors.border,
            width: badge.isUnlocked ? 1.5 : 1,
          ),
          boxShadow: badge.isUnlocked
              ? [
                  BoxShadow(
                    color: badge.color.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
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
                    color: badge.isUnlocked ? null : AppColors.border,
                    shape: BoxShape.circle,
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
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: badge.isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              badge.description,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.textSecondary,
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
                    : AppColors.border,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badge.isUnlocked ? 'DeBloque' : badge.progressText,
                style: GoogleFonts.poppins(
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