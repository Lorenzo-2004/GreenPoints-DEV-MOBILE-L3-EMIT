import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/social/social_model.dart';
import '../../../data/services/social_service.dart';
import 'widgets/leaderboard_tile.dart';
import 'widgets/friend_tile.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with SingleTickerProviderStateMixin {
  final SocialService _socialService = SocialService();
  late TabController _tabController;
  List<dynamic> _leaderboard = [];
  List<dynamic> _friends = [];
  bool _isLoading = true;
  dynamic _userRank;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final leaderboard = await _socialService.getLeaderboard();
    final friends = await _socialService.getFriends();
    final userRank = await _socialService.getUserRank();

    setState(() {
      _leaderboard = leaderboard;
      _friends = friends;
      _userRank = userRank;
      _isLoading = false;
    });
  }

  void _showAddFriendDialog() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return FutureBuilder<List<UserRankModel>>(
              future: _socialService.getAllUsers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final users = snapshot.data ?? [];
                // Filter out users who are already friends
                final notFriends = users.where((u) => !_friends.any((f) => f.id == u.id)).toList();

                if (notFriends.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucun nouvel utilisateur trouvé',
                      style: GoogleFonts.inter(color: theme.colorScheme.onSurface),
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Ajouter un ami',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: notFriends.length,
                        itemBuilder: (context, index) {
                          final user = notFriends[index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                                  ? (user.photoUrl!.startsWith('http')
                                      ? NetworkImage(user.photoUrl!) as ImageProvider
                                      : null)
                                  : null,
                              child: user.photoUrl == null || user.photoUrl!.isEmpty
                                  ? Text(
                                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                                      style: const TextStyle(color: AppColors.primary),
                                    )
                                  : null,
                            ),
                            title: Text(
                              user.name,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            subtitle: Text('${user.totalPoints} points'),
                            trailing: IconButton(
                              icon: const Icon(Icons.person_add_rounded, color: AppColors.primary),
                              onPressed: () async {
                                await _socialService.addFriend(user.id);
                                if (!context.mounted) return;
                                Navigator.pop(context);
                                _loadData();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? AppColors.textOnDark : AppColors.textPrimary),
          onPressed: () => context.go('/profil'),
        ),
        title: Text(
          'Social',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: isDark ? AppColors.textSecondary : AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Classement', icon: Icon(Icons.leaderboard_rounded)),
            Tab(text: 'Amis', icon: Icon(Icons.people_rounded)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildLeaderboardTab(),
                _buildFriendsTab(),
              ],
            ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton.extended(
              onPressed: _showAddFriendDialog,
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.person_add_rounded, color: Colors.white),
              label: Text(
                'Ajouter',
                style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            )
          : null,
    );
  }

  Widget _buildLeaderboardTab() {

    return Column(
      children: [
        if (_userRank != null)
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.glassShadow,
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.glassFill,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.glassBorder, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      '#${_userRank.rank}',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ta position',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      Text(
                        '${_userRank.totalPoints} points',
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.glassFill,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.glassBorder, width: 1),
                  ),
                  child: Text(
                    'Top ${_userRank.rank}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _leaderboard.length,
            itemBuilder: (context, index) {
              final user = _leaderboard[index];
              return LeaderboardTile(
                user: user,
                rank: index + 1,
                isTop3: index < 3,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFriendsTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_friends.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark ? AppColors.glassFillDark : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? AppColors.glassBorderDark : AppColors.glassBorder,
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.people_outline,
                size: 40,
                color: isDark ? Colors.white : AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun ami',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textOnDark : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajoute des amis pour les suivre',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: isDark ? AppColors.textSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _friends.length,
      itemBuilder: (context, index) {
        final friend = _friends[index];
        return FriendTile(friend: friend);
      },
    );
  }
}