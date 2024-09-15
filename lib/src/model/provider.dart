import 'dart:async';

import 'package:fl_lib/src/core/build_mode.dart';
import 'package:flutter/foundation.dart';

abstract class Provider<T> {
  const Provider();

  /// (Re)Load data from store / network / etc.
  @mustCallSuper
  FutureOr<void> load() {
    all.add(this);
    dprint('$runtimeType loaded');
  }

  static final all = <Provider>{};

  static Future<void> reload() {
    return Future.wait(all.map((e) async => await e.load()));
  }
}