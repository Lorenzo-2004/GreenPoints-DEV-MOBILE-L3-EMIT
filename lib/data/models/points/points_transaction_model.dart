import '../../../domain/entities/points_transaction_entity.dart';

class PointsTransactionModel extends PointsTransactionEntity {
  const PointsTransactionModel({
    required super.id,
    required super.userId,
    required super.gesteId,
    required super.gesteTitle,
    required super.points,
    required super.type,
    required super.createdAt,
  });

  factory PointsTransactionModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return PointsTransactionModel(
      id: id,
      userId: map['userId'] ?? '',
      gesteId: map['gesteId'] ?? '',
      gesteTitle: map['gesteTitle'] ?? '',
      points: map['points'] ?? 0,
      type: TransactionType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => TransactionType.earned,
      ),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'gesteId': gesteId,
      'gesteTitle': gesteTitle,
      'points': points,
      'type': type.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}