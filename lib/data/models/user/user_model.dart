import 'package:flutter/material.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/level_entity.dart';
import '../../../domain/enums/level_type.dart';
import '../../../core/theme/app_colors.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phoneNumber,
    super.photoUrl,
    required super.totalPoints,
    required super.weeklyPoints,
    required super.level,
    required super.streak,
    required super.createdAt,
    required super.completedActionIds,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    final points = map['totalPoints'] ?? 0;
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      photoUrl: map['photoUrl'],
      totalPoints: points,
      weeklyPoints: map['weeklyPoints'] ?? 0,
      level: LevelModel.fromPoints(points),
      streak: map['streak'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      completedActionIds: List<String>.from(map['completedActionIds'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'totalPoints': totalPoints,
      'weeklyPoints': weeklyPoints,
      'streak': streak,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'completedActionIds': completedActionIds,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    int? totalPoints,
    int? weeklyPoints,
    LevelEntity? level,
    int? streak,
    List<String>? completedActionIds,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      totalPoints: totalPoints ?? this.totalPoints,
      weeklyPoints: weeklyPoints ?? this.weeklyPoints,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      createdAt: createdAt,
      completedActionIds: completedActionIds ?? this.completedActionIds,
    );
  }
}

class LevelModel extends LevelEntity {
  final Color color;
  final IconData icon;

  const LevelModel({
    required super.type,
    required super.name,
    required super.emoji,
    required super.minPoints,
    required super.maxPoints,
    required this.color,
    required this.icon,
  });

  static const List<LevelModel> levels = [
    LevelModel(
      type: LevelType.graine,
      name: 'Graine',
      emoji: '🌱',
      icon: Icons.grass,
      minPoints: 0,
      maxPoints: 99,
      color: AppColors.level1,
    ),
    LevelModel(
      type: LevelType.pousse,
      name: 'Pousse',
      emoji: '🌿',
      icon: Icons.eco,
      minPoints: 100,
      maxPoints: 299,
      color: AppColors.level2,
    ),
    LevelModel(
      type: LevelType.rameau,
      name: 'Rameau',
      emoji: '🍃',
      icon: Icons.park,
      minPoints: 300,
      maxPoints: 699,
      color: AppColors.level3,
    ),
    LevelModel(
      type: LevelType.arbre,
      name: 'Arbre',
      emoji: '🌳',
      icon: Icons.nature,
      minPoints: 700,
      maxPoints: 1499,
      color: AppColors.level4,
    ),
    LevelModel(
      type: LevelType.foret,
      name: 'Forêt',
      emoji: '🌲',
      icon: Icons.forest,
      minPoints: 1500,
      maxPoints: 2999,
      color: AppColors.level5,
    ),
    LevelModel(
      type: LevelType.gardien,
      name: 'Gardien',
      emoji: '🌍',
      icon: Icons.public,
      minPoints: 3000,
      maxPoints: 999999,
      color: AppColors.primary,
    ),
  ];

  static LevelModel fromPoints(int points) {
    return levels.lastWhere(
      (l) => points >= l.minPoints,
      orElse: () => levels.first,
    );
  }
}