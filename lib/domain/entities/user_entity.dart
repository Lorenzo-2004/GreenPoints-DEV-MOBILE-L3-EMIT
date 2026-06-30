import 'package:equatable/equatable.dart';
import 'level_entity.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? phoneNumber;
  final int totalPoints;
  final int weeklyPoints;
  final LevelEntity level;
  final int streak;
  final DateTime createdAt;
  final List<String> completedActionIds;
  final Map<String, double> defisProgress;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.phoneNumber,
    required this.totalPoints,
    required this.weeklyPoints,
    required this.level,
    required this.streak,
    required this.createdAt,
    required this.completedActionIds,
    this.defisProgress = const {},
  });

  @override
  List<Object?> get props => [
        id, name, email, totalPoints,
        weeklyPoints, streak, createdAt,
      ];
}