import 'package:auto_exporter_annotation/auto_exporter_annotation.dart';
import 'fire_storage_element/fire_file_ref.dart';
import 'fire_storage_element/fire_folder_ref.dart';
import 'fire_storage_element/fire_storage_element.dart';
import 'pool/pool.dart';

/// there is not check file exits logic in it.
@AutoExport()
class Storage {
  final String rootPath;
  Storage({required this.rootPath});

  final pool = Pool();

  Future<FireStorageElement?> getElementAuto(String path) async {
    final file = FireFileRef(path);
    if (await file.checkExist()) {
      return file;
    }

    final folder = FireFolderRef(rootPath + path);
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

  /// Return the path of the root folder
  FireFolderRef get root {
    return FireFolderRef(rootPath);
  }
}
