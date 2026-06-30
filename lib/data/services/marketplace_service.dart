import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recompense/recompense_model.dart';

class MarketplaceService {
  final CollectionReference _recompensesCollection = 
      FirebaseFirestore.instance.collection('recompenses');

  Future<List<RecompenseModel>> getAllRecompenses() async {
    try {
      final snapshot = await _recompensesCollection.get();
      return snapshot.docs.map((doc) {
        return RecompenseModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      return [];
    }
  }
}