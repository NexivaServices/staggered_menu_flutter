/// An [InheritedWidget] that propagates [StaggeredMenuThemeData] down the
/// widget tree.
library;

import 'package:flutter/material.dart';

import 'theme.dart';

/// Provides a [StaggeredMenuThemeData] to descendant widgets.
///
/// Wrap a subtree with [StaggeredMenuTheme] to define default theme data that
/// any `StaggeredMenu` below can pick up automatically:
///
/// ```dart
/// StaggeredMenuTheme(
///   data: StaggeredMenuThemeData(accentColor: Colors.blue),
///   child: MaterialApp(home: MyPage()),
/// )
/// ```
///
/// A `StaggeredMenu` resolves its effective theme in the following order:
/// 1. The explicit `theme` parameter (when non-null).
/// 2. The nearest [StaggeredMenuTheme] ancestor.
/// 3. `const StaggeredMenuThemeData()` (built-in defaults).
class StaggeredMenuTheme extends InheritedWidget {
  /// The theme data to propagate.
  final StaggeredMenuThemeData data;

  /// Creates a [StaggeredMenuTheme].
  const StaggeredMenuTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Returns the nearest [StaggeredMenuThemeData] up the tree, or `null` if
  /// none is found.
  static StaggeredMenuThemeData? maybeOf(BuildContext context) {
    final widget =
        context.dependOnInheritedWidgetOfExactType<StaggeredMenuTheme>();
    return widget?.data;
  }

  /// Returns the nearest [StaggeredMenuThemeData] up the tree, or the
  /// built-in defaults when no ancestor exists.
  static StaggeredMenuThemeData of(BuildContext context) {
    return maybeOf(context) ?? const StaggeredMenuThemeData();
  }

  @override
  bool updateShouldNotify(StaggeredMenuTheme oldWidget) =>
      data != oldWidget.data;
}
