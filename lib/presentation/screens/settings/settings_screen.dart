import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/locale_provider.dart';
import '../../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
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
        _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
        _selectedLanguage = prefs.getString('language') ?? 'Francais';
      });
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _notificationsEnabled);
    await prefs.setBool('dark_mode_enabled', _darkModeEnabled);
    await prefs.setString('language', _selectedLanguage);
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Deconnexion', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text('Voulez-vous vraiment vous deconnecter ?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Non')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Oui', style: TextStyle(color: AppColors.error)),
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
            Text('Aide', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
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
    return ExpansionTile(
      title: Text(title, style: GoogleFonts.poppins()),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(description, style: GoogleFonts.poppins(color: AppColors.textSecondary)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Parametres', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Preferences'),
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Recevoir des alertes et rappels',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
                _saveSettings();
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'Mode sombre',
            subtitle: 'Theme sombre pour l\'application',
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleTheme(),
          ),
          _buildListTile(
            icon: Icons.language_outlined,
            title: 'Langue',
            subtitle: _selectedLanguage,
            onTap: () => _showLanguageDialog(localeProvider),
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Compte'),
          _buildListTile(
            icon: Icons.person_outline,
            title: 'Modifier le profil',
            subtitle: 'Informations personnelles',
            onTap: () => context.go('/profil'),
          ),
          _buildListTile(
            icon: Icons.emoji_events_outlined,
            title: 'Mes badges',
            subtitle: 'Voir les badges debloques',
            onTap: () => context.go('/badges'),
          ),
          _buildListTile(
            icon: Icons.history_rounded,
            title: 'Historique des points',
            subtitle: 'Voir toutes tes transactions',
            onTap: () => context.go('/points'),
          ),

          const SizedBox(height: 24),

          _buildSectionTitle('Support'),
          _buildListTile(
            icon: Icons.help_outline,
            title: 'Aide',
            subtitle: 'FAQ et assistance',
            onTap: _showHelp,
          ),
          _buildListTile(
            icon: Icons.share_outlined,
            title: 'Partager l\'application',
            subtitle: 'Invite tes amis',
            onTap: _shareApp,
          ),
          _buildListTile(
            icon: Icons.star_outline,
            title: 'Noter l\'application',
            subtitle: 'Donne ton avis',
            onTap: () {},
          ),

          const SizedBox(height: 24),

          _buildListTile(
            icon: Icons.logout,
            title: 'Deconnexion',
            subtitle: 'Quitter le compte',
            iconColor: AppColors.error,
            textColor: AppColors.error,
            onTap: _logout,
          ),

          const SizedBox(height: 40),
          Center(child: Text('Version 1.0.0', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary))),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: (iconColor ?? AppColors.primary).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
        ),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: textColor ?? AppColors.textPrimary)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
        trailing: Switch(value: value, onChanged: onChanged, activeTrackColor: AppColors.primary, activeThumbColor: Colors.white),
      ),
    );
  }

  void _showLanguageDialog(LocaleProvider localeProvider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text('Choisir la langue', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const Divider(),
            _buildLanguageOption('Francais', 'fr', localeProvider),
            _buildLanguageOption('English', 'en', localeProvider),
            _buildLanguageOption('Espanol', 'es', localeProvider),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String label, String code, LocaleProvider provider) {
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
      trailing: isSelected ? Icon(Icons.check_rounded, color: AppColors.primary) : null,
    );
  }
}