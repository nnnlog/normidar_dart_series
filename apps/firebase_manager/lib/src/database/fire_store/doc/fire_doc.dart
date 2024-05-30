import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/material.dart';

class FireDoc {
  final DocumentReference<Map<String, dynamic>> _reference;
  DocumentSnapshot<Map<String, dynamic>>? _snapshot;

  StreamHolder<DocumentSnapshot<Map<String, dynamic>>>? _streamHolder;

  FireDoc(DocumentReference<Map<String, dynamic>> reference)
      : _reference = reference;

  Future<void> addToList<T>(String key, T value) async {
    final map = (await _reference.get()).data();
    final lst = (map?[key] as List?)?.cast<T>();
    map?[key] = (lst?..add(value)) ?? [value];
    await _reference.set(map ?? {});
  }

  Future<bool> checkFieldExists(String field) async =>
      (await _getSnapshot()).data()?.containsKey(field) ?? false;

  /// convert map to data that you want,
  /// you can use freeze like: `childrenResult.convert(YouDataset.fromJson)`
  Future<T?> convert<T>(T Function(Map<String, dynamic>) convertor) async {
    final data = await get();
    if (data != null && data.isNotEmpty) {
      convertor(data);
    }
    return null;
  }

  Future<T> convertForce<T>(T Function(Map<String, dynamic>) convertor) async {
    final data = await get();
    if (data != null && data.isNotEmpty) {
      return convertor(data);
    }
    throw Exception('data is null');
  }

  /// convert stream version.
  Stream<T?> convertStream<T>(T Function(Map<String, dynamic>) convertor) {
    return readStream().map((event) {
      if (event != null && event.isNotEmpty) {
        return convertor(event);
      }
      return null;
    });
  }

  Stream<T> convertStreamForce<T>(T Function(Map<String, dynamic>) convertor) {
    return readStream().map((event) {
      if (event != null && event.isNotEmpty) {
        return convertor(event);
      }
      throw Exception('event is null');
    });
  }

  Future<void> delete() => _reference.delete();

  Future<Map<String, dynamic>?> get() async {
    final snapshot = await _getSnapshot();
    return castMap(snapshot.data());
  }

  /// get a checkbox widget
  /// the data of key must be bool
  Widget getCheckbox(String key) => FirestoreCheckbox(doc: this, dataKey: key);

  /// Coll is a collection in firestore
  /// Coll just can include documents
  FireColl getColl(String name) => FireColl(_reference.collection(name));

  Future<FireDoc?> getDocFromField(String field) async {
    final snapshot = await _getSnapshot();
    final doc = snapshot.data()?[field];
    if (doc is DocumentReference<Map<String, dynamic>>) {
      return FireDoc(doc);
    } else {
      return null;
    }
  }

  Future<PoolFile?> getFilePool(String key) async {
    final data = await get();
    final md5 = data?[key];
    if (md5 is String) {
      return await fs.db.storage.getPoolFile(md5);
    }
    return null;
  }

  String getID() => _reference.id;

  /// this Get will include id in the map.
  Future<Map<String, dynamic>?> getIncludeIDMap() async {
    final snapshot = await _getSnapshot();
    final data = snapshot.data();
    if (data != null) {
      data['id'] = snapshot.id;
    }
    return data;
  }

  /// use this to add a reference to a field
  /// like ...set({'rr':fireDoc.getMapRef()})
  Object getMapRef() => _reference;

  /// ## !!! Be careful !!!
  ///
  /// If you use this on your last coll,
  ///  you will lose the auto index feature of firestore.
  ///
  /// **do not use this on your last coll.**
  ///
  /// ## !!! Be careful !!!
  FireColl getUserColl() {
    final userID = fs.auth.getNowUser()?.getID();
    if (userID == null) {
      throw Exception('no user');
    }
    return FireColl(_reference.collection(userID));
  }

  FireColl? getUserCollSafe() {
    final userID = fs.auth.getNowUser()?.getID();
    if (userID == null) {
      return null;
    }
    return FireColl(_reference.collection(userID));
  }

  /// this will save a snapshot and listen the change of fields
  ///
  /// must await this please
  ///
  /// TODO: fix this: _streamHolder will be disposed because it is not static
  Future<Object?> getValue(String key) async {
    Log.debug(() => 'fire_doc.dart getValue: $key');
    final streamHolder = _streamHolder;
    Object? rt;

    late DocumentSnapshot<Map<String, dynamic>> snapshot;
    if (streamHolder == null) {
      final streamHolder = StreamHolder(_reference.snapshots());
      _streamHolder = streamHolder;
      snapshot = await streamHolder.init();
    } else {
      snapshot = streamHolder.value;
    }

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null) {
        rt = data[key];
      }
    }
    return _castItem(rt);
  }

  /// FmSingleMatcher
  Widget getValueWidget<T>(
      String key, Widget Function(BuildContext, T) builder) {
    return FmDataSingleMatcher<T>(
        binder: FmFirestoreSingleBinder(doc: this, fieldName: key),
        builder: builder);
  }

  /// FmDataMatcher
  Widget getWidget<T extends FmMatcherDataset>(
      {required T Function(Map<String, dynamic>) constructor,
      required Widget Function(BuildContext, T) builder}) {
    return FmDataMatcher(
      binder: FmFirestoreDefaultBinder(doc: this, constructor: constructor),
      builder: builder,
    );
  }

  /// TODO:
  /// research this function
  /// when doc not exists?
  /// when doc exists?
  /// when doc exists but no data?
  /// when doc delete?
  Stream<Map<String, dynamic>?> readStream() =>
      _reference.snapshots().map((event) => castMap(event.data()));

  Future<void> set(Map<String, dynamic> data) => _reference.set(data);

  @override
  String toString() => 'FireDoc{${_reference.path}}';

  /// Updates data on the document. Data will be merged with any existing document data.
  ///
  /// Objects key can be a String or a FieldPath.
  ///
  /// return id
  Future<String> update(Map<String, dynamic> data) async {
    Log.debug(() => 'fire_doc.dart update: $data');
    try {
      await _reference.update(data);
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        await _reference.set({});
        await _reference.update(data);
      } else {
        rethrow;
      }
    }
    final id = getID();

    Log.debug(() => 'fire_doc.dart update: $data, id: $id');
    return id;
  }

  /// please premiss the file exists
  Future<void> updateAsFilePool(String key, File file) async {
    if (!await file.exists()) {
      throw Exception('file not exists');
    }
    final pFile = await fs.db.storage.uploadPoolFile(file);
    await update({key: pFile?.md5});
  }

  Future<String> updateMatcherDataset(FmMatcherDataset dataset) async {
    final map = dataset.toMap();
    return await update(map);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getSnapshot() async {
    final snapshot = _snapshot;
    if (snapshot != null) {
      return snapshot;
    } else {
      final snapshot = await _reference.get();
      _snapshot = snapshot;
      return snapshot;
    }
  }

  static Map<String, dynamic>? castMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    map.forEach((key, value) {
      map[key] = _castItem(value);
    });
    return map;
  }

  static dynamic _castItem(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is List<dynamic>) {
      if (value.isNotEmpty) {
        final first = value.first;
        if (first is String) {
          return value.cast<String>();
        } else if (first is int) {
          return value.cast<int>();
        } else if (first is double) {
          return value.cast<double>();
        } else if (first is bool) {
          return value.cast<bool>();
        } else {
          throw Exception("not support type: ${first.runtimeType}");
        }
      }
    }
    return value;
  }
}
