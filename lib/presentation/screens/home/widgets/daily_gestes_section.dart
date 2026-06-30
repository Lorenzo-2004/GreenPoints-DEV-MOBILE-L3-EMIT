import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user/user_model.dart';
import '../../../../data/models/geste/geste_model.dart';
import '../../../../data/services/geste_service.dart';
import '../../../../domain/enums/action_category.dart';
import '../../../../l10n/app_localizations.dart';

class DailyGestesSection extends StatelessWidget {
  final UserModel user;

  const DailyGestesSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return FutureBuilder<List<GesteModel>>(
      future: GesteService().getAllGestes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final allGestes = snapshot.data ?? [];
        final gestes = allGestes.where((g) => g.isDaily).take(4).toList();

        final doneCount = gestes
            .where((g) => user.completedActionIds.contains(g.id))
            .length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.home_gestures_of_day,
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                    Text(
                      '$doneCount / ${gestes.length} ${l10n.home_completed}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => context.go('/gestes'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.home_see_all,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ...gestes.asMap().entries.map((entry) {
              final geste = entry.value;
              final isDone = user.completedActionIds.contains(geste.id);
              return _GesteCard(geste: geste, isDone: isDone);
            }),
          ],
        );
      }
    );
  }
}

class _GesteCard extends StatelessWidget {
  final GesteModel geste;
  final bool isDone;

  const _GesteCard({required this.geste, required this.isDone});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: isDone 
          ? null 
          : () {
              HapticFeedback.lightImpact();
              context.go('/valider', extra: geste);
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDone
              ? AppColors.success.withValues(alpha: 0.05)
              : (isDark ? AppColors.darkCard : AppColors.surface),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDone
                ? AppColors.success.withValues(alpha: 0.3)
                : (isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.border),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isDone ? AppColors.success.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.03),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isDone ? AppColors.success.withValues(alpha: 0.1) : geste.category.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                isDone ? Icons.check_circle_outline_rounded : geste.category.icon,
                color: isDone ? AppColors.success : geste.category.color,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    geste.title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDone ? theme.colorScheme.onSurface.withValues(alpha: 0.5) : theme.colorScheme.onSurface,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      decorationColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    geste.description,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isDone ? AppColors.success.withValues(alpha: 0.1) : AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isDone ? l10n.home_done : '+${geste.points}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isDone ? AppColors.success : AppColors.warning,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}