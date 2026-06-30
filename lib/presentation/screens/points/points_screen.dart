import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/points/points_transaction_model.dart';
import '../../../data/services/points_service.dart';
import '../../blocs/user/user_cubit.dart';
import 'widgets/point_card.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  final PointsService _pointsService = PointsService();
  String _selectedFilter = 'Tous';
  final List<String> _filters = ['Tous', 'Gagnes', 'Depenses'];

  List<PointsTransactionModel> _getFilteredTransactions(List<PointsTransactionModel> transactions) {
    if (_selectedFilter == 'Tous') return transactions;
    if (_selectedFilter == 'Gagnes') {
      return transactions.where((t) => t.points > 0).toList();
    }
    return transactions.where((t) => t.points < 0).toList();
  }

  int _getTotalPoints(List<PointsTransactionModel> transactions) {
    return transactions.fold(0, (sum, t) => sum + t.points);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Historique des points',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<List<PointsTransactionModel>>(
        stream: _pointsService.streamTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data ?? [];
          final filteredTransactions = _getFilteredTransactions(transactions);
          final calculatedPoints = _getTotalPoints(transactions);
          final userPoints = user?.totalPoints ?? calculatedPoints;

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total des points',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$userPoints',
                          style: GoogleFonts.poppins(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -1,
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
                        Icons.stars_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          filter,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: isSelected ? Colors.white : (Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary),
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        backgroundColor: Theme.of(context).cardColor,
                        selectedColor: AppColors.primary,
                        side: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: filteredTransactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.history_rounded,
                                size: 40,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Aucune transaction',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Valide des gestes pour gagner des points',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredTransactions.length,
                        itemBuilder: (context, index) {
                          final transaction = filteredTransactions[index];
                          return PointCard(
                            transaction: transaction,
                          ).animate(delay: (index * 50).ms)
                            .fadeIn()
                            .slideX(begin: 0.1, end: 0);
                        },
                      ),
              ),
            ],
          );
        }
      ),
    );
  }
}