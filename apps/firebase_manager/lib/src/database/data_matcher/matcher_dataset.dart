/// example:
/// ```dart
/// class TeamProfileDataset extends FmMatcherDataset {
///   TeamProfileDataset(Map<String, dynamic> map)
///       : description = map['description'],
///         leader = map['leader'],
///         name = map['name'],
///         createdAt = map['createdAt'];
///
///   TeamProfileDataset.byParams({
///     required this.description,
///     required this.leader,
///     required this.name,
///     this.createdAt,
///   });
///
///   // description: String
///   String description;
///   // leader: String
///   String leader;
///   // name: String
///   String name;
///   // createdAt: DateTime?
///   DateTime? createdAt;
///
///   @override
///   Map<String, dynamic> toMap() => {
///         'description': description,
///         'leader': leader,
///         'name': name,
///         'createdAt': createdAt,
///       };
/// }
///
/// ```
abstract class FmMatcherDataset {
  const FmMatcherDataset();
  Map<String, dynamic> toMap();
}
