import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Délai pour laisser l'animation se jouer
    await Future.delayed(const Duration(milliseconds: 2800));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // LOGO ACTUALISÉ
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 7, 30, 243).withValues(alpha: 0.2),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.asset(
                    'assets/images/logo/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ).animate()
                .scale(
                  begin: const Offset(0.3, 0.3),
                  end: const Offset(1.0, 1.0),
                  duration: 800.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(duration: 500.ms),

              const SizedBox(height: 32),

              // Titre principal
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Green',
                      style: GoogleFonts.poppins(
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -1,
                      ),
                    ),
                    TextSpan(
                      text: 'Points',
                      style: GoogleFonts.poppins(
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        color: AppColors.warning,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 250.ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.4, end: 0),

              const Spacer(),

              // Loader
              _LoadingDots()
                .animate(delay: 800.ms)
                .fadeIn(duration: 400.ms),

              const SizedBox(height: 48),

              // Version
              Text(
                'Version 1.0.0',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.4),
                  fontWeight: FontWeight.w500,
                ),
              ).animate(delay: 800.ms)
                .fadeIn(duration: 300.ms),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      Future.delayed(Duration(milliseconds: i * 180), () {
        if (mounted) c.repeat(reverse: true);
      });
      return c;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _controllers[i],
          builder: (_, __) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            width: 8,
            height: 8 + (_controllers[i].value * 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.4 + _controllers[i].value * 0.6,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}