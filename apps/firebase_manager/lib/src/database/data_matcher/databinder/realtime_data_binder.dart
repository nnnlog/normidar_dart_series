import 'package:firebase_manager/firebase_manager.dart';

/// extend this class to bind the realtime data to the widget
///
abstract class FmRealtimeDataBinder<T extends FmMatcherDataset>
    extends AbsDataBinder<T> {
  /// get the branch of the dataset
  ///
  RealtimeBranch getDataBranch();

  @override
  Stream<Map<String, dynamic>> getMap() {
    final branch = getDataBranch();
    final resultStream = branch.readStream();
    return resultStream.map((event) {
      if (event is ChildrenResult) {
        return event.getDataMap();
      }
      throw Exception('not children result');
    });
  }

  @override
  Future<void> updateMap(Map<String, dynamic> map) async {
    final branch = getDataBranch();
    await branch.writeMap(map);
  }
}
