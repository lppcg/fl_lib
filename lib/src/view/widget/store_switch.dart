import 'dart:async';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';

/// {@template StoreSwitch}
/// A switch widget that integrates with a [StorePropDefault].
///
/// It allows for asynchronous validation and callback execution before changing the switch state.
///
/// If the validation fails, the switch will not change its state.
///
/// The switch will show a loading indicator while the change is being processed.
/// {@endtemplate}
class StoreSwitch extends StatefulWidget {
  /// The property that this switch controls.
  final StorePropDefault<bool> prop;

  /// Exec before make change, after validator.
  final FutureOr<void> Function(bool)? callback;

  /// If return false, the switch will not change.
  final FutureOr<bool> Function(bool)? validator;

  /// {@macro StoreSwitch}
  const StoreSwitch({super.key, required this.prop, this.callback, this.validator});

  @override
  State<StoreSwitch> createState() => _StoreSwitchState();
}

class _StoreSwitchState extends State<StoreSwitch> {
  bool isBusy = false;
  bool wasRecentlyBusy = false;

  @override
  Widget build(BuildContext context) {
    return ValBuilder(
      listenable: widget.prop.listenable(),
      builder: (value) {
        if (isBusy) return SizedLoading.medium.paddingOnly(right: 17);

        final switcher = Switch(value: value, onChanged: _handleChange);

        // Apply fade-in animation when transitioning from busy to ready state
        if (wasRecentlyBusy) {
          wasRecentlyBusy = false;
          return FadeIn(child: switcher);
        }

        return switcher;
      },
    );
  }

  Future<void> _handleChange(bool newValue) async {
    if (isBusy) return;
    setStateSafe(() {
      isBusy = true;
    });

    final valid = await widget.validator?.call(newValue) ?? true;
    if (!valid) {
      setStateSafe(() {
        isBusy = false;
        // wasRecentlyBusy is not set to true, so no fade-in for invalid attempts.
      });
      return;
    }

    try {
      await widget.callback?.call(newValue);
      await widget.prop.set(newValue);
    } finally {
      setStateSafe(() {
        isBusy = false;
        wasRecentlyBusy = true;
      });
    }
  }
}
