import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repo;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthFailure('Connexion Google annulée'));
        return;
      }

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = 
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _saveUserToFirestore(userCredential.user!);
        emit(AuthSuccess());
      } else {
        emit(AuthFailure('Erreur de connexion Google'));
      }
    } catch (e) {
      emit(AuthFailure('Erreur de connexion Google: ${e.toString()}'));
    }
  }

  Future<void> _saveUserToFirestore(User user) async {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    final userData = {
      'id': user.uid,
      'name': user.displayName ?? 'Utilisateur',
      'email': user.email ?? '',
      'photoUrl': user.photoURL,
      'totalPoints': 0,
      'weeklyPoints': 0,
      'streak': 0,
      'completedActionIds': [],
      'createdAt': FieldValue.serverTimestamp(),
    };

    await userDoc.set(userData, SetOptions(merge: true));
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
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