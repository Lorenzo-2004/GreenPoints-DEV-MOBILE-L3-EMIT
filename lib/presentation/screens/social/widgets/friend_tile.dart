import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class FriendTile extends StatelessWidget {
  final dynamic friend;
  final VoidCallback? onTap;

  const FriendTile({
    super.key,
    required this.friend,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.glassFillDark : AppColors.glassFillVibrant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.glassBorderDark : AppColors.glassBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.glassShadowDark : AppColors.glassShadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isDark ? AppColors.glassBorderDark : AppColors.glassBorder,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  friend.name != null && friend.name.toString().isNotEmpty 
                      ? friend.name[0].toUpperCase() 
                      : '?',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${friend.totalPoints} points',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDark ? AppColors.textSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.chevron_right,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}