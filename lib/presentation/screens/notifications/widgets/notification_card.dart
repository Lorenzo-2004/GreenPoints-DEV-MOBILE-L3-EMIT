import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/notification/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        if (diff.inMinutes == 0) return 'A l instant';
        return 'Il y a ${diff.inMinutes} min';
      }
      return 'Il y a ${diff.inHours} h';
    } else if (diff.inDays == 1) {
      return 'Hier';
    } else if (diff.inDays < 7) {
      return 'Il y a ${diff.inDays} j';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead 
              ? (isDark ? AppColors.glassFillDark : AppColors.glassFill)
              : (isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.primaryLight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: notification.isRead 
                ? (isDark ? AppColors.glassBorderDark : AppColors.glassBorder)
                : AppColors.primary,
            width: notification.isRead ? 1 : 1.5,
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: notification.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: notification.color.withValues(alpha: 0.2),
                  width: 0.5,
                ),
              ),
              child: Icon(
                notification.icon,
                color: notification.color,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: notification.isRead
                          ? (isDark ? AppColors.textOnDark : AppColors.textPrimary)
                          : AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondary : AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatDate(notification.createdAt),
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: isDark ? AppColors.textSecondary.withValues(alpha: 0.7) : AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}