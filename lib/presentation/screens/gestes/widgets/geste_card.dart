import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/geste/geste_model.dart';
import '../../../../domain/enums/action_category.dart';

class GesteCard extends StatelessWidget {
  final GesteModel geste;
  final bool isDone;
  final VoidCallback? onTap;

  const GesteCard({
    super.key,
    required this.geste,
    this.isDone = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDone 
              ? (isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.primaryLight) 
              : (isDark ? AppColors.darkCard : AppColors.surface),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDone 
                ? AppColors.accent 
                : (isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.border),
            width: isDone ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    geste.category.color.withValues(alpha: 0.15),
                    geste.category.color.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    geste.category.icon,
                    color: geste.category.color,
                    size: 28,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          geste.title,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDone 
                                ? (isDark ? AppColors.primaryLight : AppColors.primary) 
                                : theme.colorScheme.onSurface,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                            decorationColor: isDark ? AppColors.primaryLight : AppColors.primary,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      if (geste.isDaily)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Quotidien',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: isDark ? Colors.white : AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    geste.description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.stars_rounded, size: 16, color: AppColors.warning),
                      const SizedBox(width: 6),
                      Text(
                        '+${geste.points} points',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warning,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: geste.category.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          geste.category.label,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: isDark ? geste.category.color.withValues(alpha: 0.9) : geste.category.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: isDone
                    ? LinearGradient(colors: [AppColors.primary, AppColors.accent])
                    : null,
                color: isDone ? null : (isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.primaryLight),
                borderRadius: BorderRadius.circular(14),
                border: isDone ? null : Border.all(color: isDark ? Colors.transparent : AppColors.accent, width: 1.5),
              ),
              child: Icon(
                isDone ? Icons.check_rounded : Icons.add_rounded,
                color: isDone ? Colors.white : (isDark ? Colors.white : AppColors.primary),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}