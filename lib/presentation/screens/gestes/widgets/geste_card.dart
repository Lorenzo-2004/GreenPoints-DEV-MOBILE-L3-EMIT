import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDone ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDone ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            // Icône catégorie
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: geste.category.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    geste.category.icon,
                    color: geste.category.color,
                    size: 24,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            // Texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          geste.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDone
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            decoration: isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                      ),
                      if (geste.isDaily)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Quotidien',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    geste.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.stars_rounded,
                        size: 14,
                        color: const Color(0xFFF5A800),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${geste.points} points',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF5A800),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        geste.category.label,
                        style: TextStyle(
                          fontSize: 11,
                          color: geste.category.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Bouton valider
            isDone
                ? Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                : Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.accent),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}