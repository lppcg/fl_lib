part of 'route.dart';

enum RouteType { push, pop }

/// {@template route_listener}
/// Route listener.
///
/// - [settings] is the route settings.
/// - [type] is the route type.
/// {@endtemplate}
typedef RouteListener = void Function(
  RouteSettings? settings,
  RouteType type,
);

/// Observe the route changes.
final class AppRouteObserver extends NavigatorObserver {
  static final _routes = <RouteSettings>[];

  /// The routes list.
  static List<RouteSettings> get routes => _routes;

  /// The listeners.
  ///
  /// {@macro route_listener}
  static final listeners = <RouteListener>[];

  /// The only instance.
  static final instance = AppRouteObserver._();

  AppRouteObserver._() : super();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) {
      _routes.add(route.settings);

      for (var e in listeners) {
        e(route.settings, RouteType.push);
      }
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute) {
      _routes.remove(route.settings);

      for (var e in listeners) {
        e(route.settings, RouteType.pop);
      }
    }
  }

  /// Add a listener.
  static void addListener(RouteListener listener) {
    listeners.add(listener);
  }

  /// Remove a listener.
  static void removeListener(RouteListener listener) {
    listeners.remove(listener);
  }

  /// Get the current route.
  static RouteSettings? get currentRoute => _routes.lastOrNull;
}

/// The route observer functions.
interface class AppRouteObserverFunc {
  const AppRouteObserverFunc._();

  /// Log the route changes only in debug mode.
  static void logUrl(RouteSettings? settings, RouteType type) {
    final url = settings?.name;
    dprint('[Route] ${type.name} $url');
  }
}
