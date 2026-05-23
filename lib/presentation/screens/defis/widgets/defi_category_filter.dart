import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class DefiCategoryFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const DefiCategoryFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final List<Map<String, dynamic>> categories = const [
    {'label': 'Tous', 'icon': Icons.all_inclusive, 'color': AppColors.primary},
    {'label': 'Quotidien', 'icon': Icons.today, 'color': AppColors.success},
    {'label': 'Hebdomadaire', 'icon': Icons.calendar_today, 'color': AppColors.accent},
    {'label': 'Transport', 'icon': Icons.directions_bus, 'color': AppColors.warning},
    {'label': 'Alimentation', 'icon': Icons.restaurant, 'color': AppColors.error},
  ];

  Color _getColor(String label) {
    switch (label) {
      case 'Tous': return AppColors.primary;
      case 'Quotidien': return AppColors.success;
      case 'Hebdomadaire': return AppColors.accent;
      case 'Transport': return AppColors.warning;
      case 'Alimentation': return AppColors.error;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final label = cat['label'] as String;
          final icon = cat['icon'] as IconData;
          final isSelected = selected == label;
          final color = _getColor(label);

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onSelected(label);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [color, color.withValues(alpha: 0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : AppColors.surface,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppColors.border,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}