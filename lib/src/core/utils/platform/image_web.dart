import 'package:extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';

ImageProvider getFileImage(String path, {String? imageCacheName}) =>
    ExtendedNetworkImageProvider(path, imageCacheName: imageCacheName);
