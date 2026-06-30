import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user/user_model.dart';
import '../../../../l10n/app_localizations.dart';

class LevelBadge extends StatelessWidget {
  final UserModel user;

  const LevelBadge({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final level = user.level as LevelModel;
    final progress = level.progressTo(user.totalPoints);
    final pointsLeft = level.pointsToNext(user.totalPoints);
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: level.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(level.icon, color: level.color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n.level_title} ${level.name}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      pointsLeft > 0
                          ? '$pointsLeft ${l10n.level_points_next}'
                          : l10n.level_max,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: level.color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Barre de progression
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              widthFactor: progress,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [level.color, AppColors.accent],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}