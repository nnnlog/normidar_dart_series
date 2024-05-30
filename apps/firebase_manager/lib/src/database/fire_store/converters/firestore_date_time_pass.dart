import 'package:json_annotation/json_annotation.dart';

/// !! If you using fs to connect firestore, you should use this class. !!
///
///
/// use this like (import is required and must below @JsonKey):
///
/// ```
/// import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
///
/// @freezed
/// class TaskDataset with _$TaskDataset {
///
///   const factory TaskDataset({
///     required String task,
///     required bool isDone,
///     @JsonKey(includeIfNull: false)
///     @FirestoreDateTimePass()
///     required DateTime? createdAt,
///     bool? stared,
///   }) = _TaskDataset;
///
///   factory TaskDataset.fromJson(Map<String, dynamic> json) =>
///       _$TaskDatasetFromJson(json);
/// }
/// ```
class FirestoreDateTimePass implements JsonConverter<DateTime, DateTime> {
  const FirestoreDateTimePass();

  @override
  DateTime fromJson(DateTime dateTime) {
    return dateTime;
  }

  @override
  DateTime toJson(DateTime dateTime) {
    return dateTime;
  }
}
