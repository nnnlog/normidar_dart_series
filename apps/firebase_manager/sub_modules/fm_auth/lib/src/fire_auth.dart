import 'dart:io';
import 'dart:math';

import 'package:auto_exporter_annotation/auto_exporter_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'login/login_tool.dart';
import 'user/fire_user.dart';
import 'user_account_type.dart';

@AutoExport()
class FireAuth {
  final login = LoginTool();

  FireAuth._();

  static final FireAuth shared = FireAuth._();

  bool get isLoggedIn => getNowUser() != null;

  Future createUserByAnonymous() async {
    await FirebaseAuth.instance.signInAnonymously();
  }

  /// please use try statement
  Future<FireUser?> createUserByEmailLink(
      {required String emailAuth, required String emailLink}) async {
    // Confirm the link is a sign-in with email link.
    if (FirebaseAuth.instance.isSignInWithEmailLink(emailLink)) {
      // The client SDK will parse the code from the link for you.
      // final userCredential =
      await FirebaseAuth.instance
          .signInWithEmailLink(email: emailAuth, emailLink: emailLink);

      // You can access the new user via userCredential.user.
      // final emailAddress = userCredential.user?.email;
    }
    return null;
  }

  /// Warning: This is a dangerous operation, it will delete the user's account
  /// and all data associated with the user.
  Future deleteUserAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.delete();
  }

  FireUser? getNowUser() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return FireUser(currentUser);
    } else {
      return null;
    }
  }

  String? getUserEmail() {
    return FirebaseAuth.instance.currentUser?.email;
  }

  String? getUserID() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  /// get user login type
  UserSignInMethod getUserSignInMethod() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return UserSignInMethod.nullType;
    List<UserInfo> providerData = user.providerData;
    if (providerData.isNotEmpty) {
      switch (providerData[0].providerId) {
        case 'google.com':
          return UserSignInMethod.google;
        case 'apple.com':
          return UserSignInMethod.apple;
        default:
      }
    }
    return UserSignInMethod.nullType;
  }

  Future logoutNowUser() async {
    await FirebaseAuth.instance.signOut();
  }

  Future removeNowUser() async {
    await FirebaseAuth.instance.currentUser?.delete();
  }

  ///
  /// 1. Dynamic Links -> create an Dynamic Link by "domain.com/email_create"
  /// 2. Authentication -> Settings -> register your domain
  ///
  /// return a key to accept user request
  ///
  /// throw only supported iOS or Android
  ///
  /// about deep links: https://developer.android.com/training/app-links/deep-linking
  ///
  ///
  Future<String> sendEmailToCreateUser({
    required String domain,
    required String email,
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    ActionCodeSettings acs;
    if (Platform.isAndroid || Platform.isIOS) {
      final random = Random().nextInt(9999).toString();
      acs = ActionCodeSettings(
          url: 'https://$domain/email_create?requestId=$random',
          handleCodeInApp: true,
          iOSBundleId: packageInfo.packageName,
          androidPackageName: packageInfo.packageName,
          androidInstallApp: true,
          androidMinimumVersion: '18');
      await FirebaseAuth.instance
          .sendSignInLinkToEmail(email: email, actionCodeSettings: acs);
      return random;
    } else {
      throw 'not supported on this platform';
    }
  }

  Stream<FireUser?> userStateStream() {
    return FirebaseAuth.instance
        .authStateChanges()
        .map((user) => user == null ? null : FireUser(user));
  }
}
