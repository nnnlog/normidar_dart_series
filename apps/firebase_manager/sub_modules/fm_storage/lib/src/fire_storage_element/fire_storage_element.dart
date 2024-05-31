import 'package:firebase_storage/firebase_storage.dart';

import 'fire_folder_ref.dart';

abstract class FireStorageElement {
  String get path;

  Reference? _ref;

  Future<bool> checkExist();

  FireFolderRef getFatherFolder() {
    final lastIndex = path.lastIndexOf('/');
    final folderPath = path.substring(0, lastIndex);
    return FireFolderRef(folderPath);
  }

  String getName() {
    final lastIndex = path.lastIndexOf('/');
    return path.substring(lastIndex + 1);
  }

  Reference getReference() {
    final ref = _ref;
    if (ref != null) {
      return ref;
    }
    Reference rootRef = FirebaseStorage.instance.ref();
    Reference pathRef = rootRef.child(path);
    _ref = pathRef;
    return pathRef;
  }
}
