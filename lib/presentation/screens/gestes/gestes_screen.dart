import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/geste/geste_model.dart';
import '../../../data/services/geste_service.dart';
import '../../../domain/enums/action_category.dart';
import '../../blocs/user/user_cubit.dart';
import 'widgets/geste_card.dart';
import 'widgets/category_filter.dart';

class GestesScreen extends StatefulWidget {
  const GestesScreen({super.key});

  @override
  State<GestesScreen> createState() => _GestesScreenState();
}

class _GestesScreenState extends State<GestesScreen> {
  final GesteService _gesteService = GesteService();
  ActionCategory? _selectedCategory;
  List<GesteModel> _allGestes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGestes();
  }

  Future<void> _loadGestes() async {
    final gestes = await _gesteService.getAllGestes();
    if (mounted) {
      setState(() {
        _allGestes = gestes;
        _isLoading = false;
      });
    }
  }

  List<GesteModel> get _filteredGestes {
    if (_selectedCategory == null) return _allGestes;
    return _allGestes.where((g) => g.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    final completedIds = user?.completedActionIds ?? [];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 20,
                      left: 24,
                      right: 24,
                      bottom: 32,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Découvrez',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Mes Gestes',
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.1,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                            // Badge compteur
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.2),
                                    Colors.white.withValues(alpha: 0.08),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '${_filteredGestes.length}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 500.ms),
                ),

                // Filtres catégories
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: CategoryFilter(
                      selected: _selectedCategory,
                      onSelected: (cat) {
                        setState(() {
                          _selectedCategory =
                              _selectedCategory == cat ? null : cat;
                        });
                      },
                    ),
                  ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.2, end: 0),
                ),

                // Liste gestes
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final geste = _filteredGestes[index];
                        final isDone = completedIds.contains(geste.id);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: GesteCard(
                              geste: geste,
                              isDone: isDone,
                            ),
                          ).animate(delay: (200 + index * 50).ms)
                            .fadeIn(duration: 400.ms)
                            .slideY(begin: 0.2, end: 0),
                        );
                      },
                      childCount: _filteredGestes.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}