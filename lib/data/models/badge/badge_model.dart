import 'package:flutter/material.dart';

enum BadgeType {
  beginner,
  intermediate,
  advanced,
  master,
}

class BadgeModel {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int pointsRequired;
  final BadgeType type;
  final bool isUnlocked;

  BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.pointsRequired,
    required this.type,
    this.isUnlocked = false,
  });

  Color get color {
    switch (type) {
      case BadgeType.beginner:
        return const Color(0xFF10B981);
      case BadgeType.intermediate:
        return const Color(0xFF3B82F6);
      case BadgeType.advanced:
        return const Color(0xFFF59E0B);
      case BadgeType.master:
        return const Color(0xFF8B5CF6);
    }
  }

  String get progressText {
    return '$pointsRequired pts requis';
  }

  factory BadgeModel.fromMap(Map<String, dynamic> map, String id) {
    return BadgeModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: _getIconFromString(map['icon'] ?? 'star'),
      pointsRequired: map['pointsRequired'] ?? 0,
      type: _getTypeFromString(map['type'] ?? 'beginner'),
    );
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'star': return Icons.star_rounded;
      case 'shield': return Icons.shield_rounded;
      case 'crown': return Icons.emoji_events_rounded;
      case 'calendar': return Icons.calendar_today_rounded;
      default: return Icons.emoji_events_rounded;
    }
  }

  static BadgeType _getTypeFromString(String type) {
    switch (type) {
      case 'beginner': return BadgeType.beginner;
      case 'intermediate': return BadgeType.intermediate;
      case 'advanced': return BadgeType.advanced;
      case 'master': return BadgeType.master;
      default: return BadgeType.beginner;
    }
  }
}