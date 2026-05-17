import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user/user_model.dart';
import '../../../../data/models/geste/geste_model.dart';
import '../../../../domain/enums/action_category.dart';

class DailyGestesSection extends StatelessWidget {
  final UserModel user;

  const DailyGestesSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final gestes = GesteModel.defaults
        .where((g) => g['isDaily'] == true)
        .take(4)
        .map((g) => GesteModel.fromMap(g, g['id']))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Gestes du jour',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/gestes'),
              child: const Text(
                'Voir tout',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...gestes.map((geste) {
          final isDone = user.completedActionIds.contains(geste.id);
          return _GesteCard(geste: geste, isDone: isDone);
        }),
      ],
    );
  }
}

class _GesteCard extends StatelessWidget {
  final GesteModel geste;
  final bool isDone;

  const _GesteCard({required this.geste, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDone
            ? AppColors.primaryLight
            : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? AppColors.accent : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: geste.category.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              geste.category.icon,
              color: geste.category.color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  geste.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDone
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    decoration: isDone
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                Text(
                  geste.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDone
                  ? AppColors.primary
                  : const Color(0xFFF5A800).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isDone ? '✓' : '+${geste.points}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDone
                    ? Colors.white
                    : const Color(0xFFF5A800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}