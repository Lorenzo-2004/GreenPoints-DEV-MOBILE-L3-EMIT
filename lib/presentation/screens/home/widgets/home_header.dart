import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/user/user_model.dart';
import '../../../../l10n/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  final UserModel user;

  const HomeHeader({super.key, required this.user});

  String _greeting(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.home_greeting_morning;
    if (hour < 18) return l10n.home_greeting_afternoon;
    return l10n.home_greeting_evening;
  }

  void _shareProgress(BuildContext context) {
    Share.share(
      '🌱 GreenPoints - Ma progression !\n\n'
      '👤 ${user.name}\n'
      '⭐ ${user.totalPoints} points\n'
      '🔥 ${user.streak} jours de serie\n'
      '📊 ${user.weeklyPoints} points cette semaine\n\n'
      'Telecharge GreenPoints et deviens eco-responsable !',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 24,
        right: 24,
        bottom: 32,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _greeting(context),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.name.split(' ').first,
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _shareProgress(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.share_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      (user.level as LevelModel).icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _QuickStat(
                  icon: Icons.stars_rounded,
                  iconColor: AppColors.warning,
                  value: '${user.totalPoints}',
                  label: l10n.home_points,
                ),
                Container(width: 1, height: 30, color: Colors.white.withValues(alpha: 0.15)),
                _QuickStat(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: AppColors.warning,
                  value: '${user.streak}',
                  label: l10n.home_streak,
                  suffix: 'j',
                ),
                Container(width: 1, height: 30, color: Colors.white.withValues(alpha: 0.15)),
                _QuickStat(
                  icon: Icons.trending_up_rounded,
                  iconColor: AppColors.accent,
                  value: '${user.weeklyPoints}',
                  label: l10n.home_weekly,
                  suffix: 'pts',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final String? suffix;

  const _QuickStat({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (suffix != null) ...[
                    const SizedBox(width: 2),
                    Text(
                      suffix!,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
