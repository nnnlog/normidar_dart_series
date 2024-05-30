import 'package:firebase_manager/firebase_manager.dart';

// please set the T of this class
class FmRealtimeSingleBinder<T> extends AbsSingleBinder<T> {
  final RealtimeBranch branch;
  FmRealtimeSingleBinder(this.branch);

  @override
  Stream<T> getData() {
    final resultStream = branch.readStream();
    return resultStream.map((data) {
      Log.debug(() =>
          'realtime_single_binder.dart branchPath:${branch.toString()} data: $data');
      if (data is ValueResult) {
        return data.getContent() as T;
      }
      throw Exception('data is not ValueResult');
    });
  }

  @override
  String getLogInfo() {
    return 'branchPath:${branch.getPath()}';
  }
}
