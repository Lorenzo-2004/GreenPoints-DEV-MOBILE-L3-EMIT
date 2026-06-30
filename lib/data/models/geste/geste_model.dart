import '../../../domain/entities/geste_entity.dart';
import '../../../domain/enums/action_category.dart';

class GesteModel extends GesteEntity {
  final String? iconUrl;

  const GesteModel({
    required super.id,
    required super.title,
    required super.description,
    required super.points,
    required super.category,
    required super.isDaily,
    this.iconUrl,
  });

  factory GesteModel.fromMap(Map<String, dynamic> map, String id) {
    return GesteModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      points: map['points'] ?? 0,
      category: ActionCategory.values.firstWhere(
        (c) => c.name == map['category'],
        orElse: () => ActionCategory.nature,
      ),
      isDaily: map['isDaily'] ?? false,
      iconUrl: map['iconUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'points': points,
      'category': category.name,
      'isDaily': isDaily,
      'iconUrl': iconUrl,
    };
  }
}