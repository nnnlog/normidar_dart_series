import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:path_provider/path_provider.dart';

/// there is not check file exits logic in it.
class Storage extends DatabaseInterface {
  Storage({required super.rootPath});

  Future<FireStorageElement?> getElementAuto(String path) async {
    final file = FireFileRef(path);
    if (await file.checkExist()) {
      return file;
    }

    final folder = FireFolderRef(path);
    if (await folder.checkExist()) {
      return folder;
    }

    return null;
  }

  /// auto check file exists
  /// if not exists, download it from server
  /// if exists, return that
  Future<FireFileRef?> getFileAuto(String path) async {
    final file = FireFileRef(path);
    if (await file.checkExist()) {
      return file;
    }
    return null;
  }

  Future<FireFolderRef?> getFolderAuto(String path) async {
    final folder = FireFolderRef(path);
    if (await folder.checkExist()) {
      return folder;
    }
    return null;
  }

  Future<String> getLocalFileMD5(File file) async =>
      base64Encode((await md5.bind(file.openRead()).first).bytes);

  /// use md5 to search a file on local,
  /// if exists in local:
  ///   return that
  /// else:
  ///   search on server
  ///   if exists on server:
  ///     download and return that
  ///   else:
  ///     return null
  ///
  Future<PoolFile?> getPoolFile(String md5) async {
    final localDirPath = (await _getFilesPoolDirectory()).path;
    final localFile = File('$localDirPath/$md5');
    final metaType = await _getMd5Type(md5);
    if (await localFile.exists()) {
      return PoolFile(localFile, metaType, md5);
    } else {
      final severFile = _getFireFile(md5);
      if (await severFile.checkExist()) {
        await severFile.downloadEasy(localFile);
        return PoolFile(localFile, metaType, md5);
      } else {
        return null;
      }
    }
  }

  /// Return the path of the root folder
  FireFolderRef rootFolderRef() {
    final rootPath = getPrefixPath();
    return FireFolderRef.fullPath(rootPath);
  }

  /// upload file to server
  /// if file is not exist on local, will return null
  Future<PoolFile?> uploadPoolFile(File file) async {
    Log.debug(() => 'storage: start upload pool file');
    final tool = fs.db.storage;
    if (await file.exists()) {
      final md5 = await tool.getLocalFileMD5(file);
      Log.debug(() => 'storage: file exists, md5: $md5');
      final serverFile = _getFireFile(md5);
      if (!await serverFile.checkExist()) {
        final fireDir = _getFireFolder();
        await fireDir.uploadEasy(file, fileName: md5, metadataMap: {
          'metaType': file.path.split('.').last,
        });
      }

      Log.debug(() => 'storage: file upload');

      final localDirStr = (await _getFilesPoolDirectory()).path;
      await file.copy('$localDirStr/$md5');

      return PoolFile(file, await _getMd5Type(md5), md5);
    }
    return null;
  }

  Future<Directory> _getFilesPoolDirectory() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();

    Directory filesPoolDir = Directory('${appDocDir.path}/files_pool');

    if (!await filesPoolDir.exists()) {
      await filesPoolDir.create();
    }

    return filesPoolDir;
  }

  FireFileRef _getFireFile(String md5) {
    final filesPoolDir = _getFireFolder();
    return filesPoolDir.childFile(md5);
  }

  FireFolderRef _getFireFolder() {
    final severRootDir = fs.db.storage.rootFolderRef();
    return severRootDir.childFolder('filesPool');
  }

  Future<String?> _getMd5Type(String md5) async {
    final file = _getFireFile(md5);
    if (await file.checkExist()) {
      return (await file.getMetadata())?['metaType'];
    }
    return null;
  }
}
