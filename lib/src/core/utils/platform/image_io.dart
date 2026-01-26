import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';

ImageProvider getFileImage(String path, {String? imageCacheName}) =>
    ExtendedFileImageProvider(File(path), imageCacheName: imageCacheName);
