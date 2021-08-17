import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> authenticate({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } on FirebaseAuthException catch (e) {
      String message = e.toString();
      if (e.code == 'user-not-found') message = 'Email não encontrado';
      if (e.code == 'wrong-password') message = 'Senha incorreta';

      throw AuthenticationException(message: message);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
