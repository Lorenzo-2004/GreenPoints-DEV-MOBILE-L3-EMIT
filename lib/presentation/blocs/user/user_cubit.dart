// lib/presentation/blocs/user/user_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/user/user_model.dart';
import '../../../data/services/user_service.dart';

class UserCubit extends Cubit<UserModel?> {
  final UserService _userService = UserService();

  UserCubit() : super(null) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        await loadUser(user.uid);
      } else {
        emit(null);
      }
    });
  }

  Future<void> loadUser(String userId) async {
    final user = await _userService.getUser(userId);
    emit(user);
  }

  Future<void> refresh() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await loadUser(userId);
    }
  }
}