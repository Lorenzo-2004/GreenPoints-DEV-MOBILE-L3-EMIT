import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/badge/badge_model.dart';

class BadgeService {
  final CollectionReference _badgesCollection = 
      FirebaseFirestore.instance.collection('badges');

  Future<List<BadgeModel>> getAllBadges() async {
    try {
      final snapshot = await _badgesCollection.get();
      return snapshot.docs.map((doc) {
        return BadgeModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}