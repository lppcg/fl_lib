import 'dart:ui';

import 'package:fl_lib/src/core/ext/obj.dart';
import 'package:fl_lib/src/view/widget/val_builder.dart';
import 'package:flutter/material.dart';

class OverlayWidget extends StatefulWidget {
  final Widget child;
  final Widget popup;
  final bool blurBg;

  const OverlayWidget({
    super.key,
    required this.child,
    required this.popup,
    this.blurBg = true,
  });

  static _OverlayWidgetState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<_OverlayWidgetState>();
  }

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;

  /// Can't use `late` because it's not initialized in [dispose]
  ///
  /// The animation controller is created when the overlay is shown.
  AnimationController? _animeCtrl;
  Animation<double>? _blurAnime;
  Animation<double>? _fadeAnime;

  final _isShowingOverlay = false.vn;

  @override
  void dispose() {
    _removeOverlaySafe();
    _animeCtrl?.dispose();
    super.dispose();
  }

  void _showOverlay(BuildContext context) async {
    final overlayState = Overlay.of(context);

    /// Only create once (`??=`)
    _animeCtrl ??= AnimationController(
      vsync: this,
      duration: Durations.medium1,
    );
    _blurAnime = Tween(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(parent: _animeCtrl!, curve: Curves.easeInOutCubic),
    );

    _fadeAnime = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animeCtrl!, curve: Curves.easeInOutCubic),
    );

    _overlayEntry = _createOverlayEntry(context);
    overlayState.insert(_overlayEntry!);

    await _animeCtrl?.forward();
    _isShowingOverlay.value = true;
  }

  void _removeOverlaySafe() async {
    // No overlay or controller created yet
    if (_overlayEntry == null || _animeCtrl == null) {
      _overlayEntry = null;
      _isShowingOverlay.value = false;
      return;
    }
    try {
      if (mounted) {
        await _animeCtrl!.reverse();
      }
      _overlayEntry?.remove();
    } finally {
      _overlayEntry = null;
      _isShowingOverlay.value = false;
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlaySafe,
        behavior: HitTestBehavior.opaque,
        child: _buildOverlayWidget(),
      ),
    );
  }

  Widget _buildOverlayWidget() {
    return AnimatedBuilder(
      animation: _animeCtrl!,
      builder: (_, __) {
        final fadeTransition = Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          child: FadeTransition(
            opacity: _fadeAnime!,
            child: Center(child: widget.popup),
          ),
        );
        if (!widget.blurBg) return fadeTransition;
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _blurAnime!.value,
            sigmaY: _blurAnime!.value,
          ),
          child: fadeTransition,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValBuilder(
      listenable: _isShowingOverlay,
      builder: (isShowing) {
        return PopScope(
          canPop: !isShowing,
          onPopInvokedWithResult: (didPop, _) {
            if (_overlayEntry == null) return;
            _removeOverlaySafe();
          },
          child: InkWell(
            borderRadius: BorderRadius.circular(7),
            onLongPress: () => _showOverlay(context),
            child: widget.child,
          ),
        );
      },
    );
  }
}
