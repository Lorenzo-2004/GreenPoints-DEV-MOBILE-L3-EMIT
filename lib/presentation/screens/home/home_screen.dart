import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../blocs/user/user_cubit.dart';
import 'widgets/home_header.dart';
import 'widgets/level_progress_card.dart';
import 'widgets/daily_gestes_section.dart';
import 'widgets/stats_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, user) {
        if (user == null) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<UserCubit>().refresh();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: HomeHeader(user: user).animate().fadeIn(duration: 400.ms),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 20),
                      StatsRow(user: user).animate(delay: 80.ms).fadeIn().slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 20),
                      LevelProgressCard(user: user).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 24),
                      DailyGestesSection(user: user).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2, end: 0),
                      const SizedBox(height: 20),
                      _buildQuickActions(context, user),
                      const SizedBox(height: 80),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.go('/valider'),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context, UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions rapides',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _QuickActionButton(
              icon: Icons.eco_rounded,
              label: 'Gestes',
              color: AppColors.success,
              onTap: () => context.go('/gestes'),
            ),
            const SizedBox(width: 12),
            _QuickActionButton(
              icon: Icons.flag_rounded,
              label: 'Defis',
              color: AppColors.accent,
              onTap: () => context.go('/defis'),
            ),
            const SizedBox(width: 12),
            _QuickActionButton(
              icon: Icons.shopping_bag_rounded,
              label: 'Boutique',
              color: AppColors.warning,
              onTap: () => context.go('/marketplace'),
            ),
            const SizedBox(width: 12),
            _QuickActionButton(
              icon: Icons.share_rounded,
              label: 'Partager',
              color: AppColors.info,
              onTap: () => _shareProgress(context, user),
            ),
          ],
        ),
      ],
    );
  }

  void _shareProgress(BuildContext context, UserModel user) {
    Share.share(
      'GreenPoints - Ma progression !\n\n'
      '${user.name}\n'
      '${user.totalPoints} points\n'
      '${user.streak} jours de serie\n'
      '${user.weeklyPoints} points cette semaine\n\n'
      'Telecharge GreenPoints et deviens eco-responsable !',
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}