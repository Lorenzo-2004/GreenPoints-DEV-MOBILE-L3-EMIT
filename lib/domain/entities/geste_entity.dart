import 'package:equatable/equatable.dart';
import '../enums/action_category.dart';

class GesteEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final int points;
  final ActionCategory category;
  final bool isDaily;

  const GesteEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.category,
    required this.isDaily,
  });

  @override
  List<Object?> get props => [id, title, points, category, isDaily];
}