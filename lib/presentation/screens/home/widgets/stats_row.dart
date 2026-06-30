import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user/user_model.dart';
import '../../../../l10n/app_localizations.dart';

class StatsRow extends StatelessWidget {
  final UserModel user;

  const StatsRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        _StatCard(
          icon: Icons.stars_rounded,
          iconColor: const Color(0xFFFFD700),
          bgColor: const Color(0xFFFFFBEB),
          label: l10n.home_points,
          value: '${user.totalPoints}',
          unit: 'pts',
          accent: const Color(0xFFF59E0B),
          onTap: () => context.go('/points'),
        ),
        const SizedBox(width: 10),
        _StatCard(
          icon: Icons.local_fire_department_rounded,
          iconColor: const Color(0xFFFF6B35),
          bgColor: const Color(0xFFFFF4EF),
          label: l10n.home_streak,
          value: '${user.streak}',
          unit: 'jours',
          accent: const Color(0xFFFF6B35),
          onTap: () => _showStreakDetails(context),
        ),
        const SizedBox(width: 10),
        _StatCard(
          icon: Icons.trending_up_rounded,
          iconColor: const Color(0xFF059669),
          bgColor: const Color(0xFFECFDF5),
          label: l10n.home_weekly,
          value: '${user.weeklyPoints}',
          unit: 'pts',
          accent: const Color(0xFF059669),
          onTap: () => context.go('/points'),
        ),
      ],
    );
  }

  void _showStreakDetails(BuildContext context) {
    final theme = Theme.of(context);
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
            Text('${l10n.home_streak} - Details', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _detailRow(context, '${l10n.home_streak} actuelle', '${user.streak} jours'),
            _detailRow(context, 'Meilleure ${l10n.home_streak.toLowerCase()}', '${user.streak} jours'),
            const SizedBox(height: 8),
            Text('Continue chaque jour pour augmenter ta serie !', style: GoogleFonts.poppins(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final Color accent;
  final String label;
  final String value;
  final String unit;
  final VoidCallback onTap;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.accent,
    required this.label,
    required this.value,
    required this.unit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withValues(alpha: 0.2) : accent.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isDark ? accent.withValues(alpha: 0.2) : bgColor,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.5,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$label · $unit',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}