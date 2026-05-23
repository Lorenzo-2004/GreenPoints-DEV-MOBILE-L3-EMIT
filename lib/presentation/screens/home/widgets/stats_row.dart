import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
          icon: Icons.stars_rounded,
          iconColor: const Color(0xFFFFD700),
          bgColor: const Color(0xFFFFFBEB),
          label: 'Total',
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
          label: 'Série',
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
          label: 'Semaine',
          value: '${user.weeklyPoints}',
          unit: 'pts',
          accent: const Color(0xFF059669),
          onTap: () => context.go('/points'),
        ),
      ],
    );
  }

  void _showStreakDetails(BuildContext context) {
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
            Text('Details de la serie', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _detailRow('Serie actuelle', '${user.streak} jours'),
            _detailRow('Meilleure serie', '${user.streak} jours'),
            const SizedBox(height: 8),
            Text('Continue chaque jour pour augmenter ta serie !', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fermer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
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
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.08),
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
                  color: bgColor,
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
                  color: const Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$label · $unit',
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: const Color(0xFF9CA3AF),
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