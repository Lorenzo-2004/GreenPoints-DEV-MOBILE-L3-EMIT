import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
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
    if (_selectedCategory == 'Tous') return _allDefis;
    return _allDefis
        .where((d) => d['category'] == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
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
                                  'Défis',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white.withValues(alpha: 0.75),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  'Mes Défis',
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
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

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: DefiCategoryFilter(
                      selected: _selectedCategory,
                      onSelected: (cat) =>
                          setState(() => _selectedCategory = cat),
                    ),
                  ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2, end: 0),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final defi = _filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: DefiCard(
                              defi: defi,
                              onTap: () {},
                            ),
                          ).animate(delay: (200 + index * 50).ms)
                            .fadeIn()
                            .slideY(begin: 0.2, end: 0),
                        );
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