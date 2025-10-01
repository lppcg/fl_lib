import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';

/// Material Design implementation of [SelectionToolbarController]
class AdaptiveSelectionToolbarController extends SelectionToolbarController {
  AdaptiveSelectionToolbarController({
    this.animationConfig = SelectionToolbarAnimationConfig.material,
  });

  final SelectionToolbarAnimationConfig animationConfig;
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;

  @override
  void show({
    required BuildContext context,
    required CodeLineEditingController controller,
    required TextSelectionToolbarAnchors anchors,
    Rect? renderRect,
    required LayerLink layerLink,
    required ValueNotifier<bool> visibility,
  }) {
    if (_isVisible) {
      hide(context);
    }

    // line height is 17
    final topOffset = CustomAppBar.sysStatusBarHeight + CustomAppBar.appBarHeight + 17;

    final adjustedAnchors = TextSelectionToolbarAnchors(
      primaryAnchor: anchors.primaryAnchor.translate(0, -topOffset),
      secondaryAnchor: anchors.secondaryAnchor?.translate(0, -topOffset),
    );

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return _AnimatedCodeLineSelectionToolbar(
          controller: controller,
          anchors: adjustedAnchors,
          renderRect: renderRect,
          layerLink: layerLink,
          onHide: () => hide(context),
          animationConfig: animationConfig,
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    _isVisible = true;
    visibility.value = true;
  }

  @override
  void hide(BuildContext context) {
    if (_overlayEntry != null && _isVisible) {
      final overlayEntry = _overlayEntry!;
      _isVisible = false;

      if (overlayEntry.mounted) {
        Future.delayed(animationConfig.duration, () {
          if (overlayEntry.mounted) {
            overlayEntry.remove();
          }
          _overlayEntry = null;
        });
      } else {
        _overlayEntry = null;
      }
    }
  }

  bool get isVisible => _isVisible;
}

class _AnimatedCodeLineSelectionToolbar extends StatefulWidget {
  const _AnimatedCodeLineSelectionToolbar({
    required this.controller,
    required this.anchors,
    required this.onHide,
    this.renderRect,
    this.layerLink,
    required this.animationConfig,
  });

  final CodeLineEditingController controller;
  final TextSelectionToolbarAnchors anchors;
  final Rect? renderRect;
  final LayerLink? layerLink;
  final VoidCallback onHide;
  final SelectionToolbarAnimationConfig animationConfig;

  @override
  State<_AnimatedCodeLineSelectionToolbar> createState() => _AnimatedCodeLineSelectionToolbarState();
}

class _AnimatedCodeLineSelectionToolbarState extends State<_AnimatedCodeLineSelectionToolbar> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: widget.animationConfig.duration,
      vsync: this,
    );

    _fadeAnimation = widget.animationConfig.enableFade
        ? Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: widget.animationConfig.curve,
          ))
        : const AlwaysStoppedAnimation(1.0);

    _scaleAnimation = widget.animationConfig.enableScale
        ? Tween<double>(
            begin: widget.animationConfig.scaleBegin,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: _animationController,
            curve: widget.animationConfig.curve,
          ))
        : const AlwaysStoppedAnimation(1.0);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _hideWithAnimation() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await _animationController.reverse();
    widget.onHide();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        Widget toolbarWidget = _CodeLineSelectionToolbar(
          controller: widget.controller,
          anchors: widget.anchors,
          renderRect: widget.renderRect,
          layerLink: widget.layerLink,
          onHide: _hideWithAnimation,
        );

        if (widget.animationConfig.enableScale) {
          toolbarWidget = ScaleTransition(
            scale: _scaleAnimation,
            child: toolbarWidget,
          );
        }

        if (widget.animationConfig.enableFade) {
          toolbarWidget = FadeTransition(
            opacity: _fadeAnimation,
            child: toolbarWidget,
          );
        }

        return toolbarWidget;
      },
    );
  }
}

class _CodeLineSelectionToolbar extends StatefulWidget {
  const _CodeLineSelectionToolbar({
    required this.controller,
    required this.anchors,
    required this.onHide,
    this.renderRect,
    this.layerLink,
  });

