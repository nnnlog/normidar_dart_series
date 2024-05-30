import 'package:firebase_manager/src/database/data_matcher/matcher_dataset.dart';

/// use to bind data from firebase to dataset
abstract class AbsDataBinder<T extends FmMatcherDataset> {
  /// get the dataset
  ///
  /// override example:
  /// ```
  /// Stream<T> getDataset() => getMap().map((event) => MyRealtimeDataset(event));
  Stream<T> getDataset();

  Stream<Map<String, dynamic>?> getMap();

  Future<void> updateDataset(T dataset) {
    return updateMap(dataset.toMap());
  }

  Future<void> updateMap(Map<String, dynamic> map);
}
