import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user/user_model.dart';

class LevelProgressCard extends StatelessWidget {
  final UserModel user;

  const LevelProgressCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final level = user.level as LevelModel;
    final progress = level.progressTo(user.totalPoints);
    final pointsLeft = level.pointsToNext(user.totalPoints);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: level.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(level.icon, color: level.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Niveau ${level.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      pointsLeft > 0
                          ? '$pointsLeft pts pour le niveau suivant'
                          : 'Niveau maximum atteint 🎉',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: level.color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Barre de progression
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(level.color),
              minHeight: 10,
            ),
          ),

          const SizedBox(height: 12),

          // Niveaux mini
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: LevelModel.levels.map((l) {
              final isReached = user.totalPoints >= l.minPoints;
              final isCurrent = l.type == level.type;
              return Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isReached
                          ? l.color.withValues(alpha: 0.2)
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(8),
                      border: isCurrent
                          ? Border.all(color: l.color, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        l.emoji,
                        style: TextStyle(
                          fontSize: isReached ? 16 : 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.name,
                    style: TextStyle(
                      fontSize: 9,
                      color: isReached
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: isCurrent
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}