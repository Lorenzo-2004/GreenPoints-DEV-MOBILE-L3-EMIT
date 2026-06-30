import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: Text(
            l10n.admin_title, 
            style: GoogleFonts.poppins(
              fontSize: 20, 
              fontWeight: FontWeight.w600, 
              color: theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
            unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 14),
            tabs: [
              Tab(text: l10n.admin_tab_gestes),
              Tab(text: l10n.admin_tab_defis),
              Tab(text: l10n.admin_tab_badges),
              Tab(text: l10n.admin_tab_shop),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _AddGesteForm(),
            _AddDefiForm(),
            _AddBadgeForm(),
            _AddRecompenseForm(),
          ],
        ),
      ),
    );
  }
}

Widget _buildModernInput({
  required BuildContext context,
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool isNumber = false,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.poppins(fontSize: 15, color: theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: theme.cardColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.border,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildSubmitButton(BuildContext context, String text, VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 0,
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

class _AddGesteForm extends StatefulWidget {
  const _AddGesteForm();
  @override
  State<_AddGesteForm> createState() => _AddGesteFormState();
}

class _AddGesteFormState extends State<_AddGesteForm> {
  final _idCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _pointsCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController(text: 'nature');
  bool _isDaily = false;

  void _submit() async {
    if (_idCtrl.text.trim().isEmpty) return;
    await FirebaseFirestore.instance.collection('gestes').doc(_idCtrl.text.trim()).set({
      'id': _idCtrl.text.trim(),
      'title': _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'points': int.tryParse(_pointsCtrl.text.trim()) ?? 10,
      'category': _categoryCtrl.text.trim(),
      'isDaily': _isDaily,
    });
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.admin_success_geste), backgroundColor: AppColors.success));
    _idCtrl.clear();
    _titleCtrl.clear();
    _descCtrl.clear();
    _pointsCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildModernInput(context: context, controller: _idCtrl, label: 'ID (ex: velo_travail)', icon: Icons.fingerprint),
        _buildModernInput(context: context, controller: _titleCtrl, label: l10n.admin_field_title, icon: Icons.title),
        _buildModernInput(context: context, controller: _descCtrl, label: l10n.admin_field_desc, icon: Icons.description_outlined),
        _buildModernInput(context: context, controller: _pointsCtrl, label: l10n.admin_field_points, icon: Icons.stars_rounded, isNumber: true),
        _buildModernInput(context: context, controller: _categoryCtrl, label: l10n.admin_field_cat, icon: Icons.category_outlined),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.1) : AppColors.border,
            ),
          ),
          child: SwitchListTile(
            title: Text(l10n.admin_field_daily, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.bodyLarge?.color)),
            value: _isDaily,
            activeTrackColor: AppColors.primary,
            activeThumbColor: Colors.white,
            onChanged: (v) => setState(() => _isDaily = v),
          ),
        ),
        const SizedBox(height: 16),
        _buildSubmitButton(context, l10n.admin_btn_add_geste, _submit),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _AddDefiForm extends StatefulWidget {
  const _AddDefiForm();
  @override
  State<_AddDefiForm> createState() => _AddDefiFormState();
}

class _AddDefiFormState extends State<_AddDefiForm> {
  final _idCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _subCtrl = TextEditingController();
  final _pointsCtrl = TextEditingController();
  final _daysCtrl = TextEditingController();
  final _catCtrl = TextEditingController(text: 'Hebdomadaire');
  final _iconCtrl = TextEditingController(text: 'eco');
  final _colorCtrl = TextEditingController(text: '059669');

  void _submit() async {
    if (_idCtrl.text.trim().isEmpty) return;
    await FirebaseFirestore.instance.collection('defis').doc(_idCtrl.text.trim()).set({
      'id': _idCtrl.text.trim(),
      'title': _titleCtrl.text.trim(),
      'subtitle': _subCtrl.text.trim(),
      'points': int.tryParse(_pointsCtrl.text.trim()) ?? 100,
      'progress': 0.0,
      'daysLeft': int.tryParse(_daysCtrl.text.trim()) ?? 7,
      'category': _catCtrl.text.trim(),
      'icon': _iconCtrl.text.trim(),
      'color': _colorCtrl.text.trim(),
    });
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.admin_success_defi), backgroundColor: AppColors.success));
    _idCtrl.clear();
    _titleCtrl.clear();
    _subCtrl.clear();
    _pointsCtrl.clear();
    _daysCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildModernInput(context: context, controller: _idCtrl, label: 'ID (ex: ecowarrior)', icon: Icons.fingerprint),
        _buildModernInput(context: context, controller: _titleCtrl, label: l10n.admin_field_title, icon: Icons.flag_rounded),
        _buildModernInput(context: context, controller: _subCtrl, label: l10n.admin_field_sub, icon: Icons.short_text_rounded),
        _buildModernInput(context: context, controller: _pointsCtrl, label: l10n.admin_field_points, icon: Icons.stars_rounded, isNumber: true),
        _buildModernInput(context: context, controller: _daysCtrl, label: l10n.admin_field_days, icon: Icons.timer_outlined, isNumber: true),
        _buildModernInput(context: context, controller: _catCtrl, label: l10n.admin_field_cat, icon: Icons.category_outlined),
        _buildModernInput(context: context, controller: _iconCtrl, label: 'Icône (ex: eco, recycling)', icon: Icons.insert_emoticon_rounded),
        _buildModernInput(context: context, controller: _colorCtrl, label: 'Couleur HEX (ex: 059669)', icon: Icons.color_lens_outlined),
        const SizedBox(height: 16),
        _buildSubmitButton(context, l10n.admin_btn_add_defi, _submit),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _AddBadgeForm extends StatefulWidget {
  const _AddBadgeForm();
  @override
  State<_AddBadgeForm> createState() => _AddBadgeFormState();
}

