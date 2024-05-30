import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_manager/src/database/string_encrypt/string_encrypt.dart';

class RealtimeUtil {
  static Future delete(String path) async {
    final ref = FirebaseDatabase.instance.ref(path);
    await ref.remove();
  }

  /// Write a `value` to the location.
  ///
  /// This will overwrite any data at this location and all child locations.
  ///
  /// Data types that are allowed are String, boolean, int, double, Map, List.
  ///
  /// The effect of the write will be visible immediately and the corresponding
  /// events will be triggered. Synchronization of the data to the Firebase
  /// Database servers will also be started.
  ///
  /// Passing null for the new value means all data at this location or any
  /// child location will be deleted.
  static Future<void> write(String path, Object? value) async {
    final ref = FirebaseDatabase.instance.ref(path);
    await ref.set(value);
  }

  /// use encryptType to encrypt the string
  static Future<void> writeString(
    String path,
    String value, [
    StringEncryptType? encryptType,
  ]) async {
    final ref = FirebaseDatabase.instance.ref(path);
    if (encryptType != null) {
      await ref.set(StringEncrypt.encrypt(value, encryptType));
    } else {
      await ref.set(value);
    }
  }
}