  final CodeLineEditingController controller;
  final TextSelectionToolbarAnchors anchors;
  final Rect? renderRect;
  final LayerLink? layerLink;
  final VoidCallback onHide;

  @override
  State<_CodeLineSelectionToolbar> createState() => _CodeLineSelectionToolbarState();
}

class _CodeLineSelectionToolbarState extends State<_CodeLineSelectionToolbar> {
  late final List<ContextMenuButtonItem> _buttonItems;

  @override
  void initState() {
    super.initState();
    _buttonItems = _generateButtonItems();
  }

  List<ContextMenuButtonItem> _generateButtonItems() {
    final List<ContextMenuButtonItem> items = [];
    final bool hasSelection = !widget.controller.selection.isCollapsed;

    if (hasSelection) {
      items.add(ContextMenuButtonItem(
        onPressed: () async {
          try {
            // cut() internally calls copy() which is async, but cut() returns void
            // We need to add a small delay to ensure copy completes before delete
            widget.controller.cut();
            await Future.delayed(const Duration(milliseconds: 100));
          } catch (e) {
            dprint('Cut operation failed: $e');
          }
          widget.onHide();
        },
        type: ContextMenuButtonType.cut,
      ));
    }

    items.add(ContextMenuButtonItem(
      onPressed: () async {
        try {
          await widget.controller.copy();
        } catch (e) {
          dprint('Copy operation failed: $e');
        }
        widget.onHide();
      },
      type: ContextMenuButtonType.copy,
    ));

    items.add(ContextMenuButtonItem(
      onPressed: () async {
        try {
          // paste() is internally async but returns void
          // Add a small delay to ensure paste operation completes
          widget.controller.paste();
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (e) {
          dprint('Paste operation failed: $e');
        }
        widget.onHide();
      },
      type: ContextMenuButtonType.paste,
    ));

    if (!widget.controller.isAllSelected) {
      items.add(ContextMenuButtonItem(
        onPressed: () {
          try {
            widget.controller.selectAll();
          } catch (e) {
            dprint('Select all operation failed: $e');
          }
          widget.onHide();
        },
        type: ContextMenuButtonType.selectAll,
      ));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.layerLink != null) {
      return CompositedTransformFollower(
        link: widget.layerLink!,
        showWhenUnlinked: false,
        child: _buildToolbar(context),
      );
    }

    return _buildToolbar(context);
  }

  Widget _buildToolbar(BuildContext context) {
    return AdaptiveTextSelectionToolbar.buttonItems(
      anchors: widget.anchors,
      buttonItems: _buttonItems,
    );
  }
}

class SelectionToolbarAnimationConfig {
  const SelectionToolbarAnimationConfig({
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
    this.enableFade = true,
    this.enableScale = true,
    this.scaleBegin = 0.8,
    this.slideOffset = const Offset(0.0, 0.2),
    this.rotationAngle = 0.0,
  });

  final Duration duration;
  final Curve curve;
  final bool enableFade;
  final bool enableScale;
  final double scaleBegin;
  final Offset slideOffset;
  final double rotationAngle;

  static const SelectionToolbarAnimationConfig material = SelectionToolbarAnimationConfig(
    duration: Duration(milliseconds: 200),
    curve: Curves.easeOutCubic,
    enableFade: true,
    enableScale: true,
    scaleBegin: 0.8,
    slideOffset: Offset(0.0, 0.2),
  );

  SelectionToolbarAnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
    bool? enableFade,
    bool? enableScale,
    bool? enableSlide,
    bool? enableRotation,
    double? scaleBegin,
    Offset? slideOffset,
    double? rotationAngle,
  }) {
    return SelectionToolbarAnimationConfig(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
      enableFade: enableFade ?? this.enableFade,
      enableScale: enableScale ?? this.enableScale,
      scaleBegin: scaleBegin ?? this.scaleBegin,
      slideOffset: slideOffset ?? this.slideOffset,
      rotationAngle: rotationAngle ?? this.rotationAngle,
    );
  }
}
