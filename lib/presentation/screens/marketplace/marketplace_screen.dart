import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/marketplace_service.dart';
import '../../blocs/user/user_cubit.dart';
import 'widgets/reward_card.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final MarketplaceService _marketplaceService = MarketplaceService();
  List<dynamic> _rewards = [];
  bool _isLoading = true;
  String _selectedCategory = 'Tous';
  final List<String> _categories = ['Tous', 'Eco-produits', 'Plantes', 'Accessoires', 'Exclusifs'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final rewards = await _marketplaceService.getAllRecompenses();
    if (mounted) {
      setState(() {
        _rewards = rewards;
        _isLoading = false;
      });
    }
  }

  List<dynamic> get _filteredRewards {
    if (_selectedCategory == 'Tous') return _rewards;
    return _rewards.where((r) => r.category == _selectedCategory).toList();
  }

  Future<void> _showPurchaseDialog(dynamic reward) async {
    final user = context.read<UserCubit>().state;
    final canAfford = (user?.totalPoints ?? 0) >= reward.points;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(reward.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(reward.description, style: GoogleFonts.poppins(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            Row(children: [
              Icon(Icons.stars_rounded, color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              Text('${reward.points} points', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.warning)),
            ]),
            if (reward.stock > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Stock: ${reward.stock}', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
              ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Annuler', style: GoogleFonts.poppins())),
          ElevatedButton(
            onPressed: canAfford ? () => Navigator.pop(context, true) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canAfford ? AppColors.primary : AppColors.border,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(canAfford ? 'Echanger' : 'Points insuffisants', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'totalPoints': FieldValue.increment(-reward.points),
        });
        if (mounted) {
          context.read<UserCubit>().refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${reward.title} achete !'), backgroundColor: AppColors.success),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    final userPoints = user?.totalPoints ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Boutique', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Mes points', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withValues(alpha: 0.8))),
                      Text('$userPoints', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1)),
                    ]),
                    Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.stars_rounded, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: _categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category, style: GoogleFonts.poppins(fontSize: 13, color: isSelected ? Colors.white : AppColors.textSecondary)),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _selectedCategory = category),
                      backgroundColor: AppColors.surface,
                      selectedColor: AppColors.primary,
                      side: BorderSide(color: AppColors.border),
                    ),
                  );
                }).toList()),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _filteredRewards.isEmpty
                    ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textSecondary),
                        const SizedBox(height: 16),
                        Text('Aucune recompense', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      ]))
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8,
                        ),
                        itemCount: _filteredRewards.length,
                        itemBuilder: (context, index) {
                          final reward = _filteredRewards[index];
                          return RewardCard(
                            reward: reward,
                            canAfford: userPoints >= reward.points,
                            onTap: () => _showPurchaseDialog(reward),
                          );
                        },
                      ),
              ),
            ]),
    );
  }
}