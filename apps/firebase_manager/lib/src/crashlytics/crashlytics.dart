import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class Crashlytics {
  /// ## How to use this
  ///
  /// try {
  ///   ...
  /// } catch (e, s) {
  ///   ...recordError(e, s);
  /// }
  void recordError(dynamic exception, StackTrace stackTrace) {
    FirebaseCrashlytics.instance
        .recordError(exception, stackTrace, fatal: true);
  }
}
