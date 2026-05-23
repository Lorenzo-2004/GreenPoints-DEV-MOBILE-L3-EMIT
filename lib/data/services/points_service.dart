import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/points/points_transaction_model.dart';
import '../../domain/entities/points_transaction_entity.dart';

class PointsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Utilisateur non connecté');
    return user.uid;
  }

  CollectionReference get _transactionsCollection {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('transactions');
  }

  Future<List<PointsTransactionModel>> getTransactions() async {
    try {
      final snapshot = await _transactionsCollection
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return PointsTransactionModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Stream<List<PointsTransactionModel>> streamTransactions() {
    return _transactionsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return PointsTransactionModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  Future<int> getTotalPoints() async {
    final transactions = await getTransactions();
    int total = 0;
    for (final transaction in transactions) {
      total += transaction.points;
    }
    return total;
  }

  Future<void> addTransaction({
    required String gesteId,
    required String gesteTitle,
    required int points,
    required TransactionType type,
  }) async {
    final transaction = PointsTransactionModel(
      id: '',
      userId: _userId,
      gesteId: gesteId,
      gesteTitle: gesteTitle,
      points: points,
      type: type,
      createdAt: DateTime.now(),
    );

    await _transactionsCollection.add(transaction.toMap());
  }
}