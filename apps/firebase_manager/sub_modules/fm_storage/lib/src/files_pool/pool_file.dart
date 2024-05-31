import 'dart:io';

class PoolFile {
  final File file;

  /// the file type, null means that it could not be obtained
  final String? type;

  final String md5;

  PoolFile(this.file, this.type, this.md5);
}
