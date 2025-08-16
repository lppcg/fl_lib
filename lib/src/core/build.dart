/// Build mode helpers and detection.
///
/// See: https://github.com/flutter/flutter/issues/11392
enum BuildMode {
  release,
  debug,
  profile,
  ;

  /// True when running in Debug mode.
  static final isDebug = _buildMode == BuildMode.debug;
  /// True when running in Profile mode.
  static final isProfile = _buildMode == BuildMode.profile;
  /// True when running in Release mode.
  static final isRelease = _buildMode == BuildMode.release;
}

final _buildMode = () {
  if (const bool.fromEnvironment('dart.vm.product')) {
    return BuildMode.release;
  }
  var result = BuildMode.profile;
  assert(() {
    result = BuildMode.debug;
    return true;
  }());
  return result;
}();
