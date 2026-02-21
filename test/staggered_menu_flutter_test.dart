import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staggered_menu_flutter/staggered_menu_flutter.dart';

void main() {
  // ───────────────────────────────────────────────────────────────────────────
  // Theme data
  // ───────────────────────────────────────────────────────────────────────────

  group('StaggeredMenuThemeData', () {
    test('default values are set correctly', () {
      const theme = StaggeredMenuThemeData();
      expect(theme.preLayerColors.length, 2);
      expect(theme.panelOpacity, 0.95);
      expect(theme.blurSigma, 12.0);
      expect(theme.panelMinWidth, 260.0);
      expect(theme.panelMaxWidth, 420.0);
      expect(theme.mobileBreakpoint, 640.0);
      expect(theme.closeOnClickAway, isTrue);
      expect(theme.showItemNumbering, isTrue);
      expect(theme.enableHoverEffects, isTrue);
      expect(theme.layerStagger, 0.08);
      expect(theme.itemStagger, 0.07);
    });

    test('copyWith overrides individual fields', () {
      const theme = StaggeredMenuThemeData();
      final updated = theme.copyWith(
        accentColor: Colors.red,
        panelOpacity: 0.5,
        showItemNumbering: false,
      );
      expect(updated.accentColor, Colors.red);
      expect(updated.panelOpacity, 0.5);
      expect(updated.showItemNumbering, isFalse);
      // Unchanged fields remain.
      expect(updated.blurSigma, theme.blurSigma);
      expect(updated.duration, theme.duration);
    });

    test('equality works', () {
      const a = StaggeredMenuThemeData();
      const b = StaggeredMenuThemeData();
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Models
  // ───────────────────────────────────────────────────────────────────────────

  group('StaggeredMenuItem', () {
    test('creates with required label', () {
      const item = StaggeredMenuItem(label: 'Home');
      expect(item.label, 'Home');
      expect(item.semanticsLabel, isNull);
      expect(item.onTap, isNull);
    });

    test('semanticsLabel and onTap are stored', () {
      var tapped = false;
      final item = StaggeredMenuItem(
        label: 'About',
        semanticsLabel: 'Navigate to About',
        onTap: () => tapped = true,
      );
      item.onTap?.call();
      expect(tapped, isTrue);
      expect(item.semanticsLabel, 'Navigate to About');
    });
  });

  group('StaggeredSocialItem', () {
    test('creates with required label', () {
      const item = StaggeredSocialItem(label: 'GitHub');
      expect(item.label, 'GitHub');
      expect(item.onTap, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Controller
  // ───────────────────────────────────────────────────────────────────────────

  group('StaggeredMenuController', () {
    test('initial state is closed with no pending action', () {
      final ctrl = StaggeredMenuController();
      expect(ctrl.isOpen, isFalse);
      expect(ctrl.pendingAction, isNull);
      ctrl.dispose();
    });

    test('open() sets pending action to open', () {
      final ctrl = StaggeredMenuController();
      var notified = false;
      ctrl.addListener(() => notified = true);

      ctrl.open();

      expect(ctrl.pendingAction, MenuAction.open);
      expect(notified, isTrue);
      ctrl.dispose();
    });

    test('close() sets pending action to close', () {
      final ctrl = StaggeredMenuController();
      ctrl.close();
      expect(ctrl.pendingAction, MenuAction.close);
      ctrl.dispose();
    });

    test('toggle() sets pending action to toggle', () {
      final ctrl = StaggeredMenuController();
      ctrl.toggle();
      expect(ctrl.pendingAction, MenuAction.toggle);
      ctrl.dispose();
    });

    test('updateIsOpen reports current state', () {
      final ctrl = StaggeredMenuController();
      expect(ctrl.isOpen, isFalse);
      ctrl.updateIsOpen(true);
      expect(ctrl.isOpen, isTrue);
      ctrl.updateIsOpen(false);
      expect(ctrl.isOpen, isFalse);
      ctrl.dispose();
    });

    test('consumeAction clears the pending action', () {
      final ctrl = StaggeredMenuController();
      ctrl.open();
      expect(ctrl.pendingAction, MenuAction.open);
      ctrl.consumeAction();
      expect(ctrl.pendingAction, isNull);
      ctrl.dispose();
    });

    testWidgets('controller.open() opens the menu', (tester) async {
      final ctrl = StaggeredMenuController();

      await tester.pumpWidget(
        MaterialApp(
          home: StaggeredMenu(
            controller: ctrl,
            items: [
              StaggeredMenuItem(label: 'Home', onTap: () {}),
            ],
            child: const Scaffold(body: SizedBox.shrink()),
          ),
        ),
      );

      // Menu closed initially.
      expect(find.text('HOME'), findsNothing);

      ctrl.open();
      await tester.pumpAndSettle();

      // Menu should be open.
      expect(find.text('HOME'), findsOneWidget);
      expect(ctrl.isOpen, isTrue);

      ctrl.dispose();
    });

    testWidgets('controller.close() closes the menu', (tester) async {
      final ctrl = StaggeredMenuController();

      await tester.pumpWidget(
        MaterialApp(
          home: StaggeredMenu(
            controller: ctrl,
            items: [
              StaggeredMenuItem(label: 'Home', onTap: () {}),
            ],
            child: const Scaffold(body: SizedBox.shrink()),
          ),
        ),
      );

      // Open first.
      ctrl.open();
      await tester.pumpAndSettle();
      expect(find.text('HOME'), findsOneWidget);

      // Close.
      ctrl.close();
      await tester.pumpAndSettle();

      expect(ctrl.isOpen, isFalse);

      ctrl.dispose();
    });

    testWidgets('controller.toggle() toggles the menu', (tester) async {
      final ctrl = StaggeredMenuController();

      await tester.pumpWidget(
        MaterialApp(
          home: StaggeredMenu(
            controller: ctrl,
            items: [
              StaggeredMenuItem(label: 'Home', onTap: () {}),
            ],
            child: const Scaffold(body: SizedBox.shrink()),
          ),
        ),
      );

      // Toggle open.
      ctrl.toggle();
      await tester.pumpAndSettle();
      expect(ctrl.isOpen, isTrue);

      // Toggle close.
      ctrl.toggle();
      await tester.pumpAndSettle();
      expect(ctrl.isOpen, isFalse);

      ctrl.dispose();
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // StaggeredMenuTheme (InheritedWidget)
  // ───────────────────────────────────────────────────────────────────────────

  group('StaggeredMenuTheme', () {
    testWidgets('maybeOf returns null when no ancestor exists', (tester) async {
      StaggeredMenuThemeData? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = StaggeredMenuTheme.maybeOf(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(result, isNull);
    });

    testWidgets('of returns defaults when no ancestor exists', (tester) async {
      late StaggeredMenuThemeData result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = StaggeredMenuTheme.of(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(result, const StaggeredMenuThemeData());
    });

    testWidgets('provides theme data to descendants', (tester) async {
      const data = StaggeredMenuThemeData(accentColor: Colors.red);
      StaggeredMenuThemeData? result;

      await tester.pumpWidget(
        MaterialApp(
          home: StaggeredMenuTheme(
            data: data,
            child: Builder(
              builder: (context) {
                result = StaggeredMenuTheme.maybeOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(result, isNotNull);
      expect(result!.accentColor, Colors.red);
    });

    testWidgets('updateShouldNotify returns true when data differs',
        (tester) async {
      const data1 = StaggeredMenuThemeData();
      const data2 = StaggeredMenuThemeData(accentColor: Colors.blue);

      const widget1 = StaggeredMenuTheme(
        data: data1,
        child: SizedBox.shrink(),
      );
      const widget2 = StaggeredMenuTheme(
        data: data2,
        child: SizedBox.shrink(),
      );

      expect(widget1.updateShouldNotify(widget2), isTrue);
      expect(widget1.updateShouldNotify(widget1), isFalse);
    });

    testWidgets('menu picks up inherited theme', (tester) async {
      const data = StaggeredMenuThemeData(accentColor: Colors.purple);

      await tester.pumpWidget(
        const MaterialApp(
          home: StaggeredMenuTheme(
            data: data,
            child: StaggeredMenu(
              items: [],
              child: Scaffold(body: SizedBox.shrink()),
            ),
          ),
        ),
      );

      // If no exception, inherited resolution worked.
      expect(find.byType(StaggeredMenu), findsOneWidget);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Route helper
  // ───────────────────────────────────────────────────────────────────────────

  group('StaggeredRouteHelper', () {
    testWidgets('fromRoutes creates items for each route', (tester) async {
      late List<StaggeredMenuItem> items;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              items = StaggeredRouteHelper.fromRoutes(
                context,
                routes: {
                  '/': 'Home',
                  '/about': 'About',
                  '/contact': 'Contact',
                },
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(items.length, 3);
      expect(items[0].label, 'Home');
      expect(items[1].label, 'About');
      expect(items[2].label, 'Contact');
      // All should have non-null onTap since no currentRoute is set.
      for (final item in items) {
        expect(item.onTap, isNotNull);
      }
    });

    testWidgets('current route item has null onTap', (tester) async {
      late List<StaggeredMenuItem> items;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              items = StaggeredRouteHelper.fromRoutes(
                context,
                routes: {
                  '/': 'Home',
                  '/about': 'About',
                },
                currentRoute: '/',
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      // Active route gets null onTap.
      expect(items[0].onTap, isNull);
      // Other route has onTap.
      expect(items[1].onTap, isNotNull);
    });

    testWidgets('current route item has semantics label with "(current page)"',
        (tester) async {
      late List<StaggeredMenuItem> items;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              items = StaggeredRouteHelper.fromRoutes(
                context,
                routes: {'/': 'Home'},
                currentRoute: '/',
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(items[0].semanticsLabel, 'Home (current page)');
    });

    testWidgets('fromRoutesReplacement delegates correctly', (tester) async {
      late List<StaggeredMenuItem> items;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              items = StaggeredRouteHelper.fromRoutesReplacement(
                context,
                routes: {'/a': 'A', '/b': 'B'},
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(items.length, 2);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Custom item builder
  // ───────────────────────────────────────────────────────────────────────────

  group('Custom itemBuilder', () {
    testWidgets('uses itemBuilder when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StaggeredMenu(
            items: [
              StaggeredMenuItem(label: 'Custom', onTap: () {}),
            ],
            itemBuilder: (context, item, index, hovered) {
              return Text('CUSTOM_${item.label}_$index');
            },
            child: const Scaffold(body: SizedBox.shrink()),
          ),
        ),
      );

      // Open the menu.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Custom builder output should be visible.
      expect(find.text('CUSTOM_Custom_0'), findsOneWidget);
      // Default rendering should NOT appear.
      expect(find.text('CUSTOM'), findsNothing);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // Keyboard navigation (focus trap)
  // ───────────────────────────────────────────────────────────────────────────

  group('Keyboard navigation', () {
    testWidgets('Escape key closes the menu', (tester) async {
      final ctrl = StaggeredMenuController();

      await tester.pumpWidget(
        MaterialApp(
          home: StaggeredMenu(
            controller: ctrl,
            items: [
              StaggeredMenuItem(label: 'Home', onTap: () {}),
            ],
            child: const Scaffold(body: SizedBox.shrink()),
          ),
        ),
      );

      // Open the menu.
      ctrl.open();
      await tester.pumpAndSettle();
      expect(ctrl.isOpen, isTrue);

      // Press Escape.
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(ctrl.isOpen, isFalse);

      ctrl.dispose();
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // StaggeredMenu widget (original tests)
  // ───────────────────────────────────────────────────────────────────────────

  group('StaggeredMenu widget', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StaggeredMenu(
            items: [],
            child: Scaffold(
              body: Center(child: Text('Hello')),
            ),
          ),
        ),
      );
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('toggle button is visible', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StaggeredMenu(
            items: [],
            child: Scaffold(body: SizedBox.shrink()),
          ),
        ),
      );
      expect(find.text('Menu'), findsOneWidget);
    });

    testWidgets('tapping toggle opens the panel', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StaggeredMenu(
            items: [
              StaggeredMenuItem(label: 'Home', onTap: () {}),
            ],
            child: const Scaffold(body: SizedBox.shrink()),
          ),
        ),
      );

      // Menu is closed; panel items should not yet be visible.
      expect(find.text('CLOSE'), findsNothing);

      // Tap the toggle button.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // After opening the panel, item label is rendered.
      expect(find.text('HOME'), findsOneWidget);
    });

    testWidgets('logo widget is displayed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StaggeredMenu(
            items: [],
            logo: Text('LOGO'),
            child: Scaffold(body: SizedBox.shrink()),
          ),
        ),
      );
      expect(find.text('LOGO'), findsOneWidget);
    });

    testWidgets('left position renders without error', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StaggeredMenu(
            position: MenuPosition.left,
            items: [],
            child: Scaffold(body: SizedBox.shrink()),
          ),
        ),
      );
      expect(find.byType(StaggeredMenu), findsOneWidget);
    });

    testWidgets('nullable theme falls back to defaults', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: StaggeredMenu(
            items: [],
            child: Scaffold(body: SizedBox.shrink()),
          ),
        ),
      );
      // Widget renders correctly with null theme (using defaults).
      expect(find.byType(StaggeredMenu), findsOneWidget);
    });

    testWidgets('onMenuOpen and onMenuClose callbacks fire', (tester) async {
      var opened = false;
      var closed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StaggeredMenu(
            items: [
              StaggeredMenuItem(label: 'A', onTap: () {}),
            ],
            onMenuOpen: () => opened = true,
            onMenuClose: () => closed = true,
            child: const Scaffold(body: SizedBox.shrink()),
          ),
        ),
      );

      // Open.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(opened, isTrue);

      // Close (same toggle button – it uses Icons.add with rotation).
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });
  });
}
