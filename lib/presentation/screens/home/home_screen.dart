import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/user/user_model.dart';
import 'widgets/home_header.dart';
import 'widgets/level_progress_card.dart';
import 'widgets/daily_gestes_section.dart';
import 'widgets/stats_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Données fictives pour l'instant — on connectera Firebase après
  static final _mockUser = UserModel.fromMap({
    'name': 'Lorenzo',
    'email': 'lorenzo@email.com',
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
          // Header vert en haut
          SliverToBoxAdapter(
            child: HomeHeader(user: _mockUser)
              .animate()
              .fadeIn(duration: 400.ms),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Carte progression niveau
                LevelProgressCard(user: _mockUser)
                  .animate(delay: 100.ms)
                  .fadeIn()
                  .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 16),

                // Stats rapides
                StatsRow(user: _mockUser)
                  .animate(delay: 200.ms)
                  .fadeIn()
                  .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                // Gestes du jour
                DailyGestesSection(user: _mockUser)
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