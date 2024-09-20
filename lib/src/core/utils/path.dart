import 'dart:io';

import 'package:fl_lib/src/core/ext/string.dart';
import 'package:fl_lib/src/core/utils/platform/base.dart';
import 'package:path_provider/path_provider.dart';

abstract final class Paths {
  static late final String doc;
  static late final String dl;
  static late final String file;
  static late final String audio;
  static late final String video;
  static late final String img;
  static late final String cache;
  static late final String bakName;
  static late final String bak;
  static late final String font;

  /// Await [Paths.init] before using any of the paths
  static Future<void> init(String appName, String bakName) async {
    doc = await _getDoc(appName);
    dl = await _initDir('dl');
    file = await _initDir('file');
    audio = await _initDir('audio');
    video = await _initDir('video');
    img = await _initDir('img');
    cache = await _initDir('cache');
    font = doc.joinPath('font.ttf');
    Paths.bakName = bakName;
    bak = doc.joinPath(bakName);
  }

  static Future<String> _getDoc(String appName) async {
    assert(!isWeb);

    if (isAndroid) {
      final dir = await getExternalStorageDirectory();
      if (dir != null) return dir.path;
    }

    if (isLinux || isWindows) {
      final path = switch (Pfs.type) {
        Pfs.linux => Platform.environment['HOME']?.joinPath('.config'),
        Pfs.windows => Platform.environment['APPDATA'],
        _ => null,
      };
      final dir = Directory(path?.joinPath(appName) ?? '.${appName}_data');
      final p = (await dir.create()).path;

      // Move the db data created wrongly in the doc dir
      if (isLinux) {
        // $DOC/*.hive -> $HOME/.config/$APP/*.hive
        final wrong = await getApplicationDocumentsDirectory();
        await for (final file in wrong.list()) {
          if (file is! File || !file.path.endsWith('.hive')) continue;
          file.rename(p.joinPath(file.path.split('/').last));
        }
      }
      return p;
    }

    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static final temp = Directory.systemTemp.path;

  static Future<String> _initDir(String subPath) async {
    final dir = Directory(doc.joinPath(subPath));
    if (!await dir.exists()) {
      await dir.create();
    }
    return dir.path;
  }
}
