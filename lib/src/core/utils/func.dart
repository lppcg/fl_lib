import 'dart:async';

/// Function utilities.
abstract final class Fns {
  static const _defaultDurationTime = 377;
  static const _defaultThrottleId = 'default';
  static final startTimeMap = <String, int>{_defaultThrottleId: 0};

  /// Throttle a function call by [duration] milliseconds.
  ///
  /// If called again within the window for the same [id], the invocation is
  /// ignored and [continueClick] is invoked (if provided). Returns the result
  /// of [func] when executed, otherwise `null` when throttled.
  static FutureOr<T?> throttle<T>(
    FutureOr<T> Function() func, {
    String id = _defaultThrottleId,
    int duration = _defaultDurationTime,
    Function? continueClick,
  }) async {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    if (currentTime - (startTimeMap[id] ?? 0) > duration) {
      startTimeMap[id] = DateTime.now().millisecondsSinceEpoch;
      return await func();
    } else {
      continueClick?.call();
      return null;
    }
  }
}
