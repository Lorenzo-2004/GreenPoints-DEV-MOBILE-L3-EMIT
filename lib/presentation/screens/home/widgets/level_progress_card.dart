import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user/user_model.dart';
import '../../../../l10n/app_localizations.dart';

class LevelProgressCard extends StatelessWidget {
  final UserModel user;

  const LevelProgressCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    final level = user.level as LevelModel;
    final progress = level.progressTo(user.totalPoints);
    final pointsLeft = level.pointsToNext(user.totalPoints);
    final nextLevel = _getNextLevel(level);

    return GestureDetector(
      onTap: () => _showLevelDetails(context, level, user.totalPoints, pointsLeft, nextLevel),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : level.color.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [level.color, level.color.withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: level.color.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(level.icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.home_level} ${level.name}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        pointsLeft > 0
                            ? '$pointsLeft pts → ${nextLevel?.name ?? ""}'
                            : l10n.home_max_level,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: level.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${(progress * 100).toInt()}%',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: level.color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.border,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [level.color, AppColors.accent],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: level.color.withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: LevelModel.levels.map((l) {
                final isReached = user.totalPoints >= l.minPoints;
                final isCurrent = l.type == level.type;
                return _LevelDot(
                  level: l,
                  isReached: isReached,
                  isCurrent: isCurrent,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  LevelModel? _getNextLevel(LevelModel current) {
    final index = LevelModel.levels.indexOf(current);
    if (index < LevelModel.levels.length - 1) {
      return LevelModel.levels[index + 1];
    }
    return null;
  }

  void _showLevelDetails(BuildContext context, LevelModel level, int points, int pointsLeft, LevelModel? nextLevel) {
    final l10n = AppLocalizations.of(context)!;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Details du niveau', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _detailRow(context, 'Niveau actuel', level.name),
            _detailRow(context, 'Points actuels', '$points'),
            if (pointsLeft > 0) ...[
              _detailRow(context, 'Points restants', '$pointsLeft'),
              _detailRow(context, 'Prochain niveau', nextLevel?.name ?? ''),
            ] else
              _detailRow(context, 'Statut', 'Niveau maximum atteint !'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.common_close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
        ],
      ),
    );
  }
}

class _LevelDot extends StatelessWidget {
  final LevelModel level;
  final bool isReached;
  final bool isCurrent;

  const _LevelDot({
    required this.level,
    required this.isReached,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isCurrent ? 44 : 38,
          height: isCurrent ? 44 : 38,
          decoration: BoxDecoration(
            gradient: isReached
                ? LinearGradient(
                    colors: [level.color, level.color.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isReached ? null : (isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.border),
            borderRadius: BorderRadius.circular(isCurrent ? 14 : 11),
            border: isCurrent ? Border.all(color: level.color, width: 2.5) : null,
            boxShadow: isCurrent
                ? [
                    BoxShadow(
                      color: level.color.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            level.icon,
            size: isCurrent ? 22 : 18,
            color: isReached ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          level.name,
          style: GoogleFonts.poppins(
            fontSize: 9,
            color: isReached ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}