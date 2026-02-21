/// A controller for programmatically opening, closing, and toggling a
/// `StaggeredMenu`.
library;

import 'package:flutter/foundation.dart';

/// The action requested by a [StaggeredMenuController].
///
/// Used internally to communicate the desired action to the widget state.
enum MenuAction {
  /// Open the menu.
  open,

  /// Close the menu.
  close,

  /// Toggle the menu.
  toggle,
}

/// Allows external code to programmatically open, close, or toggle a
/// `StaggeredMenu` without requiring a user tap on the toggle button.
///
/// ```dart
/// final controller = StaggeredMenuController();
///
/// // Later:
/// controller.open();
/// controller.close();
/// controller.toggle();
///
/// // Dispose when done:
/// controller.dispose();
/// ```
///
/// Pass the controller to `StaggeredMenu.controller`. The widget will
/// attach itself on mount and detach on unmount automatically.
class StaggeredMenuController extends ChangeNotifier {
  MenuAction? _pendingAction;
  bool _isOpen = false;

  /// Whether the menu is currently open.
  bool get isOpen => _isOpen;

  /// The last requested action, consumed by the widget state.
  MenuAction? get pendingAction => _pendingAction;

  /// Opens the menu. No-op if already open.
  void open() {
    _pendingAction = MenuAction.open;
    notifyListeners();
  }

  /// Closes the menu. No-op if already closed.
  void close() {
    _pendingAction = MenuAction.close;
    notifyListeners();
  }

  /// Toggles the menu: opens if closed, closes if open.
  void toggle() {
    _pendingAction = MenuAction.toggle;
    notifyListeners();
  }

  /// Called by the widget state to report the current open/close status.
  // ignore: use_setters_to_change_properties
  void updateIsOpen(bool value) {
    _isOpen = value;
  }

  /// Marks the pending action as consumed.
  void consumeAction() {
    _pendingAction = null;
  }
}
