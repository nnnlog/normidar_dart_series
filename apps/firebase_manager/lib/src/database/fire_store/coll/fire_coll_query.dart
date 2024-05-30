import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_manager/firebase_manager.dart';

part 'fire_coll_filter.dart';

class FireCollQuery {
  final Query<Map<String, dynamic>> _query;

  FireCollQuery(this._query);

  FireCollQuery filter(String field, dynamic value) =>
      FireCollQuery(_query.where(field, isEqualTo: value));

  Future<List<FireDoc>> get() => _query.get().then((value) {
        return value.docs.map((e) => FireDoc(e.reference)).toList();
      });

  Future<List<FireDocTuple<T>>> getTuple<T>(
    T Function(Map<String, dynamic>) f,
  ) =>
      _query.get().then(
          (value) => value.docs.map((e) => FireDocTuple<T>(e, f)).toList());

  Stream<List<FireDocTuple<T>>> getTupleWithStream<T>(
    T Function(Map<String, dynamic>) f,
  ) =>
      _query.snapshots().map(
          (value) => value.docs.map((e) => FireDocTuple<T>(e, f)).toList());

  Stream<List<FireDoc>> getWithStream() => _query.snapshots().map((value) {
        return value.docs.map((e) => FireDoc(e.reference)).toList();
      });

  FireCollQuery logic(FireCollFilter filter) =>
      FireCollQuery(_query.where(filter._filter));

  FireCollQuery orderBy(String field, {bool descending = false}) =>
      FireCollQuery(_query.orderBy(field, descending: descending));

  FireCollQuery where(
    String field, {
    dynamic isEqualTo,
    dynamic isNotEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
    List<dynamic>? arrayContains,
    List<dynamic>? arrayContainsAny,
    List<dynamic>? arrayContainsAll,
    Iterable<Object?>? whereIn,
    List<dynamic>? whereNotIn,
    bool? isNull,
  }) {
    return FireCollQuery(_query.where(
      field,
      isEqualTo: isEqualTo,
      isNotEqualTo: isNotEqualTo,
      isLessThan: isLessThan,
      isLessThanOrEqualTo: isLessThanOrEqualTo,
      isGreaterThan: isGreaterThan,
      isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
      arrayContains: arrayContains,
      arrayContainsAny: arrayContainsAny,
      whereIn: whereIn,
      whereNotIn: whereNotIn,
      isNull: isNull,
    ));
  }
}
