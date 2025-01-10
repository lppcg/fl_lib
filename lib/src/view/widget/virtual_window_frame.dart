import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart' as wm;

class VirtualWindowFrame extends StatelessWidget {
  const VirtualWindowFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return wm.VirtualWindowFrame(
      child: isMacOS
          ? child
          : Column(
              children: [
                _WindowCaption(),
                Expanded(child: child),
              ],
            ),
    );
  }
}

class _WindowCaption extends StatelessWidget {
  const _WindowCaption();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: wm.kWindowCaptionHeight,
      width: double.infinity,
      child: wm.WindowCaption(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        brightness: Theme.of(context).brightness,
      ),
    );
  }
}
