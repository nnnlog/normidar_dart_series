import 'dart:io';

import 'package:firebase_manager/firebase_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireFolderRef extends FireStorageElement {
  FireFolderRef(super.path);
  FireFolderRef.fullPath(super.path) : super.fullPath();
  FireFolderRef.ref(super.ref) : super.ref();

  Storage get storage {
    return fs.db.storage;
  }

  /// find all floder in father
  /// and check contains
  @override
  Future<bool> checkExist() async {
    try {
      final father = getFatherFolder();
      final children = await father.listFolders();
      final pathList = children.map((e) => e.path);
      return pathList.contains(path);
    } catch (_) {
      return false;
    }
  }

  /// get the file ref in this folder.
  FireFileRef childFile(dynamic name) {
    final ref = getReference();
    final childRef = ref.child(name.toString());
    return FireFileRef.ref(childRef);
  }

  /// get the folder ref in this folder.
  FireFolderRef childFolder(dynamic name) {
    final ref = getReference();
    final childRef = ref.child(name.toString());
    return FireFolderRef.ref(childRef);
  }

  Future<List<FireFileRef>> listFiles() async {
    Reference ref = FirebaseStorage.instance.ref().child(path);
    final lst = await ref.listAll();

    List<FireFileRef> rt = [];
    for (var element in lst.items) {
      rt.add(FireFileRef.ref(element));
    }

    return rt;
  }

  Future<List<FireFolderRef>> listFolders() async {
    Reference ref = FirebaseStorage.instance.ref().child(path);
    final lst = await ref.listAll();

    List<FireFolderRef> rt = [];
    for (var element in lst.prefixes) {
      rt.add(FireFolderRef.ref(element));
    }

    return rt;
  }

  Future<Task> upload(File file,
      {String? fileName, Map<String, String>? metadataMap}) async {
    Log.debug(() => 'fire_folder.dart upload file: ${file.path} to $path');
    Reference ref = FirebaseStorage.instance.ref().child(path);
    if (fileName != null) {
      ref = ref.child(fileName);
    } else {
      ref = ref.child(file.path.split('/').last);
    }

    SettableMetadata? metadata;
    if (metadataMap != null) {
      metadata = SettableMetadata(customMetadata: metadataMap);
    }

    final rt = ref.putFile(file, metadata);
    Log.debug(() => 'fire_folder.dart upload file: ${file.path} to $path done');
    return rt;
  }

  Future uploadEasy(File file,
      {String? fileName, Map<String, String>? metadataMap}) async {
    return await upload(file, fileName: fileName, metadataMap: metadataMap);
  }
}
