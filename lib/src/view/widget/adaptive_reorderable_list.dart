import 'dart:math' as math;

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';

/// Signature for building each item in [AdaptiveReorderableList].
typedef AdaptiveReorderableItemBuilder<T> =
    Widget Function(
      BuildContext context,
      T item,
      int index,
      Animation<double> animation,
    );

/// Signature fired when the list has finished reordering items.
typedef AdaptiveReorderCompletion<T> = void Function(List<T> items);

/// A responsive multi-column reorderable list with animated insertions & removals.
///
/// The widget determines how many columns to display based on the available width.
/// Items can be long-pressed to drag into a new position and will animate when
/// inserted or removed from the provided [items] collection.
///
/// ## Example
/// ```dart
/// class ReorderableTags extends StatefulWidget {
///   const ReorderableTags({super.key});
///
///   @override
///   State<ReorderableTags> createState() => _ReorderableTagsState();
/// }
///
/// class _ReorderableTagsState extends State<ReorderableTags> {
///   var _tags = <String>['Design', 'Review', 'QA'];
///
///   @override
///   Widget build(BuildContext context) {
///     return AdaptiveReorderableList.builder<String>(
///       items: _tags,
///       itemKey: (tag) => tag,
///       itemBuilder: (context, tag, index, animation) {
///         return SizeTransition(
///           sizeFactor: animation,
///           child: Card(
///             child: ListTile(
///               leading: const Icon(Icons.drag_handle),
///               title: Text(tag),
///             ),
///           ),
///         );
///       },
///       onReorderComplete: (updated) {
///         setState(() => _tags = updated);
///       },
///     );
///   }
/// }
/// ```
class AdaptiveReorderableList<T> extends StatefulWidget {
  /// Creates a builder-based adaptive reorderable list.
  const AdaptiveReorderableList.builder({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.itemKey,
    this.onReorder,
    this.onReorderComplete,
    this.padding = EdgeInsets.zero,
    this.columnWidth = UIs.columnWidth,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.maxColumns = 6,
    this.animationDuration = const Duration(milliseconds: 220),
    this.insertCurve = Curves.easeOutCubic,
    this.removeCurve = Curves.easeInCubic,
    this.scrollController,
    this.physics,
    this.primary,
    this.clipBehavior = Clip.hardEdge,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.reverse = false,
  }) : separatorBuilder = null,
       separated = false;

  /// Creates a separated adaptive reorderable list where a separator widget is
  /// automatically inserted between children.
  const AdaptiveReorderableList.separated({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.itemKey,
    required this.separatorBuilder,
    this.onReorder,
    this.onReorderComplete,
    this.padding = EdgeInsets.zero,
    this.columnWidth = UIs.columnWidth,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.maxColumns = 6,
    this.animationDuration = const Duration(milliseconds: 220),
    this.insertCurve = Curves.easeOutCubic,
    this.removeCurve = Curves.easeInCubic,
    this.scrollController,
    this.physics,
    this.primary,
    this.clipBehavior = Clip.hardEdge,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.reverse = false,
  }) : separated = true;

  /// Data backing each item that will be rendered.
  final List<T> items;

  /// Builds the widget at the given [index].
  final AdaptiveReorderableItemBuilder<T> itemBuilder;

  /// Optional separator factory when using [AdaptiveReorderableList.separated].
  final IndexedWidgetBuilder? separatorBuilder;

  /// Extracts a stable key for the provided [item].
  final Object Function(T item) itemKey;

  /// Called when an item is dropped into a new position.
  ///
  /// The callback receives indices relative to the currently visible (non-removed)
  /// items so it can update the backing list accordingly.
  final ReorderCallback? onReorder;

  /// Called after a reorder completes with the latest ordered items.
  ///
  /// The callback receives a snapshot of [items] in their new order after drag
  /// operations have been applied.
  final AdaptiveReorderCompletion<T>? onReorderComplete;

