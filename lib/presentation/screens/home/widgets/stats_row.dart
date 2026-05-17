import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user/user_model.dart';

class StatsRow extends StatelessWidget {
  final UserModel user;

  const StatsRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          icon: Icons.star_rounded,
          iconColor: const Color(0xFFF5A800),
          label: 'Total',
          value: '${user.totalPoints}',
          unit: 'pts',
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.calendar_today_rounded,
          iconColor: AppColors.info,
          label: 'Cette semaine',
          value: '${user.weeklyPoints}',
          unit: 'pts',
        ),
        const SizedBox(width: 12),
        _StatCard(
          icon: Icons.local_fire_department_rounded,
          iconColor: AppColors.warning,
          label: 'Série',
          value: '${user.streak}',
          unit: 'jours',
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}