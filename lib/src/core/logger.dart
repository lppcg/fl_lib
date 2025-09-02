// ignore_for_file: avoid_print

import 'dart:io';

import 'package:fl_lib/fl_lib.dart';
import 'package:logging/logging.dart';

/// Centralized logger instances and helpers.
abstract final class Loggers {
  static final root = Logger('Root');
  static final store = Logger('Store');
  static final route = Logger('Route');
  static final app = Logger('App');

  /// Regex to extract source file and line number from a stack trace.
  static final sourceReg = RegExp(r'\((.+):(\d+):(\d+)\)');

  /// Logs a message with the source file and line number.
  static void log(Object message, {int skipFrames = 1}) {
    final traceLines = StackTrace.current.toString().split('\n');

    if (traceLines.length > skipFrames) {
      final caller = traceLines[skipFrames];
      final match = sourceReg.firstMatch(caller);
      if (match != null) {
        String? file = match.group(1)?.replaceFirst('file://', '');
        final line = match.group(2);
        if (file != null) {
          final pwd = Directory.current.path;
          if (file.startsWith(pwd)) {
            file = file.substring(pwd.length + 1); // +1 to remove the leading '/'
            file = './$file'; // Make it relative
          }
        }
        print('[$file:$line] $message');
        return;
      }
    }
    print(message);
  }
}

/// Print [msg]s only in debug mode.
///
/// Extra [msg2]/[msg3]/[msg4] are concatenated with tabs. Uses [lprint]
/// internally with [skipFrames] adjusted for accurate source location.
void dprint(Object? msg, [Object? msg2, Object? msg3, Object? msg4]) {
  if (!BuildMode.isDebug) return;
  lprint(msg, msg2, msg3, msg4, 3);
}

/// Print [msg]s to console and debug provider.
///
/// With [Loggers.log], it also prints the source file and line number when
/// available. [skipFrames] controls how many stack frames to skip to find the
/// caller site.
void lprint(Object? msg, [Object? msg2, Object? msg3, Object? msg4, int skipFrames = 2]) {
  final sb = StringBuffer();
  sb.write(msg.toString()); // Always print the first message

  if (msg2 != null) {
    sb.write('\n$msg2');
    if (msg3 != null) {
      sb.write('\n$msg3');
      if (msg4 != null) {
        sb.write('\n$msg4');
      }
    }
  }
  final str = sb.toString();
  Loggers.log(str, skipFrames: skipFrames);
  DebugProvider.addString(str);
}
