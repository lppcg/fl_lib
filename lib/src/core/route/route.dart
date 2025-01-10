import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';

part 'observer.dart';

/// Define it as a named record, makes it easier for refactor.
typedef Middleware<T extends AppRouteIface> = ({BuildContext context, T route});

/// {@template app_route_iface}
/// An app route.
/// {@endtemplate}
final class AppRouteIface {
  /// The path of the route.
  final String path;

  /// {@macro app_route_iface}
  const AppRouteIface({required this.path});

  /// Returns true if the current route is the same as this route.
  bool get isAlreadyIn => AppRouteObserver.currentRoute?.name == path;
}

/// A route with non-null arguments.
final class AppRoute<Ret, Arg extends Object> extends AppRouteIface {
  final Widget Function({Key? key, Arg? args}) page;

  /// If [middlewares] returns false, the navigation will be canceled.
  final List<bool Function(Middleware<AppRoute<Ret, Arg>>)>? middlewares;

  /// {@macro app_route_iface}
  const AppRoute({
    required this.page,
    required super.path,
    this.middlewares,
  });

  /// {@macro app_route_go}
  Future<Ret?> go(
    BuildContext context, {
    Key? key,
    Arg? args,
    PageRoute<Ret>? route,
  }) {
    final ret = middlewares?.any((e) => !e((context: context, route: this)));
    if (ret == true) return Future.value(null);

    Widget builder(BuildContext context) => VirtualWindowFrame(
          child: args != null ? page(key: key, args: args) : page(key: key),
        );

    final route_ = route ??
        MaterialPageRoute<Ret>(
          builder: builder,
          settings: RouteSettings(name: path),
        );
    return Navigator.push<Ret>(context, route_);
  }
}

/// A route with required arguments.
final class AppRouteArg<Ret, Arg extends Object> extends AppRouteIface {
  final Widget Function({Key? key, required Arg args}) page;

  /// If [middlewares] returns false, the navigation will be canceled.
  final List<bool Function(Middleware<AppRouteArg<Ret, Arg>>)>? middlewares;

  /// {@macro app_route_iface}
  const AppRouteArg({
    required this.page,
    required super.path,
    this.middlewares,
  });

  /// {@macro app_route_go}
  Future<Ret?> go(
    BuildContext context,
    Arg args, {
    Key? key,
    PageRoute<Ret>? route,
  }) {
    final ret = middlewares?.any((e) => !e((context: context, route: this)));
    if (ret == true) return Future.value(null);

    final route_ = route ??
        MaterialPageRoute<Ret>(
          builder: (_) => VirtualWindowFrame(child: page(key: key, args: args)),
          settings: RouteSettings(name: path),
        );
    return Navigator.push<Ret>(context, route_);
  }
}

/// A route without arguments.
final class AppRouteNoArg<Ret> extends AppRouteIface {
  final Widget Function({Key? key}) page;

  /// If [middlewares] returns false, the navigation will be canceled.
  final List<bool Function(Middleware<AppRouteNoArg<Ret>>)>? middlewares;

  /// {@macro app_route_iface}
  const AppRouteNoArg({
    required this.page,
    required super.path,
    this.middlewares,
  });

  /// {@macro app_route_go}
  Future<Ret?> go(
    BuildContext context, {
    Key? key,
    PageRoute<Ret>? route,
  }) {
    final ret = middlewares?.any((e) => !e((context: context, route: this)));
    if (ret == true) return Future.value(null);

    final route_ = route ??
        MaterialPageRoute<Ret>(
          builder: (_) => VirtualWindowFrame(child: page(key: key)),
          settings: RouteSettings(name: path),
        );
    return Navigator.push<Ret>(context, route_);
  }
}
