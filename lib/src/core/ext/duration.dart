import 'package:fl_lib/src/res/l10n.dart';

/// Extensions on [Duration] for localized formatting.

extension DurationX on Duration {
  /// Returns a concise localized string for this duration's absolute value.
  ///
  /// Example outputs: `2 day`, `3 hour`, `15 minute`, `42 second`.
  String get toAgoStr {
    final abs_ = abs();
    final days = abs_.inDays;
    if (days > 0) {
      return '$days ${l10n.day}';
    }
    final hours = abs_.inHours;
    if (hours > 0) {
      return '$hours ${l10n.hour}';
    }
    final minutes = abs_.inMinutes;
    if (minutes > 0) {
      return '$minutes ${l10n.minute}';
    }
    final seconds = abs_.inSeconds;
    return '$seconds ${l10n.second}';
  }
}
