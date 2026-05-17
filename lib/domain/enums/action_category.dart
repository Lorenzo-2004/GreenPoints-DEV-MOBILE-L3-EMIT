import 'package:flutter/material.dart';

enum ActionCategory {
  transport,
  alimentation,
  energie,
  dechets,
  eau,
  nature,
}

extension ActionCategoryExt on ActionCategory {
  String get label {
    switch (this) {
      case ActionCategory.transport: return 'Transport';
      case ActionCategory.alimentation: return 'Alimentation';
      case ActionCategory.energie: return 'Énergie';
      case ActionCategory.dechets: return 'Déchets';
      case ActionCategory.eau: return 'Eau';
      case ActionCategory.nature: return 'Nature';
    }
  }

  String get emoji {
    switch (this) {
      case ActionCategory.transport: return '🚲';
      case ActionCategory.alimentation: return '🥗';
      case ActionCategory.energie: return '⚡';
      case ActionCategory.dechets: return '♻️';
      case ActionCategory.eau: return '💧';
      case ActionCategory.nature: return '🌿';
    }
  }

  IconData get icon {
    switch (this) {
      case ActionCategory.transport: return Icons.directions_bike;
      case ActionCategory.alimentation: return Icons.restaurant;
      case ActionCategory.energie: return Icons.bolt;
      case ActionCategory.dechets: return Icons.recycling;
      case ActionCategory.eau: return Icons.water_drop;
      case ActionCategory.nature: return Icons.park;
    }
  }

  Color get color {
    switch (this) {
      case ActionCategory.transport: return const Color(0xFF4CAF50);
      case ActionCategory.alimentation: return const Color(0xFF8BC34A);
      case ActionCategory.energie: return const Color(0xFFFFC107);
      case ActionCategory.dechets: return const Color(0xFF009688);
      case ActionCategory.eau: return const Color(0xFF2196F3);
      case ActionCategory.nature: return const Color(0xFF3B6D11);
    }
  }
}