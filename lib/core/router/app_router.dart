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

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
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
          builder: (context, state) => const ValidationScreen(),
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
      ],
    ),
  ],
);