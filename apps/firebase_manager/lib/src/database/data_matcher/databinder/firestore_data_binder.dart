import 'package:firebase_manager/firebase_manager.dart';

/// extend this class to bind the realtime data to the widget
///
abstract class FmFirestoreDataBinder<T extends FmMatcherDataset>
    extends AbsDataBinder<T> {
  /// get the branch of the dataset
  ///
  FireDoc getDataRef();

  @override
  Stream<Map<String, dynamic>?> getMap() {
    final branch = getDataRef();
    final resultStream = branch.readStream();
    return resultStream.map((data) {
      return data;
    });
  }

  @override
  Future<void> updateMap(Map<String, dynamic> map) async {
    final branch = getDataRef();
    await branch.update(map);
  }
}
