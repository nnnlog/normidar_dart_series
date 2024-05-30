import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// realtime database branch
class RealtimeBranch {
  final RealtimeBranch? parent;
  final String name;
  RealtimeBranch(this.parent, this.name);

  Future delete(String field) => RealtimeUtil.delete(getPath() + field);

  // TODO: check what will happen when we get a empty path
  RealtimeBranch getChild(dynamic name) =>
      RealtimeBranch(this, name.toString());

  /// Get data stream
  /// Be sure your data is a map
  ///
  /// you can use freezed or json_serializable with builder.
  Stream<T> getDataStream<T>(T Function(Map<String, dynamic>) builder) =>
      readStream().map((event) => switch (event) {
            ChildrenResult() => builder(event.getDataMap()),
            _ => throw Exception('This branch is not a map'),
          });

  RealtimeBranch getIdChild() =>
      getChild(fs.auth.getUserID() ?? '@has_not_uid@');

  /// get a view form branch
  ///
  /// this widget can auto change view if data changed
  ///
  Widget getListView({
    String? orderByChild,
    bool orderByKey = false,
    bool orderByValue = false,
    int pageSize = 10,
    FirebaseLoadingBuilder? loadingBuilder,
    FirebaseErrorBuilder? errorBuilder,
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
    Widget Function(BuildContext, int)? separatorBuilder,
    Object? valueFilter,
    Clip clipBehavior = Clip.hardEdge,
    void Function(BuildContext)? onRefresh,
    required Widget Function(BuildContext, DatabaseResult) itemBuilder,
  }) {
    Query query = FirebaseDatabase.instance.ref(getPath());
    if (orderByChild != null) {
      query = query.orderByChild(orderByChild);
    }
    if (orderByKey) {
      query = query.orderByKey();
    }
    if (orderByValue || valueFilter != null) {
      query = query.orderByValue();
    }
    if (valueFilter != null) {
      query = query.equalTo(valueFilter);
    }

    return FirebaseDatabaseListView(
      pageSize: pageSize,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
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
      query: query,
      separatorBuilder: separatorBuilder,
      onRefresh: onRefresh != null
          ? (context, _) {
              onRefresh(context);
            }
          : null,
      itemBuilder: (context, snapshot) {
        final dr = DatabaseResult.create(snapshot);
        return itemBuilder(context, dr);
      },
    );
  }

  String getPath() {
    return '${parent?.getPath() ?? ''}$name/';
  }

  /// get ChildrenResult or ValueResult
  ///
  /// e.g.
  /// ```
  /// final result = await ....read('........');
  /// if (result is ChildrenResult){
  ///   result.children
  /// } else if (result is ValueResult) {
  ///   result.getContent();
  /// }
  /// ```
  Future<DatabaseResult> read() async {
    final path = getPath();
    final ref = FirebaseDatabase.instance.ref(path);
    DatabaseEvent event = await ref.once();
    final rt = DatabaseResult.create(event.snapshot);
    return rt;
  }

  /// read data stream
  Stream<DatabaseResult> readStream() {
    final path = getPath();
    final ref = FirebaseDatabase.instance.ref(path);
    return ref.onValue.map((event) {
      return DatabaseResult.create(event.snapshot);
    });
  }

  /// default is asc, if you want desc, set asc to false
  Stream<DatabaseResult> searchChildrenStream({
    bool asc = true,
    required int limit,
    String? orderField,
  }) {
    final path = getPath();
    Query query = FirebaseDatabase.instance.ref(path);
    if (orderField != null) {
      query = query.orderByChild(orderField);
    }
    if (asc) {
      query = query.limitToFirst(limit);
    } else {
      query = query.limitToLast(limit);
    }
    return query.onValue.map((event) {
      return DatabaseResult.create(event.snapshot);
    });
  }

  Future updateMatcherDataset(FmMatcherDataset dataset) {
    return RealtimeUtil.write(getPath(), dataset.toMap());
  }

  /// only when child is a value return a stream of value.
  Stream<T> valueStream<T>() {
    return readStream().map((event) {
      return switch (event) {
        ValueResult() => event.getContent<T>(),
        _ => throw Exception('This branch is not a value'),
      };
    });
  }

  Future write(String field, Object? value) {
    return RealtimeUtil.write(getPath() + field, value);
  }

  Future writeMap(Map<String, dynamic> map) {
    return RealtimeUtil.write(getPath(), map);
  }

  /// write the string, you can use the encrypt feature
  Future writeString(String value, [StringEncryptType? encryptType]) {
    return RealtimeUtil.writeString(getPath(), value, encryptType);
  }
}
