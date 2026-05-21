import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/user/user_model.dart';
import '../../../data/services/user_service.dart';

class UserCubit extends Cubit<UserModel?> {
  final UserService _userService = UserService();

  UserCubit() : super(null) {
    _loadMockUser();
  }

  void _loadMockUser() {
    final mockUser = UserModel(
      id: 'mock_1',
      name: 'Lorenzo Rakoto',
      email: 'lorenzo@greenpoints.com',
      phoneNumber: '+261 38 94 088 53',
      totalPoints: 340,
      weeklyPoints: 85,
      streak: 5,
      completedActionIds: ['repas_vege', 'douche_courte'],
      createdAt: DateTime.now(),
      level: LevelModel.fromPoints(340),
    );
    emit(mockUser);
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