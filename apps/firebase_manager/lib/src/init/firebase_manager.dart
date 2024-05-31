import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fm_auth/fm_auth.dart';

import '../../firebase_manager.dart';

FirebaseManager get fs => FirebaseManager.share;

///
/// This is a manager for firebase,
/// on RealtimeDatabase and Storage and Firestore(future) you can use `@uid@`
/// to auto replace it with the user id.
class FirebaseManager {
  static FirebaseManager share = FirebaseManager._();
  late Database db;
  late Crashlytics crashlytics;
  final FireAuth auth = FireAuth.shared;
  FirebaseManager._();

  /// init all about Firebase
  /// you do not need to run runApp() function by yourself,
  /// we will do it for you.
  void initApp(FirebaseInitOptions options) {
    db = Database(rootPath: options.rootName);

    // crashlytics init
    crashlytics = Crashlytics();
    runZonedGuarded<Future<void>>(() async {
      WidgetsFlutterBinding.ensureInitialized();
      // init app
      await Firebase.initializeApp(
        options: options.firebaseOptions,
      );

      // Pass all uncaught errors from the framework to Crashlytics.
      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      // material app generation
      final materialApp =
          options.materialApp ?? (child) => MaterialApp(home: child);

      await options.runBeforeApp?.call();
      if (options.requiresLogin && fs.auth.getNowUser() == null) {
        runApp(
            materialApp(DefaultLoginPage(onLoginSuccessJumpTo: options.home)));
      } else {
        runApp(materialApp(options.home()));
      }
    }, (error, stack) {
      if (kDebugMode) {
        print('error: $error');
        throw error;
      }
      return crashlytics.recordError(error, stack);
    });
  }
}
