import 'package:firebase_database/firebase_database.dart';

part 'children_result.dart';
part 'empty_result.dart';
part 'value_result.dart';

/// you can check it is ValueResult or ChildrenResult or EmptyResult
sealed class DatabaseResult {
  final DataSnapshot _snapshot;

  DatabaseResult(this._snapshot);

  String get name => _snapshot.key!;

  // always start with /
  String get path =>
      _snapshot.ref.path.substring(_snapshot.ref.path.indexOf('/'));

  /// if this is value, return null
  /// if this is children, return Map<String, dynamic>
  Map<String, dynamic>? asChildren() {
    return switch (this) {
      ValueResult() => null,
      EmptyResult() => null,
      ChildrenResult() => (this as ChildrenResult).getDataMap(),
    };
  }

  /// if this is value, return that
  /// if this is children, return null
  T? asValue<T>() {
    return switch (this) {
      ValueResult() => (this as ValueResult).getContent<T>(),
      ChildrenResult() => null,
      EmptyResult() => null,
    };
  }

  T when<T>({
    required T Function(dynamic) isValue,
    required T Function(Map<String, dynamic>) isChildren,
    required T Function() isEmpty,
  }) {
    return switch (this) {
      ValueResult() => isValue((this as ValueResult).getContent()),
      ChildrenResult() => isChildren((this as ChildrenResult).getDataMap()),
      EmptyResult() => isEmpty(),
    };
  }

  static DatabaseResult create(DataSnapshot snapshot) {
    if (!snapshot.exists) {
      return EmptyResult(snapshot);
    } else if (snapshot.children.isEmpty) {
      return ValueResult(snapshot);
    } else {
      return ChildrenResult(snapshot);
    }
  }
}
