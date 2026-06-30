import 'package:cloud_firestore/cloud_firestore.dart';

class InitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initAllData() async {
    await initGestes();
    await initDefis();
    await initBadges();
    await initRecompenses();
  }

  Future<void> initRecompenses() async {
    final snapshot = await _firestore.collection('recompenses').get();
    if (snapshot.docs.isNotEmpty) return;

    final recompenses = [
      {
        'id': '1',
        'title': 'Plante verte',
        'description': 'Une plante pour ton bureau',
        'points': 500,
        'icon': 'local_florist',
        'category': 'Plantes',
        'stock': 10,
      },
      {
        'id': '2',
        'title': 'Gourde isotherme',
        'description': 'Gourde en acier inoxydable',
        'points': 1000,
        'icon': 'water_bottle',
        'category': 'Accessoires',
        'stock': 5,
      },
      {
        'id': '3',
        'title': 'Sac à courses',
        'description': 'Sac en tissu réutilisable',
        'points': 300,
        'icon': 'shopping_bag',
        'category': 'Éco-produits',
        'stock': 20,
      },
      {
        'id': '4',
        'title': 'Composteur',
        'description': 'Composteur de balcon',
        'points': 2000,
        'icon': 'yard',
        'category': 'Éco-produits',
        'stock': 3,
      },
      {
        'id': '5',
        'title': 'Badge exclusif',
        'description': 'Badge spécial GreenPoints',
        'points': 1500,
        'icon': 'emoji_events',
        'category': 'Exclusifs',
        'stock': 50,
      },
    ];

    for (final rec in recompenses) {
      await _firestore.collection('recompenses').doc(rec['id'] as String).set(rec);
    }
  }

  Future<void> initGestes() async {
    final snapshot = await _firestore.collection('gestes').get();
    if (snapshot.docs.isNotEmpty) return;

    final gestes = [
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
        'id': 'trier_dechets',
        'title': 'Trier ses déchets',
        'description': 'Trie correctement tes déchets du jour',
        'points': 10,
        'category': 'dechets',
        'isDaily': true,
      },
      {
        'id': 'eteindre_lumieres',
        'title': 'Éteindre les lumières',
        'description': 'Éteins les lumières en quittant une pièce',
        'points': 5,
        'category': 'energie',
        'isDaily': true,
      },
      {
        'id': 'composter',
        'title': 'Composter',
        'description': 'Utilise ton composteur pour les déchets organiques',
        'points': 15,
        'category': 'dechets',
        'isDaily': false,
      },
      {
        'id': 'marche_ecolo',
        'title': 'Marcher au lieu de conduire',
        'description': 'Fais tes trajets courts à pied',
        'points': 15,
        'category': 'transport',
        'isDaily': true,
      },
      {
        'id': 'eau_robinet',
        'title': 'Boire l\'eau du robinet',
        'description': 'Évite les bouteilles en plastique',
        'points': 10,
        'category': 'eau',
        'isDaily': true,
      },
      {
        'id': 'sacs_reutilisables',
        'title': 'Sacs réutilisables',
        'description': 'Utilise des sacs réutilisables pour tes courses',
        'points': 10,
        'category': 'dechets',
        'isDaily': false,
      },
      {
        'id': 'jardin_potager',
        'title': 'Cultiver son potager',
        'description': 'Plante tes propres légumes',
        'points': 30,
        'category': 'nature',
        'isDaily': false,
      },
    ];

    for (final geste in gestes) {
      await _firestore.collection('gestes').doc(geste['id'] as String).set(geste);
    }
  }

  Future<void> initDefis() async {
    final snapshot = await _firestore.collection('defis').get();
    if (snapshot.docs.isNotEmpty) return;

    final defis = [
      {
        'id': 'ecowarrior',
        'title': 'Ecowarrior',
        'subtitle': '10 gestes ecologiques en une semaine',
        'points': 500,
        'progress': 0.0,
        'daysLeft': 7,
        'category': 'Hebdomadaire',
        'icon': 'eco',
        'color': '#059669',
      },
      {
        'id': 'sans_voiture',
        'title': 'Sans voiture',
        'subtitle': 'Transport en commun ou velo pendant 7 jours',
        'points': 300,
        'progress': 0.0,
        'daysLeft': 7,
        'category': 'Transport',
        'icon': 'directions_bike',
        'color': '#3B82F6',
      },
      {
        'id': 'zero_dechet',
        'title': 'Zero dechet',
        'subtitle': 'Ne produis aucun dechet plastique cette semaine',
        'points': 400,
        'progress': 0.0,
        'daysLeft': 7,
        'category': 'Quotidien',
        'icon': 'recycling',
        'color': '#10B981',
      },
      {
        'id': 'master_chef_vege',
        'title': 'Master chef vege',
        'subtitle': '5 repas vegetariens dans la semaine',
        'points': 250,
        'progress': 0.0,
        'daysLeft': 7,
        'category': 'Alimentation',
        'icon': 'restaurant',
        'color': '#F59E0B',
      },
      {
        'id': 'economiseur_eau',
        'title': 'Economiseur d\'eau',
        'subtitle': 'Douches courtes pendant 5 jours',
        'points': 200,
        'progress': 0.0,
        'daysLeft': 5,
        'category': 'Quotidien',
        'icon': 'water_drop',
        'color': '#06B6D4',
      },
    ];

    for (final defi in defis) {
      await _firestore.collection('defis').doc(defi['id'] as String).set(defi);
    }
  }

  Future<void> initBadges() async {
    final snapshot = await _firestore.collection('badges').get();
    if (snapshot.docs.isNotEmpty) return;

    final badges = [
      {
        'id': 'premier_pas',
        'title': 'Premier pas',
        'description': 'Valide ton premier geste ecologique',
        'icon': 'star',
        'pointsRequired': 10,
      },
      {
        'id': 'eco_warrior',
        'title': 'Eco warrior',
        'description': 'Valide 50 gestes ecologiques',
        'icon': 'shield',
        'pointsRequired': 500,
      },
      {
        'id': 'green_master',
        'title': 'Green master',
        'description': 'Atteins 1000 points',
        'icon': 'crown',
        'pointsRequired': 1000,
      },
      {
        'id': 'streak_7',
        'title': 'Semaine verte',
        'description': '7 jours consecutifs d\'actions',
        'icon': 'calendar',
        'pointsRequired': 7,
      },
    ];

    for (final badge in badges) {
      await _firestore.collection('badges').doc(badge['id'] as String).set(badge);
    }
  }
}