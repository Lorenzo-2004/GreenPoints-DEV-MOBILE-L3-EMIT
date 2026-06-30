import 'package:flutter/material.dart';

class DefiModel {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final int points;
  final double progress;
  final int daysLeft;
  final String icon;
  final Color color;

  DefiModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.points,
    required this.progress,
    required this.daysLeft,
    required this.icon,
    required this.color,
  });

  factory DefiModel.fromMap(Map<String, dynamic> map, String id, Color parsedColor) {
    return DefiModel(
      id: id,
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      category: map['category'] ?? 'Tous',
      points: map['points'] ?? 0,
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
      daysLeft: map['daysLeft'] ?? 0,
      icon: map['icon'] ?? 'eco',
      color: parsedColor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'points': points,
      'progress': progress,
      'daysLeft': daysLeft,
      'icon': icon,
    };
  }
}
