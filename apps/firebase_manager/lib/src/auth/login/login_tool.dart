import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginTool {
  LoginProvider? _provider;

  void jumpToLoginPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => DefaultLoginPage()));
  }

  /// after login, use this code to login for payment
  /// if (getUserID() != null) {
  ///   await Purchases.logIn(uid);
  /// }
  Future<UserCredential?> loginByApple() async {
    _provider = AppleLoginProvider();
    OAuthCredential? credential = await _provider?.getAuthCredential();
    if (credential != null) {
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    }
    return null;
  }

  /// after login, use this code to login for payment
  /// if (getUserID() != null) {
  ///   await Purchases.logIn(uid);
  /// }
  Future<UserCredential?> loginByGoogle() async {
    try {
      _provider = GoogleLoginProvider();
      OAuthCredential? credential = await _provider?.getAuthCredential();
      if (credential != null) {
        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        return userCredential;
      }
    } on PlatformException {
      print('''
!!! FirebaseAuthException !!!

see https://stackoverflow.com/questions/54557479/flutter-and-google-sign-in-plugin-platformexceptionsign-in-failed-com-google

you can try when you are developing for android:



!!!
''');
      rethrow;
    }
    return null;
  }

  Future logOut() async {
    await FirebaseAuth.instance.signOut();
    await _provider?.logout();
  }
}
