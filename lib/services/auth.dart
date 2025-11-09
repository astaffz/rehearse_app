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
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();
      final GoogleSignInAccount? user = await googleSignIn.authenticate();

      if (user == null) return;

      final GoogleSignInAuthentication googleAuth = await user.authentication;
      final OAuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(authCredential);
    } on FirebaseAuthException {
      // handle
    }
  }
}
