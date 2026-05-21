import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/geste/geste_model.dart';
import '../../../data/models/notification/notification_model.dart';
import '../../../data/services/geste_service.dart';
import '../../../data/services/notification_service.dart';
import '../../../domain/enums/action_category.dart';
import '../../blocs/user/user_cubit.dart';

class ValidationScreen extends StatefulWidget {
  const ValidationScreen({super.key});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  final GesteService _gesteService = GesteService();
  final NotificationService _notificationService = NotificationService();
  int _selectedMethod = 0;
  GesteModel? _selectedGeste;
  List<GesteModel> _gestes = [];
  bool _isLoading = true;
  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    _loadGestes();
  }

  Future<void> _loadGestes() async {
    final gestes = await _gesteService.getAllGestes();
    if (mounted) {
      setState(() {
        _gestes = gestes;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleValidate() async {
    if (_selectedGeste == null) return;
    
    setState(() => _isValidating = true);
    HapticFeedback.heavyImpact();
    
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'totalPoints': FieldValue.increment(_selectedGeste!.points),
        'weeklyPoints': FieldValue.increment(_selectedGeste!.points),
        'completedActionIds': FieldValue.arrayUnion([_selectedGeste!.id]),
        'lastActionDate': FieldValue.serverTimestamp(),
      });
      
      await _updateStreak(userId);
      
      // Ajouter une notification
      await _notificationService.addNotification(
        title: 'Geste validé !',
        message: 'Tu as gagné ${_selectedGeste!.points} points pour "${_selectedGeste!.title}"',
        type: NotificationType.points,
        data: {'points': _selectedGeste!.points, 'gesteId': _selectedGeste!.id},
      );
      
      if (mounted) {
        context.read<UserCubit>().refresh();
      }
    }
    
    setState(() => _isValidating = false);
    
    if (mounted) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => _SuccessSheet(geste: _selectedGeste!),
      );
    }
  }

  Future<void> _updateStreak(String userId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final data = doc.data() as Map<String, dynamic>;
    final lastDate = data['lastActionDate'] as Timestamp?;
    
    int currentStreak = data['streak'] ?? 0;
    
    if (lastDate != null) {
      final lastActionDate = lastDate.toDate();
      final today = DateTime.now();
      final yesterday = DateTime(today.year, today.month, today.day - 1);
      
      if (lastActionDate.year == yesterday.year &&
          lastActionDate.month == yesterday.month &&
          lastActionDate.day == yesterday.day) {
        currentStreak++;
      } else if (lastActionDate.year != today.year ||
                 lastActionDate.month != today.month ||
                 lastActionDate.day != today.day) {
        currentStreak = 1;
      }
    } else {
      currentStreak = 1;
    }
    
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'streak': currentStreak,
    });
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
                              'Valider',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.75),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              'Un geste',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            context.go('/home');
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _MethodSelector(
                        selected: _selectedMethod,
                        onSelected: (i) => setState(() => _selectedMethod = i),
                      ).animate(delay: 100.ms).fadeIn(),
                      const SizedBox(height: 20),
                      if (_selectedMethod == 0)
                        _ManualSection(
                          gestes: _gestes,
                          completedIds: completedIds,
                          selectedGeste: _selectedGeste,
                          onGesteSelected: (g) => setState(() => _selectedGeste = g),
                          onValidate: _handleValidate,
                          isValidating: _isValidating,
                        ).animate(delay: 200.ms).fadeIn()
                      else if (_selectedMethod == 1)
                        _QRSection().animate(delay: 200.ms).fadeIn()
                      else
                        _PhotoSection().animate(delay: 200.ms).fadeIn(),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }
}

class _MethodSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelected;

  const _MethodSelector({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final methods = [
      {'icon': Icons.edit_note_rounded, 'label': 'Manuel'},
      {'icon': Icons.qr_code_scanner_rounded, 'label': 'QR Code'},
      {'icon': Icons.camera_alt_rounded, 'label': 'Photo'},
    ];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: methods.asMap().entries.map((e) {
          final i = e.key;
          final m = e.value;
          final isSelected = selected == i;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onSelected(i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  color: isSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  children: [
                    Icon(
                      m['icon'] as IconData,
                      size: 22,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m['label'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ManualSection extends StatelessWidget {
  final List<GesteModel> gestes;
  final List<String> completedIds;
  final GesteModel? selectedGeste;
  final ValueChanged<GesteModel> onGesteSelected;
  final VoidCallback onValidate;
  final bool isValidating;

  const _ManualSection({
    required this.gestes,
    required this.completedIds,
    required this.selectedGeste,
    required this.onGesteSelected,
    required this.onValidate,
    required this.isValidating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choisir un geste',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        ...gestes.map((g) {
          final isSelected = selectedGeste?.id == g.id;
          final isDone = completedIds.contains(g.id);
          final categoryColor = g.category.color;
          final categoryIcon = g.category.icon;
          
          return GestureDetector(
            onTap: isDone ? null : () {
              HapticFeedback.selectionClick();
              onGesteSelected(g);
            },
            child: Opacity(
              opacity: isDone ? 0.5 : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryLight : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        isSelected ? Icons.check_circle_rounded : categoryIcon,
                        color: isSelected ? AppColors.primary : categoryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g.title,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            g.description,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (isDone)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Fait',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${g.points}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: selectedGeste != null && !isValidating ? onValidate : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: isValidating
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Valider le geste',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _QRSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Scanner le QR code',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pointez vers le code QR du geste',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Caméra requise',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => HapticFeedback.lightImpact(),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 52,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Prendre une photo',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Prenez en photo votre action écologique',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessSheet extends StatelessWidget {
  final GesteModel geste;

  const _SuccessSheet({required this.geste});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 40,
            ),
          ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),

          const SizedBox(height: 20),

          Text(
            'Geste validé !',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            geste.title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.stars_rounded,
                  color: AppColors.warning,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  '+${geste.points} points gagnés !',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ).animate(delay: 300.ms).scale(curve: Curves.elasticOut),

          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Super, continuer !',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}