import 'package:flutter/foundation.dart';

class Log {
  /// print if debug mode is enabled and Log.showDebug is true
  static void debug(String Function() message) {
    if (kDebugMode) {
      print('DEBUG: ${message()}');
    }
  }

  /// throw an error if debug mode is enabled
  static void error(Object message, {StackTrace? stackTrace}) {
    if (kDebugMode) {
      print('ERROR: $message');
      if (stackTrace != null) {
        print('STACK: $stackTrace');
      }
      throw Exception(message);
    }
  }

  /// print if debug mode is enabled
  static void info(String message) {
    if (kDebugMode) {
      print('INFO: $message');
    }
  }
}
