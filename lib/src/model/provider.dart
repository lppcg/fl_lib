import 'dart:async';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';

/// Base provider abstraction with lifecycle hooks.
///
/// Implement [load] to fetch or restore state from storage/network. All
/// instances are tracked in [all] for bulk [reload] operations.
abstract class Provider {
  const Provider();

  /// (Re)Load data from store / network / etc.
  @mustCallSuper
  FutureOr<void> load() {
    all.add(this);
    dprint('$runtimeType loaded');
  }

  /// Set of all instantiated providers that invoked [load].
  static final all = <Provider>{};

  /// Reload all registered providers by invoking their [load] method.
  static Future<void> reload() {
    return Future.wait(all.map((e) async => await e.load()));
  }
}
