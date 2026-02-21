<div align="center">

# staggered_menu_flutter

**A premium staggered slide-in navigation menu for Flutter.**  
Animated pre-layers · Backdrop blur glass panel · Hover effects · Fully themeable.

[![pub version](https://img.shields.io/pub/v/staggered_menu_flutter.svg)](https://pub.dev/packages/staggered_menu_flutter)
[![pub points](https://img.shields.io/pub/points/staggered_menu_flutter)](https://pub.dev/packages/staggered_menu_flutter/score)
[![license: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](LICENSE)
[![GitHub](https://img.shields.io/badge/GitHub-NexivaServices-181717?logo=github)](https://github.com/NexivaServices/staggered_menu_flutter)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.22-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.3-0175C2?logo=dart)](https://dart.dev)

</div>

---

## ✨ Features

| Feature                    | Details                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------ |
| 🎞 **Staggered layers**    | Multiple coloured sheets slide in behind the glass panel, each offset in time              |
| 🌫 **Backdrop blur panel** | Frosted-glass panel with configurable blur sigma and tint opacity                          |
| 🖱 **Hover effects**       | Item and social-link hover states (colour + opacity) — perfect for web & desktop           |
| 🔢 **Item numbering**      | Optional two-digit ordinals that fade in with each menu item                               |
| 🎨 **Deep theming**        | Every colour, font, spacing, and motion curve is configurable via `StaggeredMenuThemeData` |
| 📱 **Responsive**          | Full-width panel on mobile, clamped fractional width on larger screens                     |
| ♿ **Accessible**          | Semantics labels on all interactive elements                                               |
| 🔀 **Left / right**        | Panel can slide in from either edge                                                        |
| 💬 **Socials section**     | Optional footer row with hover-dimming spotlight effect                                    |
| 🎮 **Controller**          | `StaggeredMenuController` for programmatic open / close / toggle                           |
| 🎨 **Inherited theme**     | `StaggeredMenuTheme` InheritedWidget — set once, inherit everywhere                        |
| 🛤 **Route helper**        | `StaggeredRouteHelper.fromRoutes()` maps named routes to menu items automatically          |
| 🧩 **Custom item builder** | `itemBuilder` slot for fully custom per-item rendering while keeping stagger animation     |
| ⌨️ **Keyboard nav**        | Focus trap when open — **Escape** closes the menu                                          |

---

## 🚀 Getting started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  staggered_menu_flutter: ^0.0.3
```

Then run:

```bash
flutter pub get
```

---

## 🔨 Usage

### Minimal

```dart
import 'package:staggered_menu_flutter/staggered_menu_flutter.dart';

StaggeredMenu(
  items: [
    StaggeredMenuItem(label: 'Home',    onTap: () {}),
    StaggeredMenuItem(label: 'About',   onTap: () {}),
    StaggeredMenuItem(label: 'Contact', onTap: () {}),
  ],
  child: Scaffold(
    body: Center(child: Text('My App')),
  ),
)
```

### With all options

```dart
StaggeredMenu(
  position: MenuPosition.right,   // or MenuPosition.left
  theme: StaggeredMenuThemeData(
    accentColor:      Color(0xFFFF2D55),
    preLayerColors:   [Color(0xFFFFC2D1), Color(0xFFFF2D55)],
    panelColor:       Colors.white,
    panelOpacity:     0.93,
    blurSigma:        16,
    barrierColor:     Color(0x44000000),
    showItemNumbering: true,
    enableHoverEffects: true,
    duration:         Duration(milliseconds: 800),
    panelCurve:       Curves.easeOutQuart,
  ),
  logo: Text(
    'STUDIO',
    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
  ),
  items: [
    StaggeredMenuItem(label: 'Home',     onTap: () {}),
    StaggeredMenuItem(label: 'Work',     onTap: () {}),
    StaggeredMenuItem(label: 'About',    onTap: () {}),
    StaggeredMenuItem(label: 'Contact',  onTap: () {}),
  ],
  socialItems: [
    StaggeredSocialItem(label: 'GitHub',   onTap: () {}),
    StaggeredSocialItem(label: 'Dribbble', onTap: () {}),
    StaggeredSocialItem(label: 'X',        onTap: () {}),
  ],
  onMenuOpen:  () => print('opened'),
  onMenuClose: () => print('closed'),
  child: Scaffold(
    backgroundColor: Color(0xFF0E0E12),
    body: Center(child: Text('Hello')),
  ),
)
```

---

## � Controller

Open, close, or toggle the menu from code:

```dart
final controller = StaggeredMenuController();

StaggeredMenu(
  controller: controller,
  items: [ /* … */ ],
  child: myScaffold,
);

// Later:
controller.open();
controller.close();
controller.toggle();

// Dispose when done:
controller.dispose();
```

---

## 🎨 Inherited theme

Wrap a subtree with `StaggeredMenuTheme` to avoid passing `theme:` to every menu:

```dart
StaggeredMenuTheme(
  data: StaggeredMenuThemeData(accentColor: Colors.red),
  child: MaterialApp(home: MyPage()),
)
```

Resolution order: explicit `theme` parameter → nearest `StaggeredMenuTheme` → built-in defaults.

---

## 🛤 Named routes integration

```dart
StaggeredMenu(
  items: StaggeredRouteHelper.fromRoutes(
    context,
    routes: {
      '/':        'Home',
      '/about':   'About',
      '/contact': 'Contact',
    },
    currentRoute: ModalRoute.of(context)?.settings.name,
  ),
  child: myScaffold,
)
```

The active route automatically gets a `null` onTap (disabled).

---

## 🧩 Custom item builder

Replace the default uppercase-label rendering while keeping the stagger animation:

```dart
StaggeredMenu(
  itemBuilder: (context, item, index, hovered) {
    return Text(
      item.label,
      style: TextStyle(color: hovered ? Colors.red : Colors.white),
    );
  },
  items: [ /* … */ ],
  child: myScaffold,
)
```

---

## ⌨️ Keyboard navigation

When the menu overlay is open:

- A `FocusScope` traps focus within the panel.
- Pressing **Escape** closes the menu.

No extra setup required — it works out of the box.

---

## �🎨 Theming reference

All properties have sensible defaults — override only what you need using `copyWith`:

```dart
const StaggeredMenuThemeData().copyWith(
  accentColor: Colors.deepPurple,
  blurSigma:   20,
  duration:    Duration(milliseconds: 600),
)
```

<details>
<summary><strong>Full property list</strong></summary>

| Property                | Type          | Default          | Description                        |
| ----------------------- | ------------- | ---------------- | ---------------------------------- |
| `preLayerColors`        | `List<Color>` | purple tones     | Decorative layers behind the panel |
| `panelColor`            | `Color`       | `white`          | Panel base fill colour             |
| `panelOpacity`          | `double`      | `0.95`           | Panel fill alpha (0–1)             |
| `blurSigma`             | `double`      | `12`             | Backdrop blur std-dev              |
| `accentColor`           | `Color`       | `#5227FF`        | Numbers, hover, social title       |
| `toggleColorClosed`     | `Color`       | `white`          | Toggle icon colour when closed     |
| `toggleColorOpen`       | `Color`       | `black`          | Toggle icon colour when open       |
| `toggleIconSize`        | `double`      | `22`             | Size of the `+` icon               |
| `toggleRotationDegrees` | `double`      | `225`            | Rotation of the `+` on open        |
| `headerPadding`         | `EdgeInsets`  | `h24 v20`        | Padding around logo + toggle row   |
| `panelPadding`          | `EdgeInsets`  | custom           | Inner panel padding                |
| `panelMinWidth`         | `double`      | `260`            | Minimum panel width (px)           |
| `panelMaxWidth`         | `double`      | `420`            | Maximum panel width (px)           |
| `panelWidthFraction`    | `double`      | `0.38`           | Panel width as screen fraction     |
| `mobileBreakpoint`      | `double`      | `640`            | Full-width panel below this width  |
| `closeOnClickAway`      | `bool`        | `true`           | Close when tapping the barrier     |
| `barrierColor`          | `Color`       | transparent      | Scrim behind the panel             |
| `itemTextStyle`         | `TextStyle`   | bold 48px        | Menu item text                     |
| `itemHoverTextStyle`    | `TextStyle`   | bold 48px accent | Menu item hover text               |
| `numberTextStyle`       | `TextStyle`   | bold 13px accent | Ordinal numbers                    |
| `socialsTitleStyle`     | `TextStyle`   | semi 14px        | "Socials" heading                  |
| `socialLinkStyle`       | `TextStyle`   | semi 16px        | Social link text                   |
| `socialLinkHoverStyle`  | `TextStyle`   | semi 16px accent | Social link hover                  |
| `showItemNumbering`     | `bool`        | `true`           | Show two-digit ordinals            |
| `enableHoverEffects`    | `bool`        | `true`           | Enable mouse-over interactions     |
| `duration`              | `Duration`    | `900 ms`         | Total open/close duration          |
| `panelCurve`            | `Curve`       | `easeOutQuart`   | Panel slide curve                  |
| `layerCurve`            | `Curve`       | `easeOutQuart`   | Pre-layer slide curve              |
| `itemCurve`             | `Curve`       | `easeOutQuart`   | Item entrance curve                |
| `layerStagger`          | `double`      | `0.08`           | Normalised delay between layers    |
| `itemStagger`           | `double`      | `0.07`           | Normalised delay between items     |

</details>

---

## 📁 Package structure

```
staggered_menu_flutter/
├── lib/
│   ├── staggered_menu_flutter.dart   ← public barrel (import this)
│   └── src/
│       ├── controller.dart           ← StaggeredMenuController
│       ├── menu_theme.dart           ← StaggeredMenuTheme (InheritedWidget)
│       ├── models.dart               ← StaggeredMenuItem, StaggeredSocialItem, MenuPosition
│       ├── route_helper.dart         ← StaggeredRouteHelper
│       ├── theme.dart                ← StaggeredMenuThemeData
│       └── staggered_menu.dart       ← StaggeredMenu widget + itemBuilder + keyboard nav
├── example/
│   └── lib/main.dart                 ← runnable demo
├── test/
│   └── staggered_menu_flutter_test.dart  (33 tests)
├── CHANGELOG.md
├── LICENSE
└── pubspec.yaml
```

---

## 🧪 Running tests

```bash
flutter test
```

---

## 🗺 Roadmap

- [x] `StaggeredMenuController` for programmatic open/close
- [x] Named routes integration helper (`StaggeredRouteHelper`)
- [x] `StaggeredMenuTheme` inherited widget
- [x] Custom item builder slot (`itemBuilder`)
- [x] Keyboard navigation (focus trap + Escape)

Upcoming:

- [ ] RTL layout support
- [ ] Spring physics animation preset
- [ ] Built-in hero transition for page changes

---

## 🤝 Contributing

PRs and issues are welcome at [github.com/NexivaServices/staggered_menu_flutter](https://github.com/NexivaServices/staggered_menu_flutter)!  
Please open an issue before submitting a large change so we can discuss the approach.

1. Fork the repository
2. Create your feature branch (`git checkout -b feat/my-feature`)
3. Commit your changes (`git commit -m 'feat: add my feature'`)
4. Push to the branch (`git push origin feat/my-feature`)
5. Open a Pull Request

---

## 📄 License

MIT © 2026 — see [LICENSE](LICENSE) for details.
