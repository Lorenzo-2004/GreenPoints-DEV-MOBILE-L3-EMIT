import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/register/register_screen.dart';
import '../../presentation/screens/main_shell/main_shell.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/gestes/gestes_screen.dart';
import '../../presentation/screens/profil/profil_screen.dart';
import '../../presentation/screens/defis/defis_screen.dart';
import '../../presentation/screens/validation/validation_screen.dart';
import '../../presentation/screens/notifications/notifications_screen.dart';
import '../../presentation/screens/badges/badges_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/points/points_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/marketplace/marketplace_screen.dart';
import '../../presentation/screens/social/social_screen.dart';
import '../../data/models/geste/geste_model.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Routes sans shell
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // Routes avec shell (application principale)
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/gestes',
          name: 'gestes',
          builder: (context, state) => const GestesScreen(),
        ),
        GoRoute(
  path: '/valider',
  name: 'validation',
  builder: (context, state) {
    final extra = state.extra;
    return ValidationScreen(initialGeste: extra is GesteModel ? extra : null);
  },
),
        GoRoute(
          path: '/defis',
          name: 'defis',
          builder: (context, state) => const DefisScreen(),
        ),
        GoRoute(
          path: '/profil',
          name: 'profil',
          builder: (context, state) => const ProfilScreen(),
        ),
        GoRoute(
          path: '/notifications',
          name: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: '/badges',
          name: 'badges',
          builder: (context, state) => const BadgesScreen(),
        ),
        GoRoute(
          path: '/points',
          name: 'points',
          builder: (context, state) => const PointsScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/marketplace',
          name: 'marketplace',
          builder: (context, state) => const MarketplaceScreen(),
        ),
        GoRoute(
          path: '/social',
          name: 'social',
          builder: (context, state) => const SocialScreen(),
        ),
      ],
    ),
  ],
);