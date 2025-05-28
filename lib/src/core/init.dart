import 'dart:async';

import 'package:computer/computer.dart';
import 'package:fl_lib/fl_lib.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';

/// All components to initialize the `fl_lib` package and the apps depend on this.
abstract final class Inits {
  /// Initialize the `fl_lib` package.
  ///
  /// Call this in the main function of the app.
  ///
  /// - [computerCounts] is the number of workers to run in parallel.
  /// - [appName] is the name of the app.
  /// - [bakName] is the name of the backup file.
  Future<void> initFlLibMain({
    int computerCounts = 3,
    required String appName,
    String? bakName,
    List<TypeAdapter<dynamic>> hiveAdapters = const [],
  }) async {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      DebugProvider.addLog(record);
      dprint(record);
      if (record.error != null) dprint(record.error);
      if (record.stackTrace != null) dprint(record.stackTrace);
    });

    await Paths.init(appName, bakName: bakName); // Keep this first.
    await PrefStore.shared.init();

    // You can view [Future.wait]'s implementation to understand why it's used here
    // and why put the [Paths.init] out of this.
    //
    // ps: [Future.wait] is a function to run multiple futures in parallel. It's a
    // non-order function.
    final futures = <Future<dynamic>>[];
    futures.add(Hive.initFlutter());
    futures.add(Computer.shared.turnOn(workersCount: computerCounts));
    await Future.wait(futures);

    for (final adapter in hiveAdapters) {
      Hive.registerAdapter(adapter);
    }
  }

  /// Wrap the [body] in a zone to catch all errors.
  ///
  /// - [body] is the function to run in the zone. Commonly the main function.
  void runInZone(void Function() body) {
    final zoneSpec = ZoneSpecification(
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        parent.print(zone, line);
      },
    );

    runZonedGuarded(
      body,
      // ignore: avoid_print
      (e, s) => print('[ZONE] $e\n$s'),
      zoneSpecification: zoneSpec,
    );
  }
}