  /// Padding applied to the entire list.
  final EdgeInsetsGeometry padding;

  /// Target width for each column before spacing.
  final double columnWidth;

  /// Space between columns in the grid layout.
  final double crossAxisSpacing;

  /// Space between rows in the grid layout.
  final double mainAxisSpacing;

  /// Upper bound on automatically calculated columns.
  final int maxColumns;

  /// Duration for insert/remove animations.
  final Duration animationDuration;

  /// Curve applied when animating newly inserted items.
  final Curve insertCurve;

  /// Curve applied when animating removed items.
  final Curve removeCurve;

  /// Optional scroll controller.
  final ScrollController? scrollController;

  /// Scroll physics for the list view.
  final ScrollPhysics? physics;

  /// Whether this is the primary scroll view.
  final bool? primary;

  /// Clip behavior for the underlying scrollable.
  final Clip clipBehavior;

  /// Keyboard dismiss behavior for the scrollable.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Restoration id for state restoration.
  final String? restorationId;

  /// Whether the list scrolls in reverse.
  final bool reverse;

  final bool separated;

  @override
  State<AdaptiveReorderableList<T>> createState() =>
      _AdaptiveReorderableListState<T>();
}

class _AdaptiveReorderableListState<T> extends State<AdaptiveReorderableList<T>>
    with TickerProviderStateMixin {
  final List<_AdaptiveEntry<T>> _entries = [];
  final Map<Object, _AdaptiveEntry<T>> _entryByKey = {};
  Object? _hoveringKey;

  static final Object _trailingDropMarker = Object();

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.items.length; i++) {
      _insertEntry(i, widget.items[i], animateIn: false);
    }
  }

  @override
  void didUpdateWidget(covariant AdaptiveReorderableList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.items, oldWidget.items)) {
      _syncEntries();
    } else {
      // Still resync on potential list mutations without identity change.
      _syncEntries();
    }
  }

  void _syncEntries() {
    final desired = widget.items;

    final seenKeys = <Object>{};
    for (final entry in _entries) {
      entry.markedForRemoval = true;
    }

    var insertIndex = 0;
    for (final item in desired) {
      final key = widget.itemKey(item);
      assert(
        !seenKeys.contains(key),
        'AdaptiveReorderableList received duplicate keys: $key',
      );
      seenKeys.add(key);
      final existing = _entryByKey[key];
      if (existing != null) {
        existing.item = item;
        existing.markedForRemoval = false;
        existing.removed = false;
        final status = existing.controller.status;
        if (status == AnimationStatus.dismissed ||
            status == AnimationStatus.reverse) {
          existing.controller.forward();
        }
        if (_entries[insertIndex] != existing) {
          _entries.remove(existing);
          _entries.insert(insertIndex, existing);
        }
      } else {
        _insertEntry(insertIndex, item, animateIn: true);
      }
      insertIndex++;
    }

    for (final entry in _entries.toList()) {
      if (entry.markedForRemoval && !entry.removed) {
        entry.removed = true;
        entry.controller.reverse();
      }
    }
  }

  void _insertEntry(int index, T item, {required bool animateIn}) {
    final entry = _createEntry(item, animateIn: animateIn);
    assert(
      !_entryByKey.containsKey(entry.key),
      'AdaptiveReorderableList requires items to produce unique keys. Duplicate: ${entry.key}',
    );
    entry.markedForRemoval = false;
    entry.removed = false;
    _entries.insert(index, entry);
    _entryByKey[entry.key] = entry;
    if (animateIn) {
      entry.controller.forward();
    }
  }

  _AdaptiveEntry<T> _createEntry(T item, {required bool animateIn}) {
    final key = widget.itemKey(item);
    final controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    if (!animateIn) {
      controller.value = 1;
    }

    final animation = CurvedAnimation(
      parent: controller,
      curve: widget.insertCurve,
      reverseCurve: widget.removeCurve,
    );

    late final _AdaptiveEntry<T> entry;
    entry = _AdaptiveEntry<T>(
      key: key,
      item: item,
      controller: controller,
      animation: animation,
      onRemoveCompleted: () {
        if (!mounted) return;
        setState(() {
          _entries.remove(entry);
          _entryByKey.remove(entry.key);
        });
        controller.dispose();
      },
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed && entry.removed) {
        entry.onRemoveCompleted();
      }
    });

    return entry;
  }

  @override
  void dispose() {
    for (final entry in _entries) {
      entry.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedPadding = widget.padding.resolve(
          Directionality.of(context),
        );
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        final availableWidth = math.max(
          0.0,
          maxWidth - resolvedPadding.horizontal,
        );
        final columnCount = _calculateColumnCount(availableWidth);
        final tileWidth = _computeTileWidth(availableWidth, columnCount);

        final visibleEntries = _entries.toList(growable: false);
        final visibleCount = _visibleItemCount;

        final tiles = <Widget>[
          for (final entry in visibleEntries)
            _buildTile(
              entry: entry,
              width: tileWidth,
              visibleIndex: _visibleIndexFor(entry),
              visibleCount: visibleCount,
            ),
          _buildTrailingDropZone(tileWidth),
        ];

        return SingleChildScrollView(
          controller: widget.scrollController,
          physics: widget.physics,
          primary: widget.primary,
          padding: widget.padding,
          reverse: widget.reverse,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          restorationId: widget.restorationId,
          clipBehavior: widget.clipBehavior,
          child: Align(
            alignment: Alignment.topLeft,
            child: Wrap(
              spacing: widget.crossAxisSpacing,
              runSpacing: widget.mainAxisSpacing,
              children: tiles,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTile({
    required _AdaptiveEntry<T> entry,
    required double width,
    required int visibleIndex,
    required int visibleCount,
  }) {
    final child = _buildAnimatedChild(entry, visibleIndex, visibleCount);

    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) {
        final data = details.data;
        if (data == entry.key) {
          return false;
        }
        _setHovering(entry.key);
        return true;
      },
      onLeave: (_) => _clearHovering(entry.key),
      onAcceptWithDetails: (details) {
        _clearHovering(entry.key);
        _handleDrop(details.data, entry.key);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering =
            candidateData.isNotEmpty || _hoveringKey == entry.key;
        final scale = isHovering ? 1.02 : 1.0;

        final displayChild = IgnorePointer(
          ignoring: entry.removed,
          child: child,
        );

        return AnimatedScale(
          duration: const Duration(milliseconds: 120),
          scale: scale,
          child: SizedBox(
            width: width,
            child: LongPressDraggable<Object>(
              data: entry.key,
              dragAnchorStrategy: pointerDragAnchorStrategy,
              feedback: _buildDragFeedback(displayChild, width),
              childWhenDragging: Opacity(opacity: 0.2, child: displayChild),
              child: displayChild,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrailingDropZone(double width) {
    return DragTarget<Object>(
      onWillAcceptWithDetails: (details) {
        _setHovering(_trailingDropMarker);
        return true;
      },
      onLeave: (_) => _clearHovering(_trailingDropMarker),
      onAcceptWithDetails: (details) {
        _clearHovering(_trailingDropMarker);
        _handleDrop(details.data, null);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering =
            candidateData.isNotEmpty || _hoveringKey == _trailingDropMarker;
        final colorScheme = Theme.of(context).colorScheme;
        final baseOnSurface = colorScheme.onSurface;
        final targetAlpha = ((baseOnSurface.a * 255.0) * 0.3)
            .round()
            .clamp(0, 255)
            .toInt();
        final fadedOnSurface = baseOnSurface.withAlpha(targetAlpha);

        return SizedBox(
          width: width,
          height: math.max(24, widget.mainAxisSpacing * 1.2),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isHovering ? colorScheme.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.add,
                size: 16,
                color: isHovering ? colorScheme.primary : fadedOnSurface,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedChild(
    _AdaptiveEntry<T> entry,
    int visibleIndex,
    int visibleCount,
  ) {
    final baseChild = widget.itemBuilder(
      context,
      entry.item,
      visibleIndex,
      entry.animation,
    );
    final child = widget.separated && visibleIndex < visibleCount - 1
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              baseChild,
              widget.separatorBuilder!(context, visibleIndex),
            ],
          )
        : baseChild;

    return _AnimatedEntry(
      key: ValueKey(entry.key),
      animation: entry.animation,
      child: child,
    );
  }

  Widget _buildDragFeedback(Widget child, double width) {
    return Material(
      color: Colors.transparent,
      elevation: 6,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: width),
        child: child,
      ),
    );
  }

  void _handleDrop(Object data, Object? targetKey) {
    final dragged = _entryByKey[data];
    if (dragged == null) {
      return;
    }
    if (targetKey != null && targetKey == dragged.key) {
      return;
    }

    final oldIndex = _entries.indexOf(dragged);
    if (oldIndex == -1) {
      return;
    }

    final oldVisibleIndex = _visibleIndexFor(dragged);

    setState(() {
      _hoveringKey = null;

      var insertIndex = targetKey == null
          ? _entries.length
          : _entries.indexWhere((element) => element.key == targetKey);
      if (insertIndex == -1) {
        insertIndex = _entries.length;
      }

      final entry = _entries.removeAt(oldIndex);
      if (targetKey != null && oldIndex < insertIndex) {
        insertIndex -= 1;
      }
      insertIndex = insertIndex.clamp(0, _entries.length);
      _entries.insert(insertIndex, entry);
    });

    final newVisibleIndex = _visibleIndexFor(dragged);
    final filtered = _entries
        .where((e) => !e.removed)
        .map((e) => e.item)
        .toList(growable: false);
    widget.onReorder?.call(oldVisibleIndex, newVisibleIndex);
    widget.onReorderComplete?.call(filtered);
  }

  void _setHovering(Object key) {
    if (_hoveringKey == key) {
      return;
    }
    setState(() {
      _hoveringKey = key;
    });
  }

  void _clearHovering(Object key) {
    if (_hoveringKey != key) {
      return;
    }
    setState(() {
      _hoveringKey = null;
    });
  }

  int get _visibleItemCount => _entries.where((e) => !e.removed).length;

  int _visibleIndexFor(_AdaptiveEntry<T> entry) {
    var index = 0;
    for (final candidate in _entries) {
      if (candidate == entry) {
        return index;
      }
      if (!candidate.removed) {
        index++;
      }
    }
    return index;
  }

  int _calculateColumnCount(double availableWidth) {
    if (availableWidth <= 0) {
      return 1;
    }
    final desiredWidth = widget.columnWidth + widget.crossAxisSpacing;
    final computed = ((availableWidth + widget.crossAxisSpacing) / desiredWidth)
        .floor();
    return computed.clamp(1, widget.maxColumns);
  }

  double _computeTileWidth(double availableWidth, int columnCount) {
    if (columnCount <= 1 || availableWidth <= 0) {
      return availableWidth;
    }
    final totalSpacing = widget.crossAxisSpacing * (columnCount - 1);
    final width = (availableWidth - totalSpacing) / columnCount;
    return width.isFinite && width > 0 ? width : widget.columnWidth;
  }
}

class _AdaptiveEntry<T> {
  _AdaptiveEntry({
    required this.key,
    required this.item,
    required this.controller,
    required this.animation,
    required this.onRemoveCompleted,
  });

  final Object key;
  T item;
  final AnimationController controller;
  final Animation<double> animation;
  final VoidCallback onRemoveCompleted;

  bool removed = false;
  bool markedForRemoval = false;
}

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({
    super.key,
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scaleTween = Tween<double>(begin: 0.92, end: 1.0);
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(scale: animation.drive(scaleTween), child: child),
    );
  }
}
