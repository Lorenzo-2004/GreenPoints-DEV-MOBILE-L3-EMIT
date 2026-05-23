class RecompenseModel {
  final String id;
  final String title;
  final String description;
  final int points;
  final String icon;
  final String category;
  final int stock;

  RecompenseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
    required this.category,
    required this.stock,
  });

  factory RecompenseModel.fromMap(Map<String, dynamic> map, String id) {
    return RecompenseModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      points: map['points'] ?? 0,
      icon: map['icon'] ?? 'local_florist',
      category: map['category'] ?? 'Autre',
      stock: map['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'points': points,
      'icon': icon,
      'category': category,
      'stock': stock,
    };
  }
}