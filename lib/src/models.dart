/// Data models used by the staggered_menu_flutter package.
library;

import 'package:flutter/widgets.dart';

/// Controls which edge of the screen the menu slides in from.
enum MenuPosition {
  /// Menu slides in from the left side.
  left,

  /// Menu slides in from the right side.
  right,
}

/// A single navigational item displayed in the staggered menu panel.
///
/// ```dart
/// StaggeredMenuItem(
///   label: 'About',
///   semanticsLabel: 'Go to the About page',
///   onTap: () => Navigator.pushNamed(context, '/about'),
/// )
/// ```
class StaggeredMenuItem {
  /// The visible text label rendered in the panel.
  final String label;

  /// Optional override for screen-reader announcement.
  /// Defaults to [label] when `null`.
  final String? semanticsLabel;

  /// Called when the user taps this item.
  /// The menu closes automatically after the callback fires.
  final VoidCallback? onTap;

  /// Creates a [StaggeredMenuItem].
  const StaggeredMenuItem({
    required this.label,
    this.semanticsLabel,
    this.onTap,
  });
}

/// A social / external-link item displayed in the footer of the menu panel.
///
/// ```dart
/// StaggeredSocialItem(
///   label: 'GitHub',
///   onTap: () => launchUrl(Uri.parse('https://github.com')),
/// )
/// ```
class StaggeredSocialItem {
  /// The visible text label rendered in the socials row.
  final String label;

  /// Optional override for screen-reader announcement.
  /// Defaults to [label] when `null`.
  final String? semanticsLabel;

  /// Called when the user taps this link.
  final VoidCallback? onTap;

  /// Creates a [StaggeredSocialItem].
  const StaggeredSocialItem({
    required this.label,
    this.semanticsLabel,
    this.onTap,
  });
}
