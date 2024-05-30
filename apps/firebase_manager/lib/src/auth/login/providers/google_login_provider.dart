import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginProvider extends LoginProvider {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Future<OAuthCredential?> getAuthCredential() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      // Create a new credential
      return GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    }
    return null;
  }

  @override
  Future logout() async {
    await googleSignIn.signOut();
  }
}
