## 0.0.3

- chore(example): added web platform support (`flutter create . --platforms web`).
- fix(example): added `flutter_lints ^4.0.0` dev dependency and cleaned up generated `analysis_options.yaml` — resolves `include_file_not_found` warning.

## 0.0.2

- **StaggeredMenuController** — programmatic `open()`, `close()`, and `toggle()`.
- **StaggeredMenuTheme** inherited widget — set theme data once and inherit it everywhere.
- **StaggeredRouteHelper** — `fromRoutes()` maps named routes to menu items automatically; active route gets a disabled (null) `onTap`.
- **Custom item builder** — `itemBuilder` callback replaces the default per-item rendering while keeping stagger animation, hit-testing, and semantics.
- **Keyboard navigation** — `FocusScope` traps focus when the overlay is open; pressing **Escape** closes the menu.
- Theme parameter (`StaggeredMenu.theme`) is now nullable; resolution order: explicit → inherited → defaults.
- Test suite expanded from 11 to 33 tests.
- Example app updated to demonstrate controller, inherited theme, and custom item builder.

## 0.0.1

- Initial release.
- `StaggeredMenu` widget with staggered pre-layer slide animation.
- Blurred, translucent glass panel.
- Fully themeable via `StaggeredMenuThemeData` with `copyWith` support.
- Optional item numbering, hover effects, and social links section.
- Left / right panel position support.
- Responsive panel width (full-width below configurable mobile breakpoint).
- Semantics support for accessibility.
- Animated toggle button with sliding label and rotating icon.
