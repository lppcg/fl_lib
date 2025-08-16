import 'package:dio/dio.dart';

/// Shared Dio client with sensible defaults.
///
/// - Adds a lightweight `lk-app-client` header for observability.
/// - Uses [validateStatus] that always returns true so callers handle
///   non-2xx responses explicitly without throwing.
/// - Follows redirects by default.
final myDio = Dio(
  BaseOptions(
    headers: {'lk-app-client': '1'},
    // Defer status handling to caller while not buffering on error bodies unnecessarily.
    validateStatus: (_) => true,
    followRedirects: true,
  ),
);
