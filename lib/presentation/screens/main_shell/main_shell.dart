import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: _BottomNav(),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 10,
        top: 8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppColors.glassShadow,
              blurRadius: 40,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    iconActive: Icons.home_rounded,
                    label: 'Accueil',
                    path: '/home',
                    isActive: location == '/home',
                  ),
                  _NavItem(
                    icon: Icons.eco_outlined,
                    iconActive: Icons.eco_rounded,
                    label: 'Gestes',
                    path: '/gestes',
                    isActive: location.startsWith('/gestes'),
                  ),
                  const SizedBox(width: 54),
                  _NavItem(
                    icon: Icons.emoji_events_outlined,
                    iconActive: Icons.emoji_events_rounded,
                    label: 'Défis',
                    path: '/defis',
                    isActive: location.startsWith('/defis'),
                  ),
                  _NavItem(
                    icon: Icons.person_outline,
                    iconActive: Icons.person_rounded,
                    label: 'Profil',
                    path: '/profil',
                    isActive: location.startsWith('/profil'),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -22,
              child: _NavItemCenter(
                isActive: location.startsWith('/valider'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData iconActive;
  final String label;
  final String path;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.iconActive,
    required this.label,
    required this.path,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        context.go(path);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surfaceAlt : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isActive
              ? Border.all(color: AppColors.borderSubtle)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? iconActive : icon,
                key: ValueKey(isActive),
                color: isActive
                    ? AppColors.primary
                    : AppColors.textSecondary,
                size: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItemCenter extends StatelessWidget {
  final bool isActive;

  const _NavItemCenter({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        context.go('/valider');
      },
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.glassShadowDeep,
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}