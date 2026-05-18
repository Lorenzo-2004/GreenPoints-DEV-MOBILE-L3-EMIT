import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user/user_model.dart';
import 'widgets/profil_header.dart';
import 'widgets/level_badge.dart';
import 'widgets/stats_grid.dart';
import 'widgets/settings_section.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  static final _mockUser = UserModel.fromMap({
    'name': 'Lorenzo Rakoto',
    'email': 'lorenzo@email.com',
    'phoneNumber': '+261 34 00 000 00',
    'totalPoints': 340,
    'weeklyPoints': 85,
    'streak': 5,
    'completedActionIds': ['repas_vege', 'douche_courte'],
    'createdAt': DateTime.now().millisecondsSinceEpoch,
  }, 'user_1');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfilHeader(user: _mockUser)
              .animate()
              .fadeIn(duration: 400.ms),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                LevelBadge(user: _mockUser)
                  .animate(delay: 100.ms)
                  .fadeIn()
                  .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
                StatsGrid(user: _mockUser)
                  .animate(delay: 200.ms)
                  .fadeIn()
                  .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
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
  }
}