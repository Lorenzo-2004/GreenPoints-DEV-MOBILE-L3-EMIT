import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/onboarding/onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  double _pageOffset = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    if (mounted) {
      context.go('/login');
    }
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primaryDark,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Indicateurs de page animés
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: _currentPage == index ? 28 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
              ),

              // PageView avec animations de transition
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _AnimatedOnboardingPage(
                      data: onboardingData[index],
                      index: index,
                      currentIndex: _currentPage,
                      pageOffset: _pageOffset,
                    );
                  },
                ),
              ),

              // Boutons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage < onboardingData.length - 1)
                      TextButton(
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Passer',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 70),

                    GestureDetector(
                      onTap: _currentPage == onboardingData.length - 1
                          ? _completeOnboarding
                          : _nextPage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.2),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          _currentPage == onboardingData.length - 1
                              ? 'Commencer'
                              : 'Suivant',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedOnboardingPage extends StatelessWidget {
  final OnboardingModel data;
  final int index;
  final int currentIndex;
  final double pageOffset;

  const _AnimatedOnboardingPage({
    required this.data,
    required this.index,
    required this.currentIndex,
    required this.pageOffset,
  });

  @override
  Widget build(BuildContext context) {
    // Calculer l'offset relatif pour l'animation
    final relativeOffset = (index - pageOffset).abs();
    final isActive = index == currentIndex;
    
    // Facteur d'animation (plus l'offset est grand, plus l'opacité diminue)
    final opacity = isActive ? 1.0 : (1.0 - relativeOffset * 0.5).clamp(0.0, 1.0);
    final scale = isActive ? 1.0 : (1.0 - relativeOffset * 0.1).clamp(0.8, 1.0);
    final translateY = isActive ? 0.0 : (relativeOffset * 50).clamp(0.0, 100.0);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Transform.translate(
          offset: Offset(0, translateY),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône animée au chargement de la page
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: data.color.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: data.color.withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          data.icon,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 48),
                
                // Titre animé
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                
                // Description animée
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: Text(
                          data.description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.4,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}