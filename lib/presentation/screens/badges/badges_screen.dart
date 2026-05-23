import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/badge/badge_model.dart';
import '../../../data/services/badge_service.dart';
import '../../blocs/user/user_cubit.dart';
import 'widgets/badge_card.dart';

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

  void _shareBadge(BadgeModel badge) {
    Share.share(
      'Je viens de debloquer le badge "${badge.title}" sur GreenPoints !\n'
      '${badge.description}\n\n'
      'Rejoins-moi et deviens eco-responsable !',
      subject: 'GreenPoints - Nouveau badge debloque',
    );
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
                            'Badges debloques',
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
                      return BadgeCard(
                        badge: badge,
                        onTap: badge.isUnlocked
                            ? () => _shareBadge(badge)
                            : null,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}