import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

const List<OnboardingModel> onboardingData = [
  OnboardingModel(
    title: 'Gestes Écologiques',
    description: 'Découvrez et validez des gestes éco-responsables au quotidien',
    icon: Icons.eco_rounded,
    color: Color(0xFF059669),
  ),
  OnboardingModel(
    title: 'Gagnez des Points',
    description: 'Chaque geste validé vous rapporte des points à cumuler',
    icon: Icons.stars_rounded,
    color: Color(0xFFF59E0B),
  ),
  OnboardingModel(
    title: 'Défis & Récompenses',
    description: 'Relevez des défis et débloquez des récompenses exclusives',
    icon: Icons.emoji_events_rounded,
    color: Color(0xFF8B5CF6),
  ),
];