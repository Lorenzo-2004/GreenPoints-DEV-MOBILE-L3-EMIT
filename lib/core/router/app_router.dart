import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/register/register_screen.dart';
import '../../presentation/screens/main_shell/main_shell.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/gestes/gestes_screen.dart';
import '../../presentation/screens/profil/profil_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),

    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/gestes',
          builder: (context, state) => const GestesScreen(),
        ),
        GoRoute(
          path: '/valider',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Valider — à venir')),
          ),
        ),
        GoRoute(
          path: '/defis',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Défis — à venir')),
          ),
        ),
        GoRoute(
          path: '/profil',
          builder: (context, state) => const ProfilScreen(),
        ),
      ],
    ),
  ],
);