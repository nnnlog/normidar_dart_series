import 'package:firebase_manager/firebase_manager.dart';

class Database {
  final String rootPath;

  late final RealtimeDatabase realtime = RealtimeDatabase(rootPath: rootPath);

  late final FireStoreDatabase fireStore =
      FireStoreDatabase(rootPath: rootPath);

  Database({required this.rootPath});
}
