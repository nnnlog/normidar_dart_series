class FileCompare {
  final String? originHash;
  final String? localHash;

  const FileCompare({
    required this.originHash,
    required this.localHash,
  });

  bool get isSame =>
      originHash != null && localHash != null && originHash == localHash;
}
