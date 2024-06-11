import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:json_annotation/json_annotation.dart';

/// !! If you using fs to connect firestore, you should not use this class. !!
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
///     @FirestoreDateTimeConverter()
///     required DateTime? createdAt,
///     bool? stared,
///   }) = _TaskDataset;
///
///   factory TaskDataset.fromJson(Map<String, dynamic> json) =>
///       _$TaskDatasetFromJson(json);
/// }
/// ```
class FirestoreDateTimeConverter implements JsonConverter<DateTime, Timestamp> {
  const FirestoreDateTimeConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime dateTime) {
    return Timestamp.fromDate(dateTime);
  }
}
