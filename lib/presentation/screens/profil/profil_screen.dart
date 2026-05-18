import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user/user_model.dart';  
import '../../blocs/user/user_cubit.dart';
import 'widgets/profil_header.dart';
import 'widgets/level_badge.dart';
import 'widgets/stats_grid.dart';
import 'widgets/settings_section.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, user) {
        // Afficher un loader pendant le chargement
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
                    const SettingsSection()
                      .animate(delay: 300.ms)
                      .fadeIn()
                      .slideY(begin: 0.2, end: 0),
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
}