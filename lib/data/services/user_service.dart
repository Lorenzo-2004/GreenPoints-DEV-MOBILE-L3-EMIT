import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user/user_model.dart';

class UserService {
  final CollectionReference _usersCollection = 
      FirebaseFirestore.instance.collection('users');

  Future<UserModel?> getUser(String userId) async {
    final doc = await _usersCollection.doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, userId);
    }
    return null;
  }

  Future<void> addPoints(String userId, int points, String gesteId) async {
    await _usersCollection.doc(userId).update({
      'totalPoints': FieldValue.increment(points),
      'weeklyPoints': FieldValue.increment(points),
      'completedActionIds': FieldValue.arrayUnion([gesteId]),
    });
  }
}