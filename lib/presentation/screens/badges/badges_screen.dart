import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/badge/badge_model.dart';
import '../../../data/services/badge_service.dart';
import '../../blocs/user/user_cubit.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  final BadgeService _badgeService = BadgeService();
  List<BadgeModel> _badges = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBadges();
  }

  Future<void> _loadBadges() async {
    final badges = await _badgeService.getAllBadges();
    setState(() {
      _badges = badges;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    final userPoints = user?.totalPoints ?? 0;

    final badgesWithStatus = _badges.map((badge) {
      return BadgeModel(
        id: badge.id,
        title: badge.title,
        description: badge.description,
        icon: badge.icon,
        pointsRequired: badge.pointsRequired,
        type: badge.type,
        isUnlocked: userPoints >= badge.pointsRequired,
      );
    }).toList();

    final unlockedCount = badgesWithStatus.where((b) => b.isUnlocked).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Badges',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$unlockedCount/${badgesWithStatus.length}',
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Badges débloqués',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.emoji_events_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: badgesWithStatus.length,
                    itemBuilder: (context, index) {
                      final badge = badgesWithStatus[index];
                      return _BadgeCard(badge: badge);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final BadgeModel badge;

  const _BadgeCard({required this.badge});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: badge.isUnlocked ? AppColors.surface : AppColors.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: badge.isUnlocked ? badge.color : AppColors.border,
          width: badge.isUnlocked ? 1.5 : 1,
        ),
        boxShadow: badge.isUnlocked
            ? [
                BoxShadow(
                  color: badge.color.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  gradient: badge.isUnlocked
                      ? LinearGradient(
                          colors: [badge.color, badge.color.withValues(alpha: 0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: badge.isUnlocked ? null : AppColors.border,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  badge.icon,
                  size: 36,
                  color: badge.isUnlocked ? Colors.white : AppColors.textSecondary,
                ),
              ),
              if (!badge.isUnlocked)
                const Icon(
                  Icons.lock_outline,
                  size: 24,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            badge.title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: badge.isUnlocked ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            badge.description,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: badge.isUnlocked
                  ? badge.color.withValues(alpha: 0.12)
                  : AppColors.border,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badge.isUnlocked ? 'Débloqué' : badge.progressText,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: badge.isUnlocked ? badge.color : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}