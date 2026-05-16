import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repo;

  AuthCubit(this._repo) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _repo.signInWithEmail(email, password);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(_mapError(e)));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      await _repo.registerWithEmail(email, password, name);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(_mapError(e)));
    }
  }

  Future<void> logout() async {
    await _repo.signOut();
    emit(AuthInitial());
  }

  String _mapError(dynamic e) {
    if (e is Exception) {
      final msg = e.toString();
      if (msg.contains('user-not-found')) return 'Aucun compte trouvé.';
      if (msg.contains('wrong-password')) return 'Mot de passe incorrect.';
      if (msg.contains('email-already-in-use')) return 'Email déjà utilisé.';
      if (msg.contains('weak-password')) return 'Mot de passe trop faible.';
      if (msg.contains('invalid-email')) return 'Email invalide.';
    }
    return 'Une erreur est survenue.';
  }
}