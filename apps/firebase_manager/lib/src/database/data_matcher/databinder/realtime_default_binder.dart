import 'package:firebase_manager/firebase_manager.dart';

class FmRealtimeDefaultBinder<T extends FmMatcherDataset>
    extends FmRealtimeDataBinder<T> {
  RealtimeBranch branch;
  T Function(Map<String, dynamic>) constructor;
  FmRealtimeDefaultBinder({
    required this.branch,
    required this.constructor,
  });

  @override
  RealtimeBranch getDataBranch() => branch;

  @override
  Stream<T> getDataset() => getMap().map((event) => constructor(event));
}
