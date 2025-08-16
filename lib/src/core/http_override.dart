import 'dart:io';

/// HTTP overrides that respect system proxy environment variables.
///
/// Reads `HTTP_PROXY`/`http_proxy` and `HTTPS_PROXY`/`https_proxy` from the
/// environment and configures Dart's [HttpClient] to route requests accordingly.
class ProxyHttpOverrides extends HttpOverrides {
  /// The HTTP proxy URL (e.g. `http://127.0.0.1:7890`).
  final String? httpProxy;

  /// The HTTPS proxy URL (e.g. `http://127.0.0.1:7890`).
  final String? httpsProxy;

  ProxyHttpOverrides(this.httpProxy, this.httpsProxy);

  /// Installs [HttpOverrides.global] using proxy values from the environment.
  static void useSystemProxy() async {
    final httpProxy = Platform.environment['HTTP_PROXY'] ?? Platform.environment['http_proxy'];
    final httpsProxy = Platform.environment['HTTPS_PROXY'] ?? Platform.environment['https_proxy'];

    if (httpProxy != null || httpsProxy != null) {
      HttpOverrides.global = ProxyHttpOverrides(httpProxy, httpsProxy);
    }
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.findProxy = (uri) {
      if (uri.scheme == 'https' && httpsProxy != null) {
        return 'PROXY $httpsProxy';
      }
      if (httpProxy != null) {
        return 'PROXY $httpProxy';
      }
      return 'DIRECT';
    };
    return client;
  }
}
