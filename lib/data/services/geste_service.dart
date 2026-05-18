import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/geste/geste_model.dart';

class GesteService {
  final CollectionReference _gestesCollection = 
      FirebaseFirestore.instance.collection('gestes');

  Future<List<GesteModel>> getAllGestes() async {
    final snapshot = await _gestesCollection.get();
    return snapshot.docs.map((doc) {
      return GesteModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}