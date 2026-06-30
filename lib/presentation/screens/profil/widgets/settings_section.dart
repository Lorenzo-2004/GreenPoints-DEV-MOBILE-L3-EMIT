import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../presentation/providers/theme_provider.dart';
import '../../../../presentation/blocs/auth/auth_cubit.dart';
import '../../../../presentation/blocs/user/user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  void _showEditProfileDialog(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    final user = userCubit.state;
    if (user == null) return;

    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phoneNumber ?? '');

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: Theme.of(ctx).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Modifier le profil',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Theme.of(ctx).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: Theme.of(ctx).textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  labelText: 'Nom et Prénom',
                  labelStyle: TextStyle(color: Theme.of(ctx).textTheme.bodyMedium?.color),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.2) : AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Theme.of(ctx).textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  labelText: 'Numéro de téléphone',
                  labelStyle: TextStyle(color: Theme.of(ctx).textTheme.bodyMedium?.color),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? Colors.white.withValues(alpha: 0.2) : AppColors.border),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Annuler',
                style: GoogleFonts.poppins(color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final updatedUser = user.copyWith(
                  name: nameController.text.trim(),
                  phoneNumber: phoneController.text.trim().isNotEmpty ? phoneController.text.trim() : null,
                );
                userCubit.updateUser(updatedUser);
                Navigator.pop(ctx);
              },
              child: Text('Enregistrer', style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserCubit>().state;
    final isAdmin = user?.email == 'lorenzorafanomezantsoa@gmail.com';
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              l10n.settings_title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Theme.of(context).dividerColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              _SettingsTile(
                icon: Icons.person_outline,
                iconColor: AppColors.primary,
                label: l10n.settings_edit_profile,
                subtitle: l10n.settings_edit_profile_subtitle,
                onTap: () => _showEditProfileDialog(context),
              ),
              if (isAdmin) ...[
                _Divider(),
                _SettingsTile(
                  icon: Icons.admin_panel_settings_outlined,
                  iconColor: AppColors.info,
                  label: l10n.settings_admin_panel,
                  subtitle: l10n.settings_admin_panel_subtitle,
                  onTap: () => context.push('/admin'),
                ),
              ],
              _Divider(),
              _SettingsTile(
                icon: context.watch<ThemeProvider>().isDarkMode
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                iconColor: AppColors.warning,
                label: l10n.settings_theme,
                subtitle: l10n.settings_theme_subtitle,
                onTap: () {
                  context.read<ThemeProvider>().toggleTheme();
                },
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                iconColor: AppColors.accent, 
                label: l10n.settings_notifications,
                subtitle: l10n.settings_notifications_subtitle,
                onTap: () => context.push('/notifications'),
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.share_outlined,
                iconColor: AppColors.primary, 
                label: l10n.settings_share_app,
                subtitle: l10n.settings_share_app_subtitle,
                onTap: () {},
              ),
              _Divider(),
              _SettingsTile(
                icon: Icons.logout,
                iconColor: AppColors.error,
                label: l10n.settings_logout,
                subtitle: l10n.settings_logout_subtitle,
                onTap: () {
                  context.read<AuthCubit>().logout();
                  context.go('/login');
                },
                isDestructive: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iconColor.withValues(alpha: 0.15),
                      iconColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? AppColors.error : Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isDestructive)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}