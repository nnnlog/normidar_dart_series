import 'dart:io';

class Downloaded extends DownloadProgress {
  final File file;
  final String? hash;
  const Downloaded(
    this.file, {
    required this.hash,
  });
}

class Downloading extends DownloadProgress {
  final double progress;

  const Downloading(this.progress);
}

sealed class DownloadProgress {
  const DownloadProgress();
}
