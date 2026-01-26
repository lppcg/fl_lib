import 'package:flutter/widgets.dart';

import 'image_stub.dart'
    if (dart.library.io) 'image_io.dart'
    if (dart.library.js_interop) 'image_web.dart';

abstract final class PlatformImage {
  static ImageProvider file(String path, {String? imageCacheName}) =>
      getFileImage(path, imageCacheName: imageCacheName);
}
