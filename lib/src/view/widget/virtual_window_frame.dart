import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart' as wm;

abstract final class WindowFrameConfig {
  static bool _showCaption = true;

  static bool get showCaption => _showCaption && isDesktop;

  static void setShowCaption(bool value) {
    _showCaption = value;
  }
}

class VirtualWindowFrame extends StatelessWidget {
  final Widget child;

  /// Title of the window.
  final String? title;

  /// Whether to show the virtual window caption.
  /// 
  /// Only affects desktop platforms. When set to false, the virtual caption will be hidden,
  /// which is useful when the native title bar is shown.
  final bool showCaption;

  const VirtualWindowFrame({super.key, required this.child, this.title, this.showCaption = true});

  @override
  Widget build(BuildContext context) {
    final content = switch (CustomAppBar.sysStatusBarHeight) {
      0.0 => child,
      _ when showCaption && WindowFrameConfig.showCaption => Column(
          children: [
            _WindowCaption(title: title),
            Expanded(child: child),
          ],
        ),
      _ => child,
    };
    return wm.VirtualWindowFrame(child: content);
  }
}

class _WindowCaption extends StatelessWidget {
  final String? title;

  const _WindowCaption({this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      height: CustomAppBar.sysStatusBarHeight,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (title != null)
            Material(
              color: Colors.transparent,
              child: Text(
                title!,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          if (isLinux || isWindows)
            wm.WindowCaption(
              backgroundColor: Colors.transparent,
              brightness: theme.brightness,
            )
        ],
      ),
    );
  }
}
