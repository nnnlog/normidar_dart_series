import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginProvider {
  Future<OAuthCredential?> getAuthCredential();
  Future logout();
}
