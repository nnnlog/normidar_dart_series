import 'dart:convert';
import 'dart:io';

import 'package:auto_exporter_annotation/auto_exporter_annotation.dart';
import 'package:crypto/crypto.dart';
import 'package:fm_storage/fm_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'pool_file.dart';

@IgnoreExport()
class Pool {
  static Pool shared = Pool();

  /// upload file to server
  /// if file is not exist on local, will return null
  Future<PoolFile?> uploadPoolFile(File file) async {
    if (await file.exists()) {
      final md5 = await getLocalFileMD5(file);
      final serverFile = _getFireFile(md5);
      if (!await serverFile.checkExist()) {
        final fireDir = _getFireFolder();
        await fireDir.uploadEasy(file, fileName: md5, metadataMap: {
          'metaType': file.path.split('.').last,
        });
      }

      final localDirStr = (await _getFilesPoolDirectory()).path;
      await file.copy('$localDirStr/$md5');

      return PoolFile(file, await _getMd5Type(md5), md5);
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
    final severRootDir = FireFolderRef('pool');
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
