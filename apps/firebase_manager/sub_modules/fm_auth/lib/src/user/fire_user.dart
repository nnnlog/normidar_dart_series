import 'package:firebase_auth/firebase_auth.dart';

class FireUser {
  // null only if fake user
  final User? _user;
  FireUser(User user) : _user = user;

  FireUser.fake() : _user = null;

  /// The users email address.
  ///
  /// Will be `null` if signing in anonymously.
  String? getEmail() {
    final user = _user;
    if (user == null) {
      return 'test@test.com';
    } else {
      return user.email;
    }
  }

  /// The user's unique ID.
  String getID() {
    final user = _user;
    if (user == null) {
      return 'TEST_USER_ID';
    } else {
      return user.uid;
    }
  }
}
