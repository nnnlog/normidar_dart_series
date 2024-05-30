part of 'database_result.dart';

class ChildrenResult extends DatabaseResult {
  ChildrenResult(super.snapshot);

  /// convert map to data that you want,
  /// you can use freeze like: `childrenResult.convert(YouDataset.fromJson)`
  T convert<T>(T Function(Map<String, dynamic>) convertor) =>
      convertor(getDataMap());

  bool exists(String key) => getDataMap().containsKey(key);

  DatabaseResult? getChild(String key) {
    final children = _snapshot.children;
    for (final e in children) {
      if (e.key == key) {
        final snapshot = e;
        return DatabaseResult.create(snapshot);
      }
    }
    return null;
  }

  /// get data of a child,
  /// it is equal getValueResult(key)?.getContent();
  /// if you set T it can auto check cast.
  ///
  /// sweet candy!
  T? getChildData<T>(String key) {
    final valueResult = getValueResult(key)?.getContent();
    if (valueResult != null) {
      if (valueResult is T) {
        return valueResult;
      }
    }
    return null;
  }

  /// If the child is not ChildrenResult return null
  ChildrenResult? getChildrenResult(String key) {
    final result = getChild(key);
    if (result != null && result is ChildrenResult) {
      return result;
    }
    return null;
  }

  /// Get a map of data
  Map<String, dynamic> getDataMap() {
    final data = _snapshot.value;
    return makeAlwaysMap(data);
  }

  /// get keys of data
  List<String> getKeys() => getDataMap().keys.toList();

  /// If the child is not ValueResult return null
  ValueResult? getValueResult(String key) {
    final result = getChild(key);
    if (result != null && result is ValueResult) {
      return result;
    }
    return null;
  }

  /// some time real time database will auto
  /// make a map as a list, use this function to turn it back to map
  static Map<String, dynamic> makeAlwaysMap(Object? data) {
    if (data is List) {
      Map<String, dynamic> rt = {};
      for (var i = 0; i < data.length; i++) {
        if (data[i] == null) {
          continue;
        }
        rt[(i).toString()] = data[i];
      }
      return rt;
    } else if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    throw 'not implemented type';
  }
}
