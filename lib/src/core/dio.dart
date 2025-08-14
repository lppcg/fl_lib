import 'package:dio/dio.dart';

final myDio = Dio(
  BaseOptions(
    headers: {'lk-app-client': '1'},
    // Defer status handling to caller while not buffering on error bodies unnecessarily.
    validateStatus: (_) => true,
    followRedirects: true,
  ),
);