class _AddBadgeFormState extends State<_AddBadgeForm> {
  final _idCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _iconCtrl = TextEditingController(text: 'star');
  final _pointsReqCtrl = TextEditingController();

  void _submit() async {
    if (_idCtrl.text.trim().isEmpty) return;
    await FirebaseFirestore.instance.collection('badges').doc(_idCtrl.text.trim()).set({
      'id': _idCtrl.text.trim(),
      'title': _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'icon': _iconCtrl.text.trim(),
      'pointsRequired': int.tryParse(_pointsReqCtrl.text.trim()) ?? 100,
    });
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.admin_success_badge), backgroundColor: AppColors.success));
    _idCtrl.clear();
    _titleCtrl.clear();
    _descCtrl.clear();
    _pointsReqCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildModernInput(context: context, controller: _idCtrl, label: 'ID (ex: premier_pas)', icon: Icons.fingerprint),
        _buildModernInput(context: context, controller: _titleCtrl, label: l10n.admin_field_title, icon: Icons.emoji_events_rounded),
        _buildModernInput(context: context, controller: _descCtrl, label: l10n.admin_field_desc, icon: Icons.description_outlined),
        _buildModernInput(context: context, controller: _iconCtrl, label: 'Icône (ex: star)', icon: Icons.insert_emoticon_rounded),
        _buildModernInput(context: context, controller: _pointsReqCtrl, label: l10n.admin_field_points, icon: Icons.military_tech_rounded, isNumber: true),
        const SizedBox(height: 16),
        _buildSubmitButton(context, l10n.admin_btn_add_badge, _submit),
        const SizedBox(height: 40),
      ],
    );
  }
}

class _AddRecompenseForm extends StatefulWidget {
  const _AddRecompenseForm();
  @override
  State<_AddRecompenseForm> createState() => _AddRecompenseFormState();
}

class _AddRecompenseFormState extends State<_AddRecompenseForm> {
  final _idCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _pointsCtrl = TextEditingController();
  final _iconCtrl = TextEditingController(text: 'local_florist');
  final _catCtrl = TextEditingController(text: 'Plantes');
  final _stockCtrl = TextEditingController(text: '10');

  void _submit() async {
    if (_idCtrl.text.trim().isEmpty) return;
    await FirebaseFirestore.instance.collection('recompenses').doc(_idCtrl.text.trim()).set({
      'id': _idCtrl.text.trim(),
      'title': _titleCtrl.text.trim(),
      'description': _descCtrl.text.trim(),
      'points': int.tryParse(_pointsCtrl.text.trim()) ?? 100,
      'icon': _iconCtrl.text.trim(),
      'category': _catCtrl.text.trim(),
      'stock': int.tryParse(_stockCtrl.text.trim()) ?? 10,
    });
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.admin_success_reward), backgroundColor: AppColors.success));
    _idCtrl.clear();
    _titleCtrl.clear();
    _descCtrl.clear();
    _pointsCtrl.clear();
    _stockCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildModernInput(context: context, controller: _idCtrl, label: 'ID (ex: 1)', icon: Icons.fingerprint),
        _buildModernInput(context: context, controller: _titleCtrl, label: l10n.admin_field_title, icon: Icons.shopping_bag_rounded),
        _buildModernInput(context: context, controller: _descCtrl, label: l10n.admin_field_desc, icon: Icons.description_outlined),
        _buildModernInput(context: context, controller: _pointsCtrl, label: l10n.admin_field_points, icon: Icons.stars_rounded, isNumber: true),
        _buildModernInput(context: context, controller: _iconCtrl, label: 'Icône (local_florist, etc)', icon: Icons.insert_emoticon_rounded),
        _buildModernInput(context: context, controller: _catCtrl, label: l10n.admin_field_cat, icon: Icons.category_outlined),
        _buildModernInput(context: context, controller: _stockCtrl, label: l10n.admin_field_stock, icon: Icons.inventory_2_outlined, isNumber: true),
        const SizedBox(height: 16),
        _buildSubmitButton(context, l10n.admin_btn_add_reward, _submit),
        const SizedBox(height: 40),
      ],
    );
  }
}