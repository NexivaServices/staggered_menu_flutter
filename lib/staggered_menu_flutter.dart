/// A staggered sliding navigation menu for Flutter.
///
/// Import this single file to access everything:
/// ```dart
/// import 'package:staggered_menu_flutter/staggered_menu_flutter.dart';
/// ```
///
/// ## Quick-start
/// ```dart
/// StaggeredMenu(
///   items: [
///     StaggeredMenuItem(label: 'Home',    onTap: () {}),
///     StaggeredMenuItem(label: 'About',   onTap: () {}),
///     StaggeredMenuItem(label: 'Contact', onTap: () {}),
///   ],
///   child: Scaffold(body: Center(child: Text('Hello'))),
/// )
/// ```
library staggered_menu_flutter;

export 'src/models.dart';
export 'src/staggered_menu.dart';
export 'src/theme.dart';
