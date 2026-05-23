// lib/data/services/social_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/social/social_model.dart';

class SocialService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Utilisateur non connecté');
    return user.uid;
  }

  Future<List<UserRankModel>> getLeaderboard({int limit = 50}) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .orderBy('totalPoints', descending: true)
          .limit(limit)
          .get();

      List<UserRankModel> rankings = [];
      int rank = 1;

      for (final doc in snapshot.docs) {
        final data = doc.data();
        rankings.add(UserRankModel.fromMap(data, doc.id, rank));
        rank++;
      }

      return rankings;
    } catch (e) {
      return [];
    }
  }

  Future<UserRankModel?> getUserRank() async {
    try {
      final allUsers = await _firestore
          .collection('users')
          .orderBy('totalPoints', descending: true)
          .get();

      int rank = 1;
      for (final doc in allUsers.docs) {
        if (doc.id == _userId) {
          return UserRankModel.fromMap(doc.data(), doc.id, rank);
        }
        rank++;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<FriendModel>> getFriends() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('friends')
          .get();

      final List<FriendModel> friends = [];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final userDoc = await _firestore.collection('users').doc(doc.id).get();
        if (userDoc.exists) {
          final userData = userDoc.data();
          friends.add(FriendModel(
            id: doc.id,
            name: userData?['name'] ?? '',
            email: userData?['email'] ?? '',
            totalPoints: userData?['totalPoints'] ?? 0,
            photoUrl: userData?['photoUrl'],
            addedAt: (data['addedAt'] as Timestamp).toDate(),
          ));
        }
      }
      return friends;
    } catch (e) {
      return [];
    }
  }

  Future<void> addFriend(String friendId) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('friends')
        .doc(friendId)
        .set({
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFriend(String friendId) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('friends')
        .doc(friendId)
        .delete();
  }
}