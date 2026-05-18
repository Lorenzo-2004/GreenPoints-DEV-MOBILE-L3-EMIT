import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DefiService {
  final CollectionReference _defisCollection = 
      FirebaseFirestore.instance.collection('defis');

  Future<List<Map<String, dynamic>>> getAllDefis() async {
    try {
      final snapshot = await _defisCollection.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'id': doc.id,
        };
      }).toList();
    } catch (e) {
      debugPrint('Erreur lors du chargement des défis: $e');
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> streamDefis() {
    return _defisCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          ...data,
          'id': doc.id,
        };
      }).toList();
    });
  }
}