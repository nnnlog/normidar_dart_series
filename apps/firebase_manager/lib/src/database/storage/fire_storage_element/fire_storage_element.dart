import 'package:firebase_manager/firebase_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class FireStorageElement {
  final String path;

  Reference? _ref;

  FireStorageElement(String path)
      : path = fs.db.storage.getFullPath(path);

  FireStorageElement.fullPath(this.path);

  FireStorageElement.ref(Reference ref) : path = ref.fullPath;
  Future<bool> checkExist();

  FireFolderRef getFatherFolder() {
    final lastIndex = path.lastIndexOf('/');
    final folderPath = path.substring(0, lastIndex);
    return FireFolderRef.fullPath(folderPath);
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
