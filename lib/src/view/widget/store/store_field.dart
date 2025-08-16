import 'dart:async';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';

/// A text field widget that integrates with a [StorePropDefault].
///
/// Supports `String`, `int`, and `double` properties. The widget shows the
/// current value from the store and persists edits on submit, with optional
/// async validation and callback hooks.
class StoreField<T extends Object> extends StatefulWidget {
  /// The property this field edits. Must be `String`, `int`, or `double`.
  final StorePropDefault<T> prop;

  /// Exec before persisting the value (after validator).
  final FutureOr<void> Function(T)? callback;

  /// Return `false` to prevent updating the value.
  final FutureOr<bool> Function(T)? validator;

  /// Optional label for the input.
  final String? label;

  /// Optional hint for the input.
  final String? hint;

  /// Max input length (e.g., for String fields).
  final int? maxLength;

  /// Number of lines for String fields. Defaults to 1.
  final int maxLines;

  /// If true, renders the bare input without Card/extra padding.
  final bool noWrap;

  const StoreField({
    super.key,
    required this.prop,
    this.callback,
    this.validator,
    this.label,
    this.hint,
    this.maxLength,
    this.maxLines = 1,
    this.noWrap = false,
  });

  @override
  State<StoreField<T>> createState() => _StoreFieldState<T>();
}

class _StoreFieldState<T extends Object> extends State<StoreField<T>> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool isBusy = false;
  bool wasRecentlyBusy = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValBuilder(
      listenable: widget.prop.listenable(),
      builder: (value) {
        // Keep controller in sync when not focused to avoid cursor jumps
        final strVal = _stringify(value);
        if (!_focusNode.hasFocus && _controller.text != strVal) {
          _controller.text = strVal;
        }

        final field = Input(
          controller: _controller,
          label: widget.label,
          hint: widget.hint,
          maxLength: widget.maxLength,
          maxLines: _keyboardMaxLines,
          type: _keyboardType,
          action: TextInputAction.done,
          node: _focusNode,
          noWrap: widget.noWrap,
          onSubmitted: (text) => _handleSubmit(text),
          // Show a small spinner while saving
          suffix: isBusy ? SizedLoading.small : null,
        );

        if (wasRecentlyBusy) {
          wasRecentlyBusy = false;
          return FadeIn(child: field);
        }

        return field;
      },
    );
  }

  TextInputType get _keyboardType {
    if (T == int) return TextInputType.number;
    if (T == double) return const TextInputType.numberWithOptions(decimal: true, signed: true);
    return TextInputType.text;
  }

  int get _keyboardMaxLines => T == String ? widget.maxLines : 1;

  String _stringify(T value) => switch (value) {
        final String v => v,
        final int v => v.toString(),
        final double v => v.toString(),
        _ => value.toString(),
      };

  Future<void> _handleSubmit(String raw) async {
    if (isBusy) return;

    final parsed = _parse(raw);
    if (parsed == null) {
      // Invalid number for int/double; do not update.
      return;
    }

    setStateSafe(() => isBusy = true);

    final valid = await widget.validator?.call(parsed) ?? true;
    if (!valid) {
      setStateSafe(() => isBusy = false);
      return;
    }

    try {
      await widget.callback?.call(parsed);
      await widget.prop.set(parsed);
    } finally {
      setStateSafe(() {
        isBusy = false;
        wasRecentlyBusy = true;
      });
    }
  }

  T? _parse(String text) {
    final trimmed = text.trim();
    if (T == String) return trimmed as T;

    if (T == int) {
      final v = int.tryParse(trimmed);
      return v == null ? null : v as T;
    }
    if (T == double) {
      final v = double.tryParse(trimmed);
      return v == null ? null : v as T;
    }

    // Unsupported type at runtime; do not update
    return null;
  }
}

extension StoreStringWidget on StorePropDefault<String> {
  /// Creates a [StoreField] bound to this String property.
  StoreField<String> fieldWidget({
    FutureOr<void> Function(String)? callback,
    FutureOr<bool> Function(String)? validator,
    String? label,
    String? hint,
    int? maxLength,
    int maxLines = 1,
    bool noWrap = false,
  }) =>
      StoreField<String>(
        prop: this,
        callback: callback,
        validator: validator,
        label: label,
        hint: hint,
        maxLength: maxLength,
        maxLines: maxLines,
        noWrap: noWrap,
      );
}

extension StoreIntWidget on StorePropDefault<int> {
  /// Creates a [StoreField] bound to this int property.
  StoreField<int> fieldWidget({
    FutureOr<void> Function(int)? callback,
    FutureOr<bool> Function(int)? validator,
    String? label,
    String? hint,
    int? maxLength,
    bool noWrap = false,
  }) =>
      StoreField<int>(
        prop: this,
        callback: callback,
        validator: validator,
        label: label,
        hint: hint,
        maxLength: maxLength,
        noWrap: noWrap,
      );
}

extension StoreDoubleWidget on StorePropDefault<double> {
  /// Creates a [StoreField] bound to this double property.
  StoreField<double> fieldWidget({
    FutureOr<void> Function(double)? callback,
    FutureOr<bool> Function(double)? validator,
    String? label,
    String? hint,
    int? maxLength,
    bool noWrap = false,
  }) =>
      StoreField<double>(
        prop: this,
        callback: callback,
        validator: validator,
        label: label,
        hint: hint,
        maxLength: maxLength,
        noWrap: noWrap,
      );
}
