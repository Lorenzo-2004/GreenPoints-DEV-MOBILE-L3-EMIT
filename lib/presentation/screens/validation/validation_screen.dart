import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/geste/geste_model.dart';
import '../../../data/services/geste_service.dart';
import '../../../data/services/points_service.dart';
import '../../../domain/entities/points_transaction_entity.dart';
import '../../../domain/enums/action_category.dart';
import '../../../l10n/app_localizations.dart';
import '../../blocs/user/user_cubit.dart';

class ValidationScreen extends StatefulWidget {
  final GesteModel? initialGeste;
  const ValidationScreen({super.key, this.initialGeste});

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  final GesteService _gesteService = GesteService();
  final ImagePicker _picker = ImagePicker();
  int _selectedMethod = 0;
  GesteModel? _selectedGeste;
  List<GesteModel> _gestes = [];
  bool _isLoading = true;
  bool _isValidating = false;
  File? _selectedImage;
  String? _qrCodeResult;

  @override
  void initState() {
    super.initState();
    _loadGestes();
    
    if (widget.initialGeste != null) {
      _selectedGeste = widget.initialGeste;
    }
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

  Future<void> _handlePhotoValidate() async {
    setState(() => _isValidating = true);
    // Simulate AI Image recognition delay
    await Future.delayed(const Duration(seconds: 2));
    
    if (_selectedGeste == null && _gestes.isNotEmpty) {
      // Pick a random geste or just the first one if none selected
      _selectedGeste = _gestes.first;
    }
    
    await _handleValidate();
  }

  Future<void> _handleValidate() async {
    if (_selectedGeste == null) return;
    
    setState(() => _isValidating = true);
    HapticFeedback.heavyImpact();
    
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'totalPoints': FieldValue.increment(_selectedGeste!.points),
          'weeklyPoints': FieldValue.increment(_selectedGeste!.points),
          'completedActionIds': FieldValue.arrayUnion([_selectedGeste!.id]),
          'lastActionDate': FieldValue.serverTimestamp(),
        });
        
        await _updateStreak(userId);
        
        await PointsService().addTransaction(
          gesteId: _selectedGeste!.id,
          gesteTitle: _selectedGeste!.title,
          points: _selectedGeste!.points,
          type: TransactionType.earned,
        );
        
        await _addNotification(
          title: 'Geste valide !',
          message: 'Tu as gagne ${_selectedGeste!.points} points pour "${_selectedGeste!.title}"',
        );
        
        if (mounted) {
          context.read<UserCubit>().refresh();
        }
      } catch(e) {
        debugPrint("Erreur validation geste: \$e");
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

  Future<void> _addNotification({required String title, required String message}) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;
    
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add({
        'title': title,
        'message': message,
        'type': 'points',
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      debugPrint("Erreur notification: \$e");
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

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null && mounted) {
        setState(() {
          _selectedImage = File(photo.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.validation_photo_taken), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Accès caméra refusé ou non disponible.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null && mounted) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Accès galerie refusé ou erreur.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    final completedIds = user?.completedActionIds ?? [];
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
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
                              l10n.validation_title,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.75),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              l10n.validation_subtitle,
                              style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => context.go('/home'),
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
                        _QRSection(
                          onQrCodeScanned: (code) {
                            setState(() {
                              _qrCodeResult = code;
                              final geste = _gestes.firstWhere(
                                (g) => g.id == code,
                                orElse: () => _gestes.first,
                              );
                              _selectedGeste = geste;
                            });
                          },
                        ).animate(delay: 200.ms).fadeIn()
                      else
                        _PhotoSection(
                          selectedImage: _selectedImage,
                          onTakePhoto: _takePhoto,
                          onPickImage: _pickImage,
                        ).animate(delay: 200.ms).fadeIn(),
                      if (_selectedMethod == 1 && _qrCodeResult != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: ElevatedButton(
                            onPressed: _selectedGeste != null && !_isValidating ? _handleValidate : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(l10n.validation_validate, style: GoogleFonts.inter(color: Colors.white)),
                          ),
                        ),
                      if (_selectedMethod == 2 && _selectedImage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: ElevatedButton(
                            onPressed: !_isValidating ? _handlePhotoValidate : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: _isValidating
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                  )
                                : Text(l10n.validation_validate_with_photo, style: GoogleFonts.inter(color: Colors.white)),
                          ),
                        ),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final methods = [
      {'icon': Icons.edit_note_rounded, 'label': l10n.validation_manual},
      {'icon': Icons.qr_code_scanner_rounded, 'label': l10n.validation_qr_code},
      {'icon': Icons.camera_alt_rounded, 'label': l10n.validation_photo},
    ];

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.border),
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
                      color: isSelected ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m['label'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.validation_choose_gesture,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
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
                  color: isSelected ? AppColors.primaryLight : (isDark ? AppColors.darkCard : AppColors.surface),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : (isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.border),
                    width: isSelected ? 2 : 1,
                  ),
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
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? AppColors.primary : theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            g.description,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                          l10n.home_done,
                          style: GoogleFonts.inter(
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
                          style: GoogleFonts.inter(
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
                    l10n.validation_validate,
                    style: GoogleFonts.inter(
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
  final Function(String) onQrCodeScanned;

  const _QRSection({required this.onQrCodeScanned});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.border),
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
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(24),
            ),
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    onQrCodeScanned(barcode.rawValue!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${l10n.validation_qr_scanned}${barcode.rawValue}'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.validation_scan_qr,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.validation_scan_qr_hint,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  final File? selectedImage;
  final VoidCallback onTakePhoto;
  final VoidCallback onPickImage;

  const _PhotoSection({
    required this.selectedImage,
    required this.onTakePhoto,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.border),
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
          selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    selectedImage!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
              : GestureDetector(
                  onTap: onTakePhoto,
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
          if (selectedImage == null) ...[
            Text(
              l10n.validation_take_photo,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.validation_take_photo_hint,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: onTakePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(l10n.validation_camera),
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: onPickImage,
                  icon: const Icon(Icons.photo_library),
                  label: Text(l10n.validation_gallery),
                ),
              ],
            ),
          ] else
            Column(
              children: [
                Text(
                  l10n.validation_photo_taken,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    onTakePhoto();
                    onPickImage();
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.validation_retake),
                ),
              ],
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.surface,
        borderRadius: const BorderRadius.only(
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
            l10n.validation_success,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            geste.title,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                  '+${geste.points} ${l10n.validation_points_gained}',
                  style: GoogleFonts.inter(
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
                l10n.validation_continue,
                style: GoogleFonts.inter(
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