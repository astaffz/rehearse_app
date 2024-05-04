import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final userStream = FirebaseAuth.instance.authStateChanges();
  static final user = FirebaseAuth.instance.currentUser;

  static Future<void> anonLogin() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } on FirebaseAuthException {
      //handle error
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> loginWGoogle() async {
    try {
      final user = await GoogleSignIn().signIn();

      if (user == null) return;

      final googleAuth = await user.authentication;
      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(authCredential);
    } on FirebaseAuthException {
      // handle
    }
  }
}
