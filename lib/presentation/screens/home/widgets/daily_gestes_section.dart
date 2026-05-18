import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            Text(
              'Gestes du jour',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () => context.go('/gestes'),
              child: Text(
                'Voir tout',
                style: GoogleFonts.poppins(
                  fontSize: 13,
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
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
        border: isDone
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.2))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isDone
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : geste.category.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              isDone ? Icons.check_circle_rounded : geste.category.icon,
              color: isDone ? AppColors.primary : geste.category.color,
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
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDone
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    decoration: isDone
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: AppColors.textSecondary,
                  ),
                ),
                Text(
                  geste.description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isDone
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : const Color(0xFFFFF8E7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isDone ? 'Fait' : '+${geste.points}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDone
                    ? AppColors.primary
                    : const Color(0xFFF5A800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}