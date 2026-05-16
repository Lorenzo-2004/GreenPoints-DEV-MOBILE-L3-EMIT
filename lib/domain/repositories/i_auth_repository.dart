abstract class IAuthRepository {
  Future<void> signInWithEmail(String email, String password);
  Future<void> registerWithEmail(String email, String password, String name);
  Future<void> signOut();
  bool get isLoggedIn;
}