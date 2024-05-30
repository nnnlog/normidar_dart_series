import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

class FirebaseInitOptions {
  ///
  /// To use firebase you need to run `flutterfire configure`
  /// to prepare to your project.<br>
  /// after that you can get a file named `firebase_options.dart`
  /// and you can use it here like this:
  ///
  /// ```dart
  /// FirebaseInitOptions(
  ///   firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  ///   ...
  /// )
  /// ```
  final FirebaseOptions firebaseOptions;

  /// if user must login before using the app
  /// you can set this to true.
  final bool requiresLogin;

  /// if you want to use your own MaterialApp,
  /// you can pass it here, and the home will be the child of MaterialApp,
  /// like this:
  /// ```dart
  /// FirebaseInitOptions(
  ///   materialApp: (child) => MaterialApp(
  ///     home: child,
  ///   ),
  ///   ...
  /// )
  /// ```
  ///
  /// If you didn't provide this, we will create a MaterialApp for you.
  final Widget Function(Widget)? materialApp;

  /// the home widget of your app
  /// ```dart
  /// FirebaseInitOptions(
  ///   home: () => const Scaffold(), // or your application widget
  ///   ...
  /// )
  /// ```
  final Widget Function() home;

  /// the root name of database, default is `app`
  /// firestore, realtime database will be created a root by this name,
  final String rootName;

  final Future Function()? runBeforeApp;

  /// if you want to handle background message,
  /// you can set this function.
  /// it use FirebaseMessaging
  final Future<void> Function(RemoteMessage)? onBackgroundMessage;

  const FirebaseInitOptions({
    required this.firebaseOptions,
    required this.home,
    this.rootName = "app",
    this.requiresLogin = false,
    this.materialApp,
    this.runBeforeApp,
    this.onBackgroundMessage,
  });
}
