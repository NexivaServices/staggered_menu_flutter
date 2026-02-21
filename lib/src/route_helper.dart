/// Helpers for integrating `StaggeredMenu` with Flutter's named-route
/// navigation system.
library;

import 'package:flutter/widgets.dart';

import 'models.dart';

/// Creates a list of [StaggeredMenuItem]s from a `Map<String, String>` of
/// `{ routeName: label }` pairs, automatically wiring each item's `onTap`
/// to `Navigator.pushNamed`.
///
/// ```dart
/// StaggeredMenu(
///   items: StaggeredRouteHelper.fromRoutes(
///     context,
///     routes: {
///       '/':        'Home',
///       '/about':   'About',
///       '/contact': 'Contact',
///     },
///   ),
///   child: myScaffold,
/// )
/// ```
///
/// **Optional parameters:**
///
/// * `currentRoute` — the active route name. If provided, the item matching
///   it will have a `null` `onTap` (disabled), acting as a visual indicator.
/// * `pushReplacement` — if `true`, uses `pushReplacementNamed` instead of
///   `pushNamed`. Defaults to `false`.
/// * `arguments` — optional route arguments passed to every push call.
class StaggeredRouteHelper {
  StaggeredRouteHelper._();

  /// Builds a `List<StaggeredMenuItem>` from a route map.
  static List<StaggeredMenuItem> fromRoutes(
    BuildContext context, {
    required Map<String, String> routes,
    String? currentRoute,
    bool pushReplacement = false,
    Object? arguments,
  }) {
    return routes.entries.map((entry) {
      final routeName = entry.key;
      final label = entry.value;
      final isActive = routeName == currentRoute;

      return StaggeredMenuItem(
        label: label,
        semanticsLabel: isActive ? '$label (current page)' : label,
        onTap: isActive
            ? null
            : () {
                if (pushReplacement) {
                  Navigator.of(context).pushReplacementNamed(
                    routeName,
                    arguments: arguments,
                  );
                } else {
                  Navigator.of(context).pushNamed(
                    routeName,
                    arguments: arguments,
                  );
                }
              },
      );
    }).toList();
  }

  /// Convenience: builds items that call `Navigator.pushReplacementNamed`.
  static List<StaggeredMenuItem> fromRoutesReplacement(
    BuildContext context, {
    required Map<String, String> routes,
    String? currentRoute,
    Object? arguments,
  }) {
    return fromRoutes(
      context,
      routes: routes,
      currentRoute: currentRoute,
      pushReplacement: true,
      arguments: arguments,
    );
  }
}
