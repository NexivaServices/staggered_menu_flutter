import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:staggered_menu_flutter/staggered_menu_flutter.dart';

void main() {
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
  });
}
