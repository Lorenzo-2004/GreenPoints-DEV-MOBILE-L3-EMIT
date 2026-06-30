import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/geste/geste_model.dart';
import '../../../data/services/geste_service.dart';
import '../../../domain/enums/action_category.dart';
import '../../blocs/user/user_cubit.dart';
import '../../../l10n/app_localizations.dart';
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
  List<GesteModel> _filteredGestesList = [];
  bool _isLoading = true;
  String _searchQuery = '';
  bool _showOnlyDaily = false;

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
        _applyFilters();
        _isLoading = false;
      });
    }
  }

  Set<ActionCategory> get _availableCategories {
    return _allGestes.map((g) => g.category).toSet();
  }

  void _applyFilters() {
    var filtered = _allGestes;
    
    if (_selectedCategory != null) {
      filtered = filtered.where((g) => g.category == _selectedCategory).toList();
    }
    
    if (_showOnlyDaily) {
      filtered = filtered.where((g) => g.isDaily).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((g) =>
        g.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        g.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    setState(() {
      _filteredGestesList = filtered;
    });
  }

  void _updateCategory(ActionCategory? cat) {
    setState(() {
      _selectedCategory = _selectedCategory == cat ? null : cat;
      _applyFilters();
    });
  }

  void _toggleDailyFilter() {
    setState(() {
      _showOnlyDaily = !_showOnlyDaily;
      _applyFilters();
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _applyFilters();
    });
  }

  void _shareGeste(GesteModel geste) {
    Share.share(
      'Je viens de valider "${geste.title}" sur GreenPoints !\n'
      '+${geste.points} points gagnes.\n\n'
      'Telecharge GreenPoints et deviens eco-responsable !',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    final user = context.watch<UserCubit>().state;
    final completedIds = user?.completedActionIds ?? [];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.gestures_discover,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.gestures_title,
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.1,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Bouton recherche
                            GestureDetector(
                              onTap: () => _showSearchDialog(),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.search, color: Colors.white, size: 22),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Bouton filtre quotidien
                            GestureDetector(
                              onTap: _toggleDailyFilter,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _showOnlyDaily
                                      ? Colors.white.withValues(alpha: 0.3)
                                      : Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _showOnlyDaily ? Icons.today : Icons.calendar_today,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
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
                              ),
                              child: Center(
                                child: Text(
                                  '${_filteredGestesList.length}',
                                  style: GoogleFonts.inter(
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
                // Barre de recherche (si active)
                if (_searchQuery.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 16, color: isDark ? Colors.white : AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Recherche: "$_searchQuery"',
                              style: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.white : AppColors.primary),
                            ),
                          ),
                          GestureDetector(
                            onTap: _clearSearch,
                            child: Icon(Icons.close, size: 16, color: isDark ? Colors.white : AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Filtres catégories
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: CategoryFilter(
                      selected: _selectedCategory,
                      onSelected: _updateCategory,
                      availableCategories: _availableCategories,
                    ),
                  ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.2, end: 0),
                ),
                // Liste gestes
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final geste = _filteredGestesList[index];
                        final isDone = completedIds.contains(geste.id);
                        return GestureDetector(
                          onLongPress: () => _shareGeste(geste),
                          child: GesteCard(
                            geste: geste,
                            isDone: isDone,
                            onTap: isDone ? null : () => context.go('/valider', extra: geste),
                          ).animate(delay: (index * 50).ms)
                            .fadeIn(duration: 300.ms)
                            .slideY(begin: 0.1, end: 0),
                        );
                      },
                      childCount: _filteredGestesList.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _showSearchDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.common_search, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: theme.colorScheme.onSurface),
          onChanged: (value) {
            _searchQuery = value;
            _applyFilters();
          },
          decoration: InputDecoration(
            hintText: l10n.search_hint,
            hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
            prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurface),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.2) : AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearSearch();
              Navigator.pop(context);
            },
            child: Text(l10n.common_clear, style: GoogleFonts.inter()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.common_close, style: GoogleFonts.inter()),
          ),
        ],
      ),
    );
  }
}