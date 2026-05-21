import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DefiService {
  final CollectionReference _defisCollection =
      FirebaseFirestore.instance.collection('defis');

  Color _parseColor(dynamic value) {
    if (value is Color) return value;

    if (value is String) {
      String hex = value.replaceAll('#', '');

      if (hex.length == 6) {
        hex = 'FF$hex';
      }

      return Color(int.parse(hex, radix: 16));
    }

    return Colors.green;
  }

  Future<List<Map<String, dynamic>>> getAllDefis() async {
    try {
      final snapshot = await _defisCollection.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        return {
          ...data,
          'id': doc.id,
          'color': _parseColor(data['color']),
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
          'color': _parseColor(data['color']),
        };
      }).toList();
    });
  }
}