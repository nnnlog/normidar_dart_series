import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fm_firestore/coll/fire_coll.dart';
import 'package:fm_firestore/ui/util/firestore_checkbox.dart';

class FireDoc {
  final DocumentReference<Map<String, dynamic>> _reference;
  DocumentSnapshot<Map<String, dynamic>>? _snapshot;


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
  // FireColl getUserColl() {
  //   final userID = fs.auth.getNowUser()?.getID();
  //   if (userID == null) {
  //     throw Exception('no user');
  //   }
  //   return FireColl(_reference.collection(userID));
  // }

  // FireColl? getUserCollSafe() {
  //   final userID = fs.auth.getNowUser()?.getID();
  //   if (userID == null) {
  //     return null;
  //   }
  //   return FireColl(_reference.collection(userID));
  // }

  /// this will save a snapshot and listen the change of fields
  ///
  /// must await this please
  ///
  /// TODO: fix this: _streamHolder will be disposed because it is not static
  Future<Object?> getValue(String key) async {
    Object? rt;

    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _getSnapshot();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null) {
        rt = data[key];
      }
    }
    return _castItem(rt);
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

    return id;
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
