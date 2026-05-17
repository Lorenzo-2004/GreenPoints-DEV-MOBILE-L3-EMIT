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

  // Gestes par défaut
  static const List<Map<String, dynamic>> defaults = [
    {
      'id': 'velo_travail',
      'title': 'Aller au travail à vélo',
      'description': 'Remplace ta voiture par le vélo',
      'points': 20,
      'category': 'transport',
      'isDaily': true,
    },
    {
      'id': 'repas_vege',
      'title': 'Repas végétarien',
      'description': 'Mange un repas sans viande aujourd\'hui',
      'points': 15,
      'category': 'alimentation',
      'isDaily': true,
    },
    {
      'id': 'douche_courte',
      'title': 'Douche de moins de 5 min',
      'description': 'Limite ta douche à 5 minutes',
      'points': 10,
      'category': 'eau',
      'isDaily': true,
    },
    {
      'id': 'tri_dechets',
      'title': 'Trier ses déchets',
      'description': 'Trie correctement tes déchets du jour',
      'points': 10,
      'category': 'dechets',
      'isDaily': true,
    },
    {
      'id': 'sac_reutilisable',
      'title': 'Sac réutilisable',
      'description': 'Utilise un sac réutilisable pour tes courses',
      'points': 5,
      'category': 'dechets',
      'isDaily': false,
    },
    {
      'id': 'transport_commun',
      'title': 'Transports en commun',
      'description': 'Utilise les transports en commun',
      'points': 15,
      'category': 'transport',
      'isDaily': true,
    },
    {
      'id': 'planter_arbre',
      'title': 'Planter un arbre',
      'description': 'Plante un arbre ou participe à un reboisement',
      'points': 50,
      'category': 'nature',
      'isDaily': false,
    },
    {
      'id': 'lumiere_eteinte',
      'title': 'Éteindre les lumières',
      'description': 'Éteins toutes les lumières inutilisées',
      'points': 5,
      'category': 'energie',
      'isDaily': true,
    },
  ];
}