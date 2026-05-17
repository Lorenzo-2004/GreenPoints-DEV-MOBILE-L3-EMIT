import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/geste/geste_model.dart';
import '../../../domain/enums/action_category.dart';
import 'widgets/geste_card.dart';
import 'widgets/category_filter.dart';

class GestesScreen extends StatefulWidget {
  const GestesScreen({super.key});

  @override
  State<GestesScreen> createState() => _GestesScreenState();
}

class _GestesScreenState extends State<GestesScreen> {
  ActionCategory? _selectedCategory;

  List<GesteModel> get _filteredGestes {
    final all = GesteModel.defaults
        .map((g) => GesteModel.fromMap(g, g['id']))
        .toList();
    if (_selectedCategory == null) return all;
    return all
        .where((g) => g.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            backgroundColor: AppColors.primary,
            expandedHeight: 120,
            floating: true,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Mes Gestes',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                ),
              ),
              background: Container(color: AppColors.primary),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_filteredGestes.length} gestes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Filtres catégories
          SliverToBoxAdapter(
            child: CategoryFilter(
              selected: _selectedCategory,
              onSelected: (cat) {
                setState(() {
                  _selectedCategory =
                      _selectedCategory == cat ? null : cat;
                });
              },
            ).animate().fadeIn(duration: 300.ms),
          ),

          // Liste gestes
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final geste = _filteredGestes[index];
                  return GesteCard(geste: geste)
                      .animate(delay: (index * 60).ms)
                      .fadeIn()
                      .slideX(begin: 0.1, end: 0);
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