import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Firestore collection
class FireColl {
  final CollectionReference<Map<String, dynamic>> _reference;
  FireColl(CollectionReference<Map<String, dynamic>> reference)
      : _reference = reference;

  FireCollQuery get query => FireCollQuery(_reference);

  Future<List<FireDoc>> arrayFilter(String field,
      {Object? arrayContains, Iterable<Object?>? arrayContainsAny}) async {
    final querySs = await _reference
        .where(field,
            arrayContains: arrayContains, arrayContainsAny: arrayContainsAny)
        .get();
    return querySs.docs.map((e) => FireDoc(e.reference)).toList();
  }

  /// filter by field and value
  Future<List<FireDoc>> filter(String field, dynamic value) =>
      _reference.where(field, isEqualTo: value).get().then((value) {
        return value.docs.map((e) => FireDoc(e.reference)).toList();
      });

  /// filter by field and value as stream
  Stream<List<FireDoc>> filterWithStream(String field, dynamic value) =>
      _reference.where(field, isEqualTo: value).snapshots().map((event) {
        return event.docs.map((e) => FireDoc(e.reference)).toList();
      });

  /// get all documents in this collection
  Future<List<FireDocTuple<T>>> getAllDocs<T>({
    T Function(Map<String, dynamic>)? cast,
  }) async {
    final querySs = await _reference.get();
    return querySs.docs
        .map(
          (e) => FireDocTuple<T>(
            e,
            cast ?? (d) => d as T,
          ),
        )
        .toList();
  }

  /// get all documents in this collection by stream
  Stream<List<FireDocTuple<T>>> getAllDocsByStream<T>({
    T Function(Map<String, dynamic>)? cast,
  }) =>
      _reference.snapshots().map((event) {
        return event.docs
            .map(
              (e) => FireDocTuple<T>(
                e,
                cast ?? (d) => d as T,
              ),
            )
            .toList();
      });

  /// get FireDoc by name
  /// if name is null, it will generate a random name.
  FireDoc getAutoDoc([String? name]) {
    if (name == null) {
      return getRandomNameDoc();
    }
    return getDoc(name);
  }

  /// getDeepColl(name)
  /// == equal ==
  /// getDoc(name).getColl(name);
  FireColl getDeepColl(String name) => getDoc(name).getColl(name);

  /// Doc is a document in firestore
  /// Doc can include sub collections
  /// Doc can include fields and values
  FireDoc getDoc(String name) => FireDoc(_reference.doc(name));

  /// To build a list view with pagination
  Widget getListView({
    required Widget Function(BuildContext, FireDocDataset) itemBuilder,
    void Function(BuildContext)? onRefresh,
    int pageSize = 10,
    FirestoreLoadingBuilder? loadingBuilder,
    FirestoreErrorBuilder? errorBuilder,
    FirestoreEmptyBuilder? emptyBuilder,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    Widget? prototypeItem,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    // TODO: remove this and use filters
    (String, Object?)? equalWith,
    List<(String, Object?)>? filters,
    (String, bool)? orderBy,
  }) {
    Query query = _reference;

    // filter
    if (equalWith != null) {
      query = query.where(equalWith.$1, isEqualTo: equalWith.$2);
    }
    if (filters != null) {
      for (final filter in filters) {
        query = query.where(filter.$1, isEqualTo: filter.$2);
      }
    }

    if (orderBy != null) {
      query = query.orderBy(orderBy.$1, descending: orderBy.$2);
    }

    return FirestoreListView(
        query: query,
        onRefresh: onRefresh,
        pageSize: pageSize,
        loadingBuilder: loadingBuilder,
        errorBuilder: errorBuilder,
        emptyBuilder: emptyBuilder,
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,
        primary: primary,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: padding,
        itemExtent: itemExtent,
        prototypeItem: prototypeItem,
        addAutomaticKeepAlives: addAutomaticKeepAlives,
        addRepaintBoundaries: addRepaintBoundaries,
        addSemanticIndexes: addSemanticIndexes,
        cacheExtent: cacheExtent,
        semanticChildCount: semanticChildCount,
        dragStartBehavior: dragStartBehavior,
        keyboardDismissBehavior: keyboardDismissBehavior,
        restorationId: restorationId,
        clipBehavior: clipBehavior,
        itemBuilder: (context, snapshot) {
          final doc = FireDoc(
              snapshot.reference as DocumentReference<Map<String, dynamic>>);
          final data = snapshot.data() as Map<String, dynamic>;
          return itemBuilder(
              context, FireDocDataset(doc, FireDoc.castMap(data)!));
        });
  }

  FireDoc getRandomNameDoc() {
    return FireDoc(_reference.doc());
  }

  /// be sure your user is signed when you call this,
  /// else it will throw an exception.
  /// you can use getUserDocSafe() instead, it will return null if user is not signed in.
  FireDoc getUserDoc() {
    final userID = fs.auth.getNowUser()?.getID();
    if (userID == null) {
      throw Exception('User is not signed in');
    }
    return FireDoc(_reference.doc(userID));
  }

  /// if user is not signed in, it will return null
  FireDoc? getUserDocSafe() {
    final userID = fs.auth.getNowUser()?.getID();
    if (userID == null) {
      return null;
    }
    return FireDoc(_reference.doc(userID));
  }

  Future<List<FireDoc>> where(
    String field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) async {
    final querySs = await _reference
        .where(
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
        )
        .get();
    return querySs.docs.map((e) => FireDoc(e.reference)).toList();
  }

  Stream<List<FireDoc>> whereWithStream(
    String field, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    Iterable<Object?>? arrayContainsAny,
    Iterable<Object?>? whereIn,
    Iterable<Object?>? whereNotIn,
    bool? isNull,
  }) =>
      _reference
          .where(
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
          )
          .snapshots()
          .map((event) {
        return event.docs.map((e) => FireDoc(e.reference)).toList();
      });
}
