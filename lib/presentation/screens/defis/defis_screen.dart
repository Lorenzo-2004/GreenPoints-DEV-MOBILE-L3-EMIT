import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/defi_service.dart';
import 'widgets/defi_card.dart';
import 'widgets/defi_category_filter.dart';

class DefisScreen extends StatefulWidget {
  const DefisScreen({super.key});

  @override
  State<DefisScreen> createState() => _DefisScreenState();
}

class _DefisScreenState extends State<DefisScreen> {
  final DefiService _defiService = DefiService();
  String _selectedCategory = 'Tous';
  List<Map<String, dynamic>> _allDefis = [];
  bool _isLoading = true;
  String _searchQuery = '';
  bool _showOnlyActive = false;

  @override
  void initState() {
    super.initState();
    _loadDefis();
  }

  Future<void> _loadDefis() async {
    final defis = await _defiService.getAllDefis();
    setState(() {
      _allDefis = defis;
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filtered {
    var filtered = _allDefis;
    
    if (_selectedCategory != 'Tous') {
      filtered = filtered.where((d) => d['category'] == _selectedCategory).toList();
    }
    
    if (_showOnlyActive) {
      filtered = filtered.where((d) => (d['progress'] as double) < 1.0).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((d) =>
        (d['title'] as String).toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (d['subtitle'] as String).toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  void _updateCategory(String cat) {
    setState(() {
      _selectedCategory = cat;
    });
  }

  void _toggleActiveFilter() {
    setState(() {
      _showOnlyActive = !_showOnlyActive;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
    });
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Rechercher un defi', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: TextField(
          autofocus: true,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Titre, description...',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _clearSearch();
              Navigator.pop(context);
            },
            child: Text('Effacer', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  void _shareDefi(Map<String, dynamic> defi) {
    Share.share(
      'Je viens de progresser sur le defi "${defi['title']}" sur GreenPoints !\n'
      '${((defi['progress'] as double) * 100).toInt()}% complete.\n\n'
      'Telecharge GreenPoints et deviens eco-responsable !',
    );
  }

  void _showDefiDetails(Map<String, dynamic> defi) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(defi['title'], style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(defi['subtitle'], style: GoogleFonts.poppins(color: AppColors.textSecondary)),
            const SizedBox(height: 16),
            _detailRow('Points', '+${defi['points']} pts'),
            _detailRow('Progression', '${((defi['progress'] as double) * 100).toInt()}%'),
            _detailRow('Jours restants', '${defi['daysLeft']} jours'),
            _detailRow('Categorie', defi['category']),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fermer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      bottom: 28,
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
                              'Defis',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.75),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Mes Defis',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Bouton recherche
                            GestureDetector(
                              onTap: _showSearchDialog,
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
                            // Bouton filtre actif
                            GestureDetector(
                              onTap: _toggleActiveFilter,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _showOnlyActive
                                      ? Colors.white.withValues(alpha: 0.3)
                                      : Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _showOnlyActive ? Icons.play_circle : Icons.history,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Badge compteur
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '${_filtered.length}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                ),
                // Barre recherche active
                if (_searchQuery.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 14, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Recherche: "$_searchQuery"',
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
                            ),
                          ),
                          GestureDetector(
                            onTap: _clearSearch,
                            child: Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Filtres catégories
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: DefiCategoryFilter(
                      selected: _selectedCategory,
                      onSelected: _updateCategory,
                    ),
                  ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),
                ),
                // Liste défis
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final defi = _filtered[index];
                        return GestureDetector(
                          onLongPress: () => _shareDefi(defi),
                          child: DefiCard(
                            defi: defi,
                            onTap: () => _showDefiDetails(defi),
                          ),
                        ).animate(delay: (200 + index * 50).ms)
                          .fadeIn()
                          .slideY(begin: 0.2, end: 0);
                      },
                      childCount: _filtered.length,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}