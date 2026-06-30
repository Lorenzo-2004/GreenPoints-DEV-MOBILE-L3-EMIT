import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/user/user_model.dart';
import '../../../data/services/user_service.dart';

class UserCubit extends Cubit<UserModel?> {
  final UserService _userService = UserService();

  UserCubit() : super(null) {
    refresh();
  }

  Future<void> loadUser(String userId) async {
    try {
      UserModel? user = await _userService.getUser(userId);
      
      // Si l'utilisateur n'existe pas en base de données, on le crée
      if (user == null) {
        final authUser = FirebaseAuth.instance.currentUser;
        if (authUser != null && authUser.uid == userId) {
          user = UserModel(
            id: authUser.uid,
            name: authUser.displayName ?? 'Membre GreenPoints',
            email: authUser.email ?? '',
            totalPoints: 0,
            weeklyPoints: 0,
            streak: 0,
            completedActionIds: [],
            createdAt: DateTime.now(),
            level: LevelModel.fromPoints(0),
          );
          
          // Emettre l'utilisateur immédiatement pour éviter le chargement infini
          emit(user);
          
          try {
            await _userService.updateUser(user);
          } catch(e) {
            debugPrint("Erreur création utilisateur Firestore: \$e");
          }
          return;
        }
      }
      
      emit(user);
    } catch (e) {
      debugPrint("Erreur globale loadUser: \$e");
      // En cas d'erreur de base de données, on émet un faux user pour débloquer l'UI
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser != null) {
        emit(UserModel(
          id: authUser.uid,
          name: authUser.displayName ?? 'Membre (Hors Ligne)',
          email: authUser.email ?? '',
          totalPoints: 0,
          weeklyPoints: 0,
          streak: 0,
          completedActionIds: [],
          createdAt: DateTime.now(),
          level: LevelModel.fromPoints(0),
        ));
      }
    }
  }

  Future<void> updateUser(UserModel user) async {
    emit(user);
    if (user.id.isNotEmpty) {
      try {
        await _userService.updateUser(user);
      } catch (e) {
        // Handle error if needed
      }
    }
  }

  Future<void> updateProfilePhoto(String photoPath) async {
    if (state != null) {
      final updatedUser = state!.copyWith(photoUrl: photoPath);
      await updateUser(updatedUser);
    }
  }

  Future<void> refresh() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await loadUser(userId);
    }
  }
}