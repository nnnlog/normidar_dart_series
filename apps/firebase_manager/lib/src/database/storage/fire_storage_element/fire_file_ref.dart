import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FireFileRef extends FireStorageElement {
  FireFileRef(super.path);
  FireFileRef.fullPath(super.path) : super.fullPath();
  FireFileRef.ref(super.ref) : super.ref();

  String get directoryPath {
    return path.substring(0, path.lastIndexOf("/"));
  }

  String get fileName {
    return path.substring(path.lastIndexOf("/") + 1);
  }

  Storage get storage {
    return fs.db.storage;
  }

  @override
  Future<bool> checkExist() async {
    Reference ref = FirebaseStorage.instance.ref().child(path);
    try {
      await ref.getMetadata();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// ## check local is same with remote storage path content or not
  /// true -> same<br>
  /// false -> different (may be un exist or )
  Future<bool> checkSame(File file) async {
    if (!await file.exists()) {
      return false;
    }
    String? remoteMd5 = await getMD5();
    if (remoteMd5 == null) {
      return false;
    }

    String localMd5 =
        base64Encode((await md5.bind(file.openRead()).first).bytes);
    return remoteMd5 == localMd5;
  }

  /// compare local file with remote storage file
  Future<FileCompare> compare(File file) async {
    return FileCompare(
      localHash: await getLocalMD5(file),
      originHash: await getMD5(),
    );
  }

  /// without pause resume feature
  ///
  /// please check exist before this,
  ///
  /// if null returned it is same file in local.
  Future<Task?> download(File file) async {
    if (await checkSame(file)) {
      return null;
    }
    Reference ref = FirebaseStorage.instance.ref().child(path);
    // different with downloadEasy here: has return
    return ref.writeToFile(file);
  }

  /// without pause resume feature
  ///
  /// please check exist before this,
  ///
  /// if null returned it is same file in local.
  Future downloadEasy(File file) async {
    if (await checkSame(file)) {
      return;
    }
    Reference ref = FirebaseStorage.instance.ref().child(path);
    // different with download here: no return
    await ref.writeToFile(file);
  }

  /// generate a file with the same path, if it exists, check if it is same with remote storage
  /// if not, redownload it.
  /// the tuple is (progress, file)
  ///
  /// --If you are using ImageFile--
  /// You should use `imageCache.clear();` before return you widget.
  ///
  /// ```dart
  /// imageCache.clear();
  /// imageCache.clearLiveImages();
  ///
  /// return Container(
  ///   key: Key(downloadProgress.hash),
  ///   ...
  /// );
  /// ```
  /// --If you are using ImageFile--
  Stream<DownloadProgress> generateFile({String? debugString}) async* {
    _debugPrint(debugString, 'start', path);
    // generate file
    Directory appDocDir = await getApplicationSupportDirectory();
    _debugPrint(debugString, 'got app dir', path);
    Directory filesPoolDir = Directory('${appDocDir.path}/$directoryPath');
    if (!await filesPoolDir.exists()) {
      _debugPrint(debugString, 'folder not exists, create it', path);
      await filesPoolDir.create(recursive: true);
      _debugPrint(debugString, 'folder created', path);
    }
    File file = File('${appDocDir.path}/$path');

    // if file not exists, create it
    if (!await file.exists()) {
      _debugPrint(debugString, 'file not exists, create it', path);
      Reference ref = FirebaseStorage.instance.ref().child(path);
      yield* ref.writeToFile(file).snapshotEvents.map((ele) {
        final state = ele.state;
        return switch (state) {
          TaskState.running ||
          TaskState.paused =>
            Downloading(ele.bytesTransferred / ele.totalBytes),
          TaskState.success => Downloaded(file, hash: ele.metadata?.md5Hash),
          _ => throw UnsupportedError('unsupported state: $state'),
        };
      });
      _debugPrint(debugString, 'file created', path);
    } else {
      yield Downloaded(file, hash: null);
      _debugPrint(debugString, 'file exists', path);
      
      // compare cost time
      final compareData = await compare(file);
      _debugPrint(debugString, 'after compare', path);
      if (!await checkSame(file)) {
        _debugPrint(
            debugString, 'file exists and is not same, redownload it', path);
        // if file exists and is not same, redownload it.
        yield Downloaded(file, hash: compareData.localHash);
        Reference ref = FirebaseStorage.instance.ref().child(path);
        await ref.writeToFile(file); // this method will overwrite the file.
        _debugPrint(debugString, 'file redownloaded', path);
        yield Downloaded(file, hash: compareData.originHash);
      }
    }
  }

  /// get the remote storage file size
  /// in bytes
  Future<int?> getFileSize() async {
    Reference ref = FirebaseStorage.instance.ref().child(path);
    FullMetadata metadata = await ref.getMetadata();
    return metadata.size;
  }

  /// get the remote file md5 hash
  Future<String?> getMD5() async {
    Reference ref = FirebaseStorage.instance.ref().child(path);
    FullMetadata metadata = await ref.getMetadata();
    return metadata.md5Hash;
  }

  Future<Map<String, String>?> getMetadata() async {
    final ref = getReference();
    return (await ref.getMetadata()).customMetadata;
  }

  void _debugPrint(String? debugString, String hint, String content) {
    if (kDebugMode && debugString != null) {
      print('$debugString: $content ~hint:$hint ts:${DateTime.now()}');
    }
  }

  /// get the local file md5 hash
  static Future<String?> getLocalMD5(File file) async {
    if (!await file.exists()) {
      return null;
    }
    return base64Encode((await md5.bind(file.openRead()).first).bytes);
  }
}
