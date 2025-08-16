import 'dart:io';

import 'package:mime/mime.dart';

/// Extensions on [File] for metadata helpers.
extension FileX on File {
  /// Detects the file's MIME type by sampling the first ~100 bytes.
  ///
  /// Returns null if the file doesn't exist or cannot be identified.
  Future<String?> get mimeType async {
    if (!await exists()) return null;

    final reader = openRead();
    final bytes = <int>[];
    // Read the first 100(maybe) bytes to determine the file type.
    await reader.takeWhile((event) {
      bytes.addAll(event);
      return bytes.length < 100;
    }).drain();

    final mime = lookupMimeType(path, headerBytes: bytes);
    return mime;
  }
}
