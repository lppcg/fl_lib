import 'package:fl_lib/generated/l10n/lib_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

extension ContextX on BuildContext {
  /// Pops the current route off the navigator if possible.
  /// Returns without action if [canPop] is false.
  void pop<T extends Object?>([T? result]) {
    // final splitCtx = SplitViewNavigator.of(this);
    // final canPopSplitView = splitCtx?.canPop ?? false;
    // if (canPopSplitView) {
    //   splitCtx?.pop<T>(result);
    //   return;
    // }
    if (!canPop) return;
    Navigator.of(this).pop<T>(result);
  }

  /// Whether the navigator can pop the current route
  bool get canPop => Navigator.of(this).canPop();

  /// Current theme data from the closest Theme widget ancestor
  ThemeData get theme => Theme.of(this);

  /// Whether the current theme brightness is dark
  bool get isDark => theme.brightness == Brightness.dark;

  /// Current route settings from the closest ModalRoute ancestor
  RouteSettings? get route => ModalRoute.of(this)?.settings;

  /// Whether the current page (context's page) is the current visible route
  bool? get stillOnPage => ModalRoute.of(this)?.isCurrent;

  /// MediaQuery data from the closest MediaQuery widget ancestor
  /// Consider using [windowSize] if only the size is needed
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Current window size from MediaQuery
  /// Uses [MediaQuery.sizeOf] for better performance
  Size get windowSize => MediaQuery.sizeOf(this);

  /// Returns the [ResponsiveBreakpointsData] of the current context
  ResponsiveBreakpointsData get responsiveBreakpoints => ResponsiveBreakpoints.of(this);

  /// {@template responsive_breakpoints}
  /// Whether reached the breakpoint, useful for responsive design
  /// {@endtemplate}
  bool get isMobile => responsiveBreakpoints.isMobile || responsiveBreakpoints.isPhone;

  /// {@macro responsive_breakpoints}
  bool get isDesktop => responsiveBreakpoints.isDesktop || responsiveBreakpoints.isTablet;

  /// Whether the text direction is right-to-left
  bool get isRTL => Directionality.of(this) == TextDirection.rtl;

  /// L10n of this lib.
  ///
  /// WARN: Hard decode nullable.
  LibLocalizations get libL10n => LibLocalizations.of(this)!;
}

extension SafeContext on State {
  /// Returns the current context if it is mounted.
  BuildContext? get contextSafe {
    try {
      return context;
    } catch (e) {
      return null;
    }
  }

  /// SetState if mounted.
  void setStateSafe(VoidCallback fn) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(fn);
    }
  }
}

extension SafeRef on ConsumerState {
  /// Returns the current context if it is mounted.
  BuildContext? get contextSafe {
    try {
      return context;
    } catch (e) {
      return null;
    }
  }

  /// SetState if mounted.
  void setStateSafe(VoidCallback fn) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(fn);
    }
  }

  /// Read the provider if mounted.
  WidgetRef? get refSafe {
    if (mounted) {
      return ref;
    }
    return null;
  }
}
