import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user/user_model.dart';
import '../../../../l10n/app_localizations.dart';

class StatsGrid extends StatelessWidget {
  final UserModel user;

  const StatsGrid({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              l10n.stats_title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.8,
          children: [
            _StatTile(
              icon: Icons.stars_rounded,
              iconColor: AppColors.warning,
              label: l10n.stats_points_total,
              value: '${user.totalPoints}',
              suffix: 'pts',
            ),
            _StatTile(
              icon: Icons.local_fire_department_rounded,
              iconColor: AppColors.warning, 
              label: l10n.stats_streak,
              value: '${user.streak}',
              suffix: 'j',
            ),
            _StatTile(
              icon: Icons.trending_up_rounded,
              iconColor: AppColors.accent,
              label: l10n.stats_points_week,
              value: '${user.weeklyPoints}',
              suffix: 'pts',
            ),
            _StatTile(
              icon: Icons.check_circle_rounded,
              iconColor: AppColors.success,
              label: l10n.stats_gestures_done,
              value: '${user.completedActionIds.length}',
              suffix: '',
            ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String suffix;

  const _StatTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
                      ),
                    ),
                    if (suffix.isNotEmpty) ...[
                      const SizedBox(width: 2),
                      Text(
                        suffix,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}