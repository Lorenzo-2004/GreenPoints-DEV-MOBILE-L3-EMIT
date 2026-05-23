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
      return _getMockRecompenses();
    }
  }

  List<RecompenseModel> _getMockRecompenses() {
    return [
      RecompenseModel(
        id: '1',
        title: 'Plante verte',
        description: 'Une plante pour ton bureau',
        points: 500,
        icon: 'local_florist',
        category: 'Plantes',
        stock: 10,
      ),
      RecompenseModel(
        id: '2',
        title: 'Gourde isotherme',
        description: 'Gourde en acier inoxydable',
        points: 1000,
        icon: 'water_bottle',
        category: 'Accessoires',
        stock: 5,
      ),
      RecompenseModel(
        id: '3',
        title: 'Sac à courses',
        description: 'Sac en tissu réutilisable',
        points: 300,
        icon: 'shopping_bag',
        category: 'Éco-produits',
        stock: 20,
      ),
      RecompenseModel(
        id: '4',
        title: 'Composteur',
        description: 'Composteur de balcon',
        points: 2000,
        icon: 'yard',
        category: 'Éco-produits',
        stock: 3,
      ),
      RecompenseModel(
        id: '5',
        title: 'Badge exclusif',
        description: 'Badge spécial GreenPoints',
        points: 1500,
        icon: 'emoji_events',
        category: 'Exclusifs',
        stock: 50,
      ),
    ];
  }
}