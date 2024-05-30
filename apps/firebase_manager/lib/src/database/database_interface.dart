import 'package:firebase_manager/src/init/firebase_manager.dart';

abstract class DatabaseInterface {
  final String rootPath;

  DatabaseInterface({
    required this.rootPath,
  });

  String getFullPath(String path) {
    // replace uid
    path = path.replaceAll('@uid@', fs.auth.getUserID() ?? '@uid@');
    return '${getPrefixPath()}/$path';
  }

  String getPrefixPath() => rootPath;
}
