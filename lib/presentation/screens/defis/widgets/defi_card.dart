import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class DefiCard extends StatelessWidget {
  final Map<String, dynamic> defi;
  final VoidCallback onTap;

  const DefiCard({
    super.key,
    required this.defi,
    required this.onTap,
  });

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'eco':
        return Icons.eco_rounded;
      case 'directions_bike':
        return Icons.directions_bike_rounded;
      case 'recycling':
        return Icons.recycling_rounded;
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'water_drop':
        return Icons.water_drop_rounded;
      default:
        return Icons.emoji_events_rounded;
    }
  }

  Color _getColorFromHex(String hexColor) {
    String hex = hexColor.toUpperCase().replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF\$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final iconString = defi['icon'] as String? ?? 'eco';
    final iconData = _getIconFromString(iconString);

    final rawColor = defi['color'];
    Color color;
    if (rawColor is Color) {
      color = rawColor;
    } else if (rawColor is String) {
      color = _getColorFromHex(rawColor);
    } else {
      color = AppColors.primary;
    }

    final progress = (defi['progress'] as num?)?.toDouble() ?? 0.0;
    final isCompleted = progress >= 1.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withValues(alpha: 0.7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(iconData, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              defi['title'] as String? ?? '',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              defi['subtitle'] as String? ?? '',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.stars_rounded, size: 14, color: AppColors.warning),
                            const SizedBox(width: 4),
                            Text(
                              '+${defi['points']}',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.access_time_rounded, size: 12, color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${defi['daysLeft']}j restants',
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FractionallySizedBox(
                                widthFactor: progress,
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [color, color.withValues(alpha: 0.7)],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      defi['category'] as String? ?? '',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    isCompleted ? 'Termine !' : 'Continuer',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    isCompleted ? Icons.check_circle_rounded : Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: color,
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