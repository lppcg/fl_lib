import 'package:fl_lib/src/res/ui.dart';
import 'package:flutter/material.dart';

class PopupMenu<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> items;
  final void Function(T) onSelected;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final T? initialValue;
  final String? tooltip;
  final BorderRadius? borderRadius;

  const PopupMenu({
    super.key,
    required this.items,
    required this.onSelected,
    this.child = UIs.popMenuChild,
    this.padding = const EdgeInsets.all(7),
    this.initialValue,
    this.tooltip,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      itemBuilder: (_) => items,
      onSelected: onSelected,
      initialValue: initialValue,
      padding: padding,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tooltip: tooltip,
      borderRadius: borderRadius,
      child: child,
    );
  }
}
