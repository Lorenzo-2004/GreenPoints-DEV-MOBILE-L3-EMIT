import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class RewardCard extends StatelessWidget {
  final dynamic reward;
  final bool canAfford;
  final VoidCallback onTap;

  const RewardCard({
    super.key,
    required this.reward,
    required this.canAfford,
    required this.onTap,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'local_florist': return Icons.local_florist;
      case 'water_bottle': return Icons.water_drop;
      case 'shopping_bag': return Icons.shopping_bag;
      case 'yard': return Icons.yard;
      case 'emoji_events': return Icons.emoji_events;
      default: return Icons.card_giftcard;
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconData = _getIconData(reward.icon);
    final isLowStock = reward.stock < 5 && reward.stock > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: canAfford ? AppColors.primary : Theme.of(context).dividerColor,
            width: canAfford ? 1.5 : 1,
          ),
          boxShadow: canAfford
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(iconData, color: AppColors.primary, size: 24),
                ),
                if (isLowStock)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Stock: ${reward.stock}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              reward.title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              reward.description,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Icon(Icons.stars_rounded, size: 14, color: AppColors.warning),
                const SizedBox(width: 4),
                Text(
                  '${reward.points} pts',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: canAfford ? AppColors.warning : (Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}