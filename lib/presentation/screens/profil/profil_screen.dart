import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user/user_model.dart';
import '../../blocs/user/user_cubit.dart';
import 'widgets/profil_header.dart';
import 'widgets/level_badge.dart';
import 'widgets/stats_grid.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, user) {
        if (user == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ProfilHeader(user: user)
                  .animate()
                  .fadeIn(duration: 400.ms),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    LevelBadge(user: user)
                      .animate(delay: 100.ms)
                      .fadeIn()
                      .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 20),
                    StatsGrid(user: user)
                      .animate(delay: 200.ms)
                      .fadeIn()
                      .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 20),
                    _buildMenuSection(context, user),
                    const SizedBox(height: 80),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuSection(BuildContext context, UserModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _MenuTile(
            icon: Icons.shopping_bag_outlined,
            iconColor: AppColors.success,
            label: 'Boutique',
            subtitle: 'Échange tes points contre des récompenses',
            onTap: () => context.go('/marketplace'),
          ),
          const _Divider(),
          _MenuTile(
            icon: Icons.emoji_events_outlined,
            iconColor: AppColors.warning,
            label: 'Mes badges',
            subtitle: 'Découvre tes récompenses',
            onTap: () => context.go('/badges'),
          ),
          const _Divider(),
          _MenuTile(
            icon: Icons.notifications_outlined,
            iconColor: AppColors.accent,
            label: 'Notifications',
            subtitle: 'Historique des alertes',
            onTap: () => context.go('/notifications'),
          ),
          const _Divider(),
          _MenuTile(
            icon: Icons.history_rounded,
            iconColor: AppColors.info,
            label: 'Historique des points',
            subtitle: 'Voir toutes tes transactions',
            onTap: () => context.go('/points'),
          ),
          const _Divider(),
          _MenuTile(
            icon: Icons.settings_outlined,
            iconColor: AppColors.primary,
            label: 'Paramètres',
            subtitle: 'Personnaliser l\'application',
            onTap: () => context.go('/settings'),
          ),
          _MenuTile(
            icon: Icons.people_outlined,
            iconColor: AppColors.info,
            label: 'Social',
            subtitle: 'Classement et amis',
            onTap: () => context.go('/social'),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
        size: 20,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: AppColors.border,
    );
  }
}