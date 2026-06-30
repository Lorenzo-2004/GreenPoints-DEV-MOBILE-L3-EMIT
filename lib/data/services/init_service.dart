import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class InitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initAllData() async {
    try {
      await initGestes();
      await initDefis();
      await initBadges();
      await initRecompenses();
    } catch (e) {
      debugPrint('Erreur d\'initialisation globale: $e');
    }
  }

  Future<void> initRecompenses() async {
    final snapshot = await _firestore.collection('recompenses').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    final recompenses = [
      {'id': 'plante', 'title': 'Plante verte', 'description': 'Une plante pour ton bureau', 'points': 500, 'icon': 'local_florist', 'category': 'Plantes', 'stock': 10},
      {'id': 'gourde', 'title': 'Gourde isotherme', 'description': 'Gourde en acier inoxydable', 'points': 1000, 'icon': 'water_bottle', 'category': 'Accessoires', 'stock': 5},
      {'id': 'sac', 'title': 'Sac à courses en coton', 'description': 'Sac en tissu réutilisable écologique', 'points': 300, 'icon': 'shopping_bag', 'category': 'Éco-produits', 'stock': 20},
      {'id': 'composteur', 'title': 'Composteur de balcon', 'description': 'Transforme tes déchets organiques en engrais', 'points': 2000, 'icon': 'yard', 'category': 'Éco-produits', 'stock': 3},
      {'id': 'badge_vip', 'title': 'Badge exclusif VIP', 'description': 'Montre à tous ton implication', 'points': 1500, 'icon': 'emoji_events', 'category': 'Exclusifs', 'stock': 50},
      {'id': 'brosse_dent', 'title': 'Brosse à dents en bambou', 'description': 'Zéro plastique pour tes dents', 'points': 150, 'icon': 'spa', 'category': 'Soins', 'stock': 50},
      {'id': 'savon', 'title': 'Savon solide artisanal', 'description': 'Savon naturel fait main', 'points': 250, 'icon': 'clean_hands', 'category': 'Soins', 'stock': 30},
      {'id': 'billet', 'title': 'Billet expo écologie', 'description': 'Entrée gratuite pour le salon local', 'points': 3000, 'icon': 'local_activity', 'category': 'Exclusifs', 'stock': 2},
    ];

    for (final rec in recompenses) {
      await _firestore.collection('recompenses').doc(rec['id'] as String).set(rec);
    }
  }

  Future<void> initGestes() async {
    final snapshot = await _firestore.collection('gestes').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    final gestes = [
      {'id': 'velo_travail', 'title': 'Aller au travail à vélo', 'description': 'Remplace ta voiture par le vélo pour ton trajet aller-retour', 'points': 30, 'category': 'transport', 'isDaily': true},
      {'id': 'repas_vege', 'title': 'Repas végétarien', 'description': 'Mange un repas complet sans viande', 'points': 15, 'category': 'alimentation', 'isDaily': true},
      {'id': 'douche_courte', 'title': 'Douche de moins de 5 min', 'description': 'Limite ta douche à 5 minutes chrono pour économiser l\'eau', 'points': 10, 'category': 'eau', 'isDaily': true},
      {'id': 'tri_dechets', 'title': 'Trier ses déchets', 'description': 'Trie correctement tes déchets du jour (verre, carton, plastique)', 'points': 10, 'category': 'dechets', 'isDaily': true},
      {'id': 'lumiere', 'title': 'Éteindre les lumières', 'description': 'Éteins systématiquement les lumières en quittant une pièce', 'points': 5, 'category': 'energie', 'isDaily': true},
      {'id': 'compost', 'title': 'Composter ses restes', 'description': 'Jette tes restes alimentaires dans un composteur', 'points': 15, 'category': 'dechets', 'isDaily': true},
      {'id': 'marche', 'title': 'Trajet à pied (< 2km)', 'description': 'Fais tes trajets courts à pied au lieu de prendre un moteur', 'points': 20, 'category': 'transport', 'isDaily': true},
      {'id': 'gourde_eau', 'title': 'Utiliser une gourde', 'description': 'Refuse les bouteilles plastiques, utilise ta gourde', 'points': 10, 'category': 'dechets', 'isDaily': true},
      {'id': 'sac_tissu', 'title': 'Courses en vrac', 'description': 'Fais tes courses avec tes propres sacs en tissu', 'points': 25, 'category': 'dechets', 'isDaily': false},
      {'id': 'potager', 'title': 'Entretenir son potager', 'description': 'Jardine, plante ou récolte tes légumes maison', 'points': 30, 'category': 'nature', 'isDaily': false},
      {'id': 'covoiturage', 'title': 'Covoiturage', 'description': 'Partage ton trajet en voiture avec d\'autres personnes', 'points': 40, 'category': 'transport', 'isDaily': false},
      {'id': 'reparation', 'title': 'Réparer un objet', 'description': 'Au lieu de jeter, répare un appareil ou vêtement abîmé', 'points': 50, 'category': 'dechets', 'isDaily': false},
      {'id': 'local', 'title': 'Acheter local et de saison', 'description': 'Privilégie les circuits courts pour tes achats', 'points': 20, 'category': 'alimentation', 'isDaily': false},
      {'id': 'thermostat', 'title': 'Baisser le chauffage', 'description': 'Baisse ton chauffage de 1°C chez toi', 'points': 15, 'category': 'energie', 'isDaily': false},
      {'id': 'ramassage', 'title': 'Ramasser des déchets', 'description': 'Ramasse au moins 5 déchets trouvés par terre lors d\'une balade', 'points': 50, 'category': 'nature', 'isDaily': false},
    ];

    for (final geste in gestes) {
      await _firestore.collection('gestes').doc(geste['id'] as String).set(geste);
    }
  }

  Future<void> initDefis() async {
    final snapshot = await _firestore.collection('defis').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    final defis = [
      {'id': 'ecowarrior', 'title': 'Éco-Guerrier', 'subtitle': 'Valide au moins 10 gestes écologiques différents cette semaine', 'points': 500, 'daysLeft': 7, 'category': 'Hebdomadaire', 'icon': 'eco', 'color': '059669'},
      {'id': 'sans_voiture', 'title': 'Semaine Sans Voiture', 'subtitle': 'N\'utilise que le vélo, la marche ou les transports en commun pendant 7 jours', 'points': 600, 'daysLeft': 7, 'category': 'Transport', 'icon': 'directions_bike', 'color': '3B82F6'},
      {'id': 'zero_dechet', 'title': 'Défi Zéro Déchet', 'subtitle': 'Refuse tous les emballages plastiques jetables pendant 3 jours consécutifs', 'points': 400, 'daysLeft': 3, 'category': 'Quotidien', 'icon': 'recycling', 'color': '10B981'},
      {'id': 'master_chef_vege', 'title': 'Master Chef Végé', 'subtitle': 'Cuisine et valide 5 repas 100% végétariens dans la semaine', 'points': 250, 'daysLeft': 7, 'category': 'Alimentation', 'icon': 'restaurant', 'color': 'F59E0B'},
      {'id': 'economiseur_eau', 'title': 'Gardien des Océans', 'subtitle': 'Prends uniquement des douches courtes (moins de 5 min) pendant 5 jours', 'points': 300, 'daysLeft': 5, 'category': 'Quotidien', 'icon': 'water_drop', 'color': '06B6D4'},
      {'id': 'clean_walk', 'title': 'Clean Walk', 'subtitle': 'Fais une marche d\'une heure et ramasse un sac entier de déchets trouvés dans la nature', 'points': 800, 'daysLeft': 2, 'category': 'Nature', 'icon': 'eco', 'color': '8B5CF6'},
      {'id': 'debranche_tout', 'title': 'Cure de déconnexion', 'subtitle': 'Éteins tous les écrans et le Wi-Fi après 20h pendant le weekend', 'points': 350, 'daysLeft': 2, 'category': 'Énergie', 'icon': 'power_off', 'color': 'EF4444'},
    ];

    for (final defi in defis) {
      await _firestore.collection('defis').doc(defi['id'] as String).set(defi);
    }
  }

  Future<void> initBadges() async {
    final snapshot = await _firestore.collection('badges').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    final badges = [
      {'id': 'premier_pas', 'title': 'Le Premier Pas', 'description': 'Tu as validé ton tout premier geste écologique. Bravo !', 'icon': 'star', 'pointsRequired': 10},
      {'id': 'dizaine', 'title': 'Apprenti Écolo', 'description': 'Atteins la barre symbolique des 100 points.', 'icon': 'military_tech', 'pointsRequired': 100},
      {'id': 'centaine', 'title': 'L\'Habitué', 'description': 'Tu as franchi le cap des 500 points accumulés.', 'icon': 'shield', 'pointsRequired': 500},
      {'id': 'green_master', 'title': 'Green Master', 'description': 'Un modèle à suivre ! Plus de 1000 points générés.', 'icon': 'crown', 'pointsRequired': 1000},
      {'id': 'streak_7', 'title': 'Semaine Parfaite', 'description': 'Tu as validé au moins un geste pendant 7 jours consécutifs.', 'icon': 'calendar', 'pointsRequired': 500},
      {'id': 'streak_30', 'title': 'Légende Verte', 'description': 'Un mois complet d\'engagement (30 jours consécutifs).', 'icon': 'whatshot', 'pointsRequired': 2000},
      {'id': 'sauveur_planete', 'title': 'Sauveur de la Planète', 'description': 'L\'élite de l\'écologie : tu as dépassé les 5000 points.', 'icon': 'public', 'pointsRequired': 5000},
    ];

    for (final badge in badges) {
      await _firestore.collection('badges').doc(badge['id'] as String).set(badge);
    }
  }
}