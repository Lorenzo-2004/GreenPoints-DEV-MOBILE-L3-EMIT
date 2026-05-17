import 'package:equatable/equatable.dart';

enum TransactionType { earned, bonus, streak }

class PointsTransactionEntity extends Equatable {
  final String id;
  final String userId;
  final String gesteId;
  final String gesteTitle;
  final int points;
  final TransactionType type;
  final DateTime createdAt;

  const PointsTransactionEntity({
    required this.id,
    required this.userId,
    required this.gesteId,
    required this.gesteTitle,
    required this.points,
    required this.type,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, gesteId, points, createdAt];
}