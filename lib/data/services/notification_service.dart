import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notification/notification_model.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Utilisateur non connecté');
    return user.uid;
  }

  CollectionReference get _notificationsCollection {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('notifications');
  }

  Future<void> addNotification({
    required String title,
    required String message,
    required NotificationType type,
    Map<String, dynamic>? data,
  }) async {
    final notification = NotificationModel(
      id: '',
      title: title,
      message: message,
      type: type,
      createdAt: DateTime.now(),
      isRead: false,
      data: data,
    );

    await _notificationsCollection.add(notification.toMap());
  }

  Stream<List<NotificationModel>> getNotifications() {
    return _notificationsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NotificationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> markAsRead(String notificationId) async {
    await _notificationsCollection.doc(notificationId).update({'isRead': true});
  }

  Future<void> markAllAsRead() async {
    final snapshot = await _notificationsCollection.where('isRead', isEqualTo: false).get();
    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  Future<int> getUnreadCount() async {
    final snapshot = await _notificationsCollection.where('isRead', isEqualTo: false).get();
    return snapshot.docs.length;
  }
}