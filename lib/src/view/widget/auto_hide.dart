import 'dart:async';
import 'package:flutter/material.dart';

final class AutoHide extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final AxisDirection direction;
  final double offset;
  final AutoHideController? hideController;

  const AutoHide({
    super.key,
    required this.child,
    required this.scrollController,
    required this.direction,
    this.hideController,
    this.offset = 55,
  })  : assert(offset >= 0, 'Offset must be greater than or equal to 0'),
        assert(key is! GlobalKey, 'GlobalKey is not recommended, use hideController instead');

  @override
  State<AutoHide> createState() => AutoHideState();
}

final class AutoHideState extends State<AutoHide> {
  bool _isScrolling = false;
  Timer? _timer;
  Timer? _scrollDebouncer;
  late final _controller = widget.hideController ?? AutoHideController();

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_scrollListener);
    _setupTimer();
    _controller.addListener(_onControllerUpdate);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    _controller.removeListener(_onControllerUpdate);
    if (widget.hideController == null) {
      _controller.dispose();
    }
    _timer?.cancel();
    _scrollDebouncer?.cancel();
    _timer = _scrollDebouncer = null;
    super.dispose();
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  void _setupTimer() {
    // Cancel any existing timer
    _timer?.cancel();
    // If auto-hide is disabled, don't set up a new timer
    if (!_controller.autoHideEnabled) return;

    // Create a new timer that will fire after 3 seconds
    _timer = Timer(const Duration(seconds: 3), () {
      // Don't hide if widget is unmounted or user is currently scrolling
      if (!mounted || _isScrolling) return;
      // Don't hide if already hidden
      if (!_controller.visible) return;

      // Check if scrolling is possible
      final canScroll = widget.scrollController.hasClients && widget.scrollController.position.maxScrollExtent > 0;
      if (!canScroll) return;

      // Hide the widget
      _controller.hide();
    });
  }

  void _scrollListener() {
    if (!mounted || !_controller.autoHideEnabled) return;

    _isScrolling = true;
    _scrollDebouncer?.cancel();
    _scrollDebouncer = Timer(const Duration(milliseconds: 100), () {
      _isScrolling = false;
      if (!_controller.visible) {
        _controller.show();
        _setupTimer();
      }
    });

    if (!_controller.visible) {
      _controller.show();
      _setupTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.medium1,
      curve: Curves.easeInOutCubic,
      transform: _transform,
      child: widget.child,
    );
  }

  Matrix4? get _transform {
    final visible = _controller.visible;
    switch (widget.direction) {
      case AxisDirection.down:
        return visible ? Matrix4.identity() : Matrix4.translationValues(0, widget.offset, 0);
      case AxisDirection.up:
        return visible ? Matrix4.identity() : Matrix4.translationValues(0, -widget.offset, 0);
      case AxisDirection.left:
        return visible ? Matrix4.identity() : Matrix4.translationValues(-widget.offset, 0, 0);
      case AxisDirection.right:
        return visible ? Matrix4.identity() : Matrix4.translationValues(widget.offset, 0, 0);
    }
  }
}

class AutoHideController extends ChangeNotifier {
  bool _visible = true;
  bool get visible => _visible;

  void show() {
    if (_visible) return;
    _visible = true;
    notifyListeners();
  }

  void hide() {
    if (!_visible) return;
    _visible = false;
    notifyListeners();
  }

  bool autoHideEnabled = true;
}
