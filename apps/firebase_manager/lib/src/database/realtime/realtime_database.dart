import 'package:firebase_manager/firebase_manager.dart';

class RealtimeDatabase extends DatabaseInterface {
  RealtimeDatabase({required super.rootPath});

  RealtimeBranch getRootBranch() {
    return RealtimeBranch(null, getPrefixPath());
  }
}
