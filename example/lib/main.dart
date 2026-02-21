import 'package:flutter/material.dart';
import 'package:staggered_menu_flutter/staggered_menu_flutter.dart';

void main() => runApp(const DemoApp());

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StaggeredMenu Demo',
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentPage = 'Home';

  // ── Custom rose theme ─────────────────────────────────────────────────────
  static const _roseTheme = StaggeredMenuThemeData(
    accentColor: Color(0xFFFF2D55),
    preLayerColors: [Color(0xFFFFC2D1), Color(0xFFFF2D55)],
    panelOpacity: 0.93,
    blurSigma: 16,
    barrierColor: Color(0x44000000),
    duration: Duration(milliseconds: 800),
  );

  @override
  Widget build(BuildContext context) {
    return StaggeredMenu(
      theme: _roseTheme,
      logo: const Text(
        'STUDIO',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 18,
          letterSpacing: 2,
        ),
      ),
      items: [
        StaggeredMenuItem(
          label: 'Home',
          semanticsLabel: 'Go to Home',
          onTap: () => setState(() => _currentPage = 'Home'),
        ),
        StaggeredMenuItem(
          label: 'About',
          semanticsLabel: 'Go to About',
          onTap: () => setState(() => _currentPage = 'About'),
        ),
        StaggeredMenuItem(
          label: 'Projects',
          semanticsLabel: 'Go to Projects',
          onTap: () => setState(() => _currentPage = 'Projects'),
        ),
        StaggeredMenuItem(
          label: 'Blog',
          semanticsLabel: 'Go to Blog',
          onTap: () => setState(() => _currentPage = 'Blog'),
        ),
        StaggeredMenuItem(
          label: 'Contact',
          semanticsLabel: 'Go to Contact',
          onTap: () => setState(() => _currentPage = 'Contact'),
        ),
      ],
      socialItems: const [
        StaggeredSocialItem(label: 'GitHub'),
        StaggeredSocialItem(label: 'Dribbble'),
        StaggeredSocialItem(label: 'X'),
        StaggeredSocialItem(label: 'LinkedIn'),
      ],
      onMenuOpen: () => debugPrint('Menu opened'),
      onMenuClose: () => debugPrint('Menu closed'),
      child: Scaffold(
        backgroundColor: const Color(0xFF0E0E12),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _currentPage.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tap the menu button →',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
