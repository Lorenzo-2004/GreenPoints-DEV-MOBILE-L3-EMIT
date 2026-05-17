import 'package:equatable/equatable.dart';
import '../enums/level_type.dart';

class LevelEntity extends Equatable {
  final LevelType type;
  final String name;
  final String emoji;
  final int minPoints;
  final int maxPoints;

  const LevelEntity({
    required this.type,
    required this.name,
    required this.emoji,
    required this.minPoints,
    required this.maxPoints,
  });

  double progressTo(int currentPoints) {
    if (maxPoints == 999999) return 1.0;
    final range = maxPoints - minPoints;
    final progress = currentPoints - minPoints;
    return (progress / range).clamp(0.0, 1.0);
  }

  int pointsToNext(int currentPoints) {
    if (maxPoints == 999999) return 0;
    return maxPoints - currentPoints + 1;
  }

  @override
  List<Object?> get props => [type, minPoints, maxPoints];
}