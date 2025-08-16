import 'package:fl_lib/src/res/l10n.dart';

/// Extensions on [DateTime] for common string formats and utilities.

extension DateTimeX on DateTime {
  /// Returns time formatted as `HH:mm` with zero padding.
  String get hourMinute {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Returns date formatted as `yyyy{sep}MM{sep}dd`.
  ///
  /// - [sep] separator between year, month and day, defaults to `-`.
  String ymd([String? sep]) {
    sep ??= '-';
    final month = this.month.toString().padLeft(2, '0');
    final day = this.day.toString().padLeft(2, '0');
    return '$year$sep$month$sep$day';
  }

  /// Returns time formatted as `HH{sep}mm{sep}ss`.
  ///
  /// - [sep] separator between hour, minute and second, defaults to `:`.
  String hms([String? sep]) {
    sep ??= ':';
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    final second = this.second.toString().padLeft(2, '0');
    return '$hour$sep$minute$sep$second';
  }

  /// Returns time formatted as `HH{sep}mm`.
  ///
  /// - [sep] separator between hour and minute, defaults to `:`.
  String hm([String? sep]) {
    sep ??= ':';
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    return '$hour$sep$minute';
  }

  /// Returns `ymd(ymdSep) + sep + hms(hmsSep)`.
  ///
  /// - [ymdSep] separator for the date part.
  /// - [hmsSep] separator for the time part.
  /// - [sep] separator between date and time, defaults to a space.
  String ymdhms({String? ymdSep, String? hmsSep, String sep = ' '}) {
    return '${ymd(ymdSep)}$sep${hms(hmsSep)}';
  }

  /// All possible output: 2023-3-7 / 3-7 13:7 / 昨天 3:7 / 13:7
  String simple({
    String ymdSep = '-',
    String hmsSep = ':',
    String sep = ' ',
    DateTime? nowOverride,
  }) {
    final now = nowOverride ?? DateTime.now();
    final isToday = year == now.year && month == now.month && day == now.day;
    if (isToday) {
      return hm(hmsSep);
    }

    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayZero =
        DateTime(yesterday.year, yesterday.month, yesterday.day);
    final isYesterday = day == yesterdayZero.day;
    if (isYesterday) {
      return '${l10n.yesterday} $sep${hm(hmsSep)}';
    }

    if (year == now.year) {
      return '$month$ymdSep$day$sep${hm(hmsSep)}';
    }

    return ymd(ymdSep);
  }

  /// Current timestamp in milliseconds since epoch.
  static int get timestamp => DateTime.now().millisecondsSinceEpoch;
}
