import 'package:fl_lib/fl_lib.dart';

extension ObjectX<T extends Object> on T {
  bool get isBaseType {
    return this is String ||
        this is int ||
        this is double ||
        this is bool ||
        this is List ||
        this is Map;
  }

  VNode<T> get vn => VNode<T>(this);
}

extension ObjectXNullable<T extends Object> on T? {
  /// ```dart
  /// final (a, b) = (1, null);
  /// assert(a.nullOr((a) => a + 1) == 2);
  /// assert(b.nullOr((b) => b + 1) == null);
  /// ```
  ///
  /// Bad: `null.nullOr(() => 1)` => `null ?? 1`
  A? nullOr<A>(A Function(T) f) => this != null ? f(this!) : null;

  VNode<T?> get vn => VNode<T?>(this);
}

/// Abbereviation of `Nullable ValueNotifier` -> nvn
VNode<T?> nvn<T>() => VNode<T?>(null);
