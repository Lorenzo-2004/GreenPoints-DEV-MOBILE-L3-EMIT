import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/theme/app_colors.dart';

enum NotificationType {
  points,
  badge,
  defi,
  geste,
  reminder,
  achievement,
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.isRead,
    this.data,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: _stringToType(map['type'] ?? 'geste'),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
      data: map['data'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'type': _typeToString(type),
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      'data': data,
    };
  }

  static NotificationType _stringToType(String value) {
    switch (value) {
      case 'points': return NotificationType.points;
      case 'badge': return NotificationType.badge;
      case 'defi': return NotificationType.defi;
      case 'geste': return NotificationType.geste;
      case 'reminder': return NotificationType.reminder;
      case 'achievement': return NotificationType.achievement;
      default: return NotificationType.geste;
    }
  }

  static String _typeToString(NotificationType type) {
    switch (type) {
      case NotificationType.points: return 'points';
      case NotificationType.badge: return 'badge';
      case NotificationType.defi: return 'defi';
      case NotificationType.geste: return 'geste';
      case NotificationType.reminder: return 'reminder';
      case NotificationType.achievement: return 'achievement';
    }
  }

  IconData get icon {
    switch (type) {
      case NotificationType.points:
        return Icons.stars_rounded;
      case NotificationType.badge:
        return Icons.emoji_events_rounded;
      case NotificationType.defi:
        return Icons.flag_rounded;
      case NotificationType.geste:
        return Icons.eco_rounded;
      case NotificationType.reminder:
        return Icons.alarm_rounded;
      case NotificationType.achievement:
        return Icons.emoji_events_rounded;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.points:
        return AppColors.warning;
      case NotificationType.badge:
        return AppColors.accent;
      case NotificationType.defi:
        return const Color(0xFF8B5CF6);
      case NotificationType.geste:
        return AppColors.success;
      case NotificationType.reminder:
        return const Color(0xFF06B6D4);
      case NotificationType.achievement:
        return const Color(0xFFF59E0B);
    }
  }
}