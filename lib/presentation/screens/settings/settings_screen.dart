import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';
import '../../blocs/user/user_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'Francais';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
        _selectedLanguage = prefs.getString('language') ?? 'Francais';
      });
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setString('language', _selectedLanguage);
  }

  Future<void> _logout() async {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.settings_logout, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(l10n.settings_logout_confirm, style: GoogleFonts.poppins()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.settings_no)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.settings_yes, style: TextStyle(color: theme.colorScheme.error)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  void _shareApp() {
    Share.share(
      'Decouvre GreenPoints !\n'
      'Valide des gestes ecologiques et gagne des points.\n'
      'Telecharge l\'application sur le Play Store !',
    );
  }

  void _showHelp() {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(l10n.settings_help, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const Divider(),
            _buildHelpItem('Comment gagner des points ?', 'Valide des gestes ecologiques.'),
            _buildHelpItem('Comment debloquer des badges ?', 'Atteins les paliers de points.'),
            _buildHelpItem('Comment ajouter des amis ?', 'Va dans Social et cherche par email.'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    final theme = Theme.of(context);
    return ExpansionTile(
      title: Text(title, style: GoogleFonts.poppins()),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(description, style: GoogleFonts.poppins(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final user = context.watch<UserCubit>().state;
    final isAdmin = user?.email == 'admin@greenpoints.com' || user?.email == 'lorenzorafanomezantsoa@gmail.com';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settings_title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(l10n.settings_preferences, theme),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: l10n.settings_notifications,
            subtitle: l10n.settings_notifications_subtitle,
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
                _saveSettings();
              });
            },
            theme: theme,
          ),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: l10n.settings_dark_mode,
            subtitle: l10n.settings_dark_mode_subtitle,
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(),
            theme: theme,
          ),
          _buildListTile(
            icon: Icons.language_outlined,
            title: l10n.settings_language,
            subtitle: _selectedLanguage,
            onTap: () => _showLanguageDialog(localeProvider),
            theme: theme,
          ),

          const SizedBox(height: 24),

          _buildSectionTitle(l10n.settings_account, theme),
          _buildListTile(
            icon: Icons.person_outline,
            title: l10n.settings_edit_profile,
            subtitle: l10n.settings_edit_profile_subtitle,
            onTap: () => context.go('/profil'),
            theme: theme,
          ),
          _buildListTile(
            icon: Icons.emoji_events_outlined,
            title: l10n.settings_my_badges,
            subtitle: l10n.settings_my_badges_subtitle,
            onTap: () => context.push('/badges'),
            theme: theme,
          ),
          _buildListTile(
            icon: Icons.history_rounded,
            title: l10n.settings_points_history,
            subtitle: l10n.settings_points_history_subtitle,
            onTap: () => context.push('/points'),
            theme: theme,
          ),
          
          if (isAdmin) ...[
            const SizedBox(height: 24),
            _buildSectionTitle('Administration', theme),
            _buildListTile(
              icon: Icons.admin_panel_settings_outlined,
              iconColor: AppColors.info,
              title: 'Panneau Admin',
              subtitle: 'Gérer les données de l\'app',
              onTap: () => context.push('/admin'),
              theme: theme,
            ),
          ],

          const SizedBox(height: 24),

          _buildSectionTitle(l10n.settings_support, theme),
          _buildListTile(
            icon: Icons.help_outline,
            title: l10n.settings_help,
            subtitle: l10n.settings_help_subtitle,
            onTap: _showHelp,
            theme: theme,
          ),
          _buildListTile(
            icon: Icons.share_outlined,
            title: l10n.settings_share_app,
            subtitle: l10n.settings_share_app_subtitle,
            onTap: _shareApp,
            theme: theme,
          ),
          _buildListTile(
            icon: Icons.star_outline,
            title: l10n.settings_rate_app,
            subtitle: l10n.settings_rate_app_subtitle,
            onTap: () {},
            theme: theme,
          ),

          const SizedBox(height: 24),

          _buildListTile(
            icon: Icons.logout,
            title: l10n.settings_logout,
            subtitle: l10n.settings_logout_subtitle,
            iconColor: colorScheme.error,
            textColor: colorScheme.error,
            onTap: _logout,
            theme: theme,
          ),

          const SizedBox(height: 40),
          Center(child: Text('${l10n.settings_version} 1.0.0', style: GoogleFonts.poppins(fontSize: 12, color: colorScheme.onSurface.withValues(alpha: 0.5)))),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
    Color? iconColor,
    Color? textColor,
  }) {
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;
    final effectiveTextColor = textColor ?? theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: effectiveIconColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: effectiveIconColor, size: 22),
        ),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: effectiveTextColor)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
        trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withValues(alpha: 0.5), size: 20),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white.withValues(alpha: 0.1) : AppColors.border),
      ),
      child: ListTile(
        leading: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: theme.colorScheme.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: theme.colorScheme.primary, size: 22),
        ),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
        trailing: Switch(value: value, onChanged: onChanged, activeTrackColor: theme.colorScheme.primary, activeThumbColor: Colors.white),
      ),
    );
  }

  void _showLanguageDialog(LocaleProvider localeProvider) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(l10n.settings_choose_language, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const Divider(),
            _buildLanguageOption(l10n.settings_french, 'fr', localeProvider),
            _buildLanguageOption(l10n.settings_english, 'en', localeProvider),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String label, String code, LocaleProvider provider) {
    final theme = Theme.of(context);
    final isSelected = provider.locale.languageCode == code;
    return ListTile(
      onTap: () {
        provider.setLocale(code);
        setState(() {
          _selectedLanguage = label;
        });
        _saveSettings();
        Navigator.pop(context);
      },
      title: Text(label, style: GoogleFonts.poppins(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
      trailing: isSelected ? Icon(Icons.check_rounded, color: theme.colorScheme.primary) : null,
    );
  }
}
