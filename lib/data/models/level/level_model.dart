import 'package:flutter/material.dart';
import '../../../domain/enums/level_type.dart';

class LevelModel {
  final LevelType type;
  final String name;
  final String emoji;
  final int minPoints;
  final IconData icon;
  final Color color;

  const LevelModel({
    required this.type,
    required this.name,
    required this.emoji,
    required this.minPoints,
    required this.icon,
    required this.color,
  });

  static const LevelModel graine = LevelModel(
    type: LevelType.graine,
    name: 'Graine',
    emoji: '🌱',
    minPoints: 0,
    icon: Icons.grass_rounded,
    color: Color(0xFFD1FAE5),
  );

  static const LevelModel pousse = LevelModel(
    type: LevelType.pousse,
    name: 'Pousse',
    emoji: '🌿',
    minPoints: 100,
    icon: Icons.eco_rounded,
    color: Color(0xFF6EE7B7),
  );

  static const LevelModel rameau = LevelModel(
    type: LevelType.rameau,
    name: 'Rameau',
    emoji: '🍃',
    minPoints: 300,
    icon: Icons.nature_rounded,
    color: Color(0xFF34D399),
  );

  static const LevelModel arbre = LevelModel(
    type: LevelType.arbre,
    name: 'Arbre',
    emoji: '🌳',
    minPoints: 600,
    icon: Icons.park_rounded,
    color: Color(0xFF059669),
  );

  static const LevelModel foret = LevelModel(
    type: LevelType.foret,
    name: 'Forêt',
    emoji: '🌲',
    minPoints: 1000,
    icon: Icons.forest_rounded,
    color: Color(0xFF047857),
  );

  static const LevelModel gardien = LevelModel(
    type: LevelType.gardien,
    name: 'Gardien',
    emoji: '🛡️',
    minPoints: 1500,
    icon: Icons.shield_rounded,
    color: Color(0xFF064E3B),
  );

  static List<LevelModel> get levels => [
    graine,
    pousse,
    rameau,
    arbre,
    foret,
    gardien,
  ];

  static LevelModel fromPoints(int points) {
    if (points < 100) return graine;
    if (points < 300) return pousse;
    if (points < 600) return rameau;
    if (points < 1000) return arbre;
    if (points < 1500) return foret;
    return gardien;
  }

  double progressTo(int points) {
    final index = levels.indexOf(this);
    if (index == levels.length - 1) return 1.0;
    final next = levels[index + 1];
    final range = next.minPoints - minPoints;
    final progress = points - minPoints;
    return (progress / range).clamp(0.0, 1.0);
  }

  int pointsToNext(int points) {
    final index = levels.indexOf(this);
    if (index == levels.length - 1) return 0;
    final next = levels[index + 1];
    return next.minPoints - points;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LevelModel && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;
}