/// The main [StaggeredMenu] widget and its internal sub-widgets.
library;

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controller.dart';
import 'menu_theme.dart';
import 'models.dart';
import 'theme.dart';

/// Signature for a builder that produces a custom widget for each menu item.
///
/// Receives the [BuildContext], the [StaggeredMenuItem] data, the positional
/// [index], and whether the menu item is currently [hovered].
///
/// ```dart
/// StaggeredMenu(
///   itemBuilder: (context, item, index, hovered) {
///     return Text(
///       item.label,
///       style: TextStyle(color: hovered ? Colors.red : Colors.white),
///     );
///   },
///   …
/// )
/// ```
typedef StaggeredMenuItemBuilder = Widget Function(
  BuildContext context,
  StaggeredMenuItem item,
  int index,
  bool hovered,
);

/// A full-screen overlay navigation menu with staggered slide-in layers,
/// a blurred glass panel, animated menu items, and optional social links.
///
/// Wrap your top-level [Scaffold] (or any [Widget]) with [StaggeredMenu]:
///
/// ```dart
/// StaggeredMenu(
///   position: MenuPosition.right,
///   items: [
///     StaggeredMenuItem(label: 'Home',    onTap: () {}),
///     StaggeredMenuItem(label: 'Work',    onTap: () {}),
///     StaggeredMenuItem(label: 'Contact', onTap: () {}),
///   ],
///   socialItems: [
///     StaggeredSocialItem(label: 'GitHub',    onTap: () {}),
///     StaggeredSocialItem(label: 'Twitter',   onTap: () {}),
///   ],
///   child: Scaffold(
///     body: Center(child: Text('My App')),
///   ),
/// )
/// ```
///
/// Customise every visual and motion property through [theme].
class StaggeredMenu extends StatefulWidget {
  /// The widget displayed underneath / behind the menu (typically a
  /// [Scaffold]).
  final Widget child;

  /// Navigation items shown in the slide-in panel.
  final List<StaggeredMenuItem> items;

  /// Optional social/link items shown at the bottom of the panel.
  final List<StaggeredSocialItem> socialItems;

  /// Optional logo widget placed in the header row on the leading side.
  /// Defaults to an empty [SizedBox] when `null`.
  final Widget? logo;

  /// Whether the panel slides in from the left or right edge.
  /// Defaults to [MenuPosition.right].
  final MenuPosition position;

  /// Visual and motion configuration.
  ///
  /// Resolution order:
  /// 1. This explicit [theme] parameter (when non-default).
  /// 2. The nearest [StaggeredMenuTheme] ancestor.
  /// 3. `const StaggeredMenuThemeData()` (built-in defaults).
  final StaggeredMenuThemeData? theme;

  /// Called when the menu finishes opening.
  final VoidCallback? onMenuOpen;

  /// Called when the menu finishes closing.
  final VoidCallback? onMenuClose;

  /// Optional controller for programmatic open / close / toggle.
  ///
  /// ```dart
  /// final ctrl = StaggeredMenuController();
  /// StaggeredMenu(controller: ctrl, …);
  /// // later:
  /// ctrl.open();
  /// ```
  final StaggeredMenuController? controller;

  /// Optional builder for fully custom menu-item rendering.
  ///
  /// When non-null the builder replaces the default uppercase-label +
  /// numbering widget for each item. The stagger animation, hit-testing,
  /// and semantics remain handled by the package.
  final StaggeredMenuItemBuilder? itemBuilder;

  /// Creates a [StaggeredMenu].
  const StaggeredMenu({
    super.key,
    required this.child,
    required this.items,
    this.socialItems = const [],
    this.logo,
    this.position = MenuPosition.right,
    this.theme,
    this.onMenuOpen,
    this.onMenuClose,
    this.controller,
    this.itemBuilder,
  });

  @override
  State<StaggeredMenu> createState() => _StaggeredMenuState();
}

class _StaggeredMenuState extends State<StaggeredMenu>
    with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final AnimationController _btnCtrl;
  bool _open = false;

  /// Focus node for the entire menu overlay – used for keyboard trapping.
  final FocusNode _overlayFocusNode = FocusNode(debugLabel: 'StaggeredMenu');

  bool get _isLeft => widget.position == MenuPosition.left;
  Alignment get _alignment =>
      _isLeft ? Alignment.centerLeft : Alignment.centerRight;

  /// Resolves the effective theme from widget param → inherited → defaults.
  StaggeredMenuThemeData get _effectiveTheme =>
      widget.theme ??
      StaggeredMenuTheme.maybeOf(context) ??
      const StaggeredMenuThemeData();

  @override
  void initState() {
    super.initState();
    // Theme duration can only be resolved after the first build when relying on
    // inherited theme, so we start with the explicit or default value.
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.theme?.duration ?? const Duration(milliseconds: 900),
    );
    _btnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    widget.controller?.addListener(_onControllerAction);
  }

  @override
  void didUpdateWidget(covariant StaggeredMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    final t = _effectiveTheme;
    if (_ctrl.duration != t.duration) {
      _ctrl.duration = t.duration;
    }
    // Re-wire controller if it changed.
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerAction);
      widget.controller?.addListener(_onControllerAction);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerAction);
    _ctrl.dispose();
    _btnCtrl.dispose();
    _overlayFocusNode.dispose();
    super.dispose();
  }

  // ── Controller integration ───────────────────────────────────────────────

  void _onControllerAction() {
    final action = widget.controller?.pendingAction;
    if (action == null) return;
    widget.controller!.consumeAction();
    switch (action) {
      case MenuAction.open:
        _openMenu();
      case MenuAction.close:
        _closeMenu();
      case MenuAction.toggle:
        _toggle();
    }
  }

  void _openMenu() {
    if (_open) return;
    setState(() => _open = true);
    widget.controller?.updateIsOpen(true);
    widget.onMenuOpen?.call();
    _ctrl.forward(from: 0);
    _btnCtrl.forward(from: 0);
    // Request focus so keyboard events are captured.
    _overlayFocusNode.requestFocus();
  }

  void _closeMenu() {
    if (!_open) return;
    setState(() => _open = false);
    widget.controller?.updateIsOpen(false);
    widget.onMenuClose?.call();
    _ctrl.reverse();
    _btnCtrl.reverse();
  }

  void _toggle() => _open ? _closeMenu() : _openMenu();

  double _panelWidth(BuildContext context, StaggeredMenuThemeData t) {
    final w = MediaQuery.sizeOf(context).width;
    if (w < t.mobileBreakpoint) return w;
    return (w * t.panelWidthFraction).clamp(t.panelMinWidth, t.panelMaxWidth);
  }

  @override
  Widget build(BuildContext context) {
    final t = _effectiveTheme;
    // Keep animation controller in sync with (possibly inherited) duration.
    if (_ctrl.duration != t.duration) {
      _ctrl.duration = t.duration;
    }
    final panelW = _panelWidth(context, t);

    return Stack(
      children: [
        widget.child,

        // ── Overlay (layers + panel + barrier) ─────────────────────────────
        AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            if (!_open && !_ctrl.isAnimating) return const SizedBox.shrink();
            return Positioned.fill(
              // ── Keyboard trap: Escape closes, Tab is confined ─────────
              child: KeyboardListener(
                focusNode: _overlayFocusNode,
                autofocus: true,
                onKeyEvent: _handleKeyEvent,
                child: FocusScope(
                  // Traps Tab navigation within the open panel.
                  autofocus: true,
                  child: Material(
                    // Prevents "No Material widget found" errors.
                    type: MaterialType.transparency,
                    child: Stack(
                      children: [
                        // Barrier
                        if (_open && t.closeOnClickAway)
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _closeMenu,
                            child: Container(color: t.barrierColor),
                          ),

                        // Pre-slide decorative layers
                        ...List.generate(t.preLayerColors.length, (i) {
                          final s = (i * t.layerStagger).clamp(0.0, 0.8);
                          final e = (s + 0.45).clamp(0.0, 1.0);
                          final anim = CurvedAnimation(
                            parent: _ctrl,
                            curve: Interval(s, e, curve: t.layerCurve),
                          );
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(_isLeft ? -1.0 : 1.0, 0),
                              end: Offset.zero,
                            ).animate(anim),
                            child: Align(
                              alignment: _alignment,
                              child: SizedBox(
                                width: panelW,
                                height: double.infinity,
                                child: ColoredBox(color: t.preLayerColors[i]),
                              ),
                            ),
                          );
                        }),

                        // Blur panel
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(_isLeft ? -1.0 : 1.0, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: _ctrl,
                              curve: Interval(0.18, 1.0, curve: t.panelCurve),
                            ),
                          ),
                          child: Align(
                            alignment: _alignment,
                            child: _Panel(
                              width: panelW,
                              theme: t,
                              items: widget.items,
                              socials: widget.socialItems,
                              progress: _ctrl,
                              onClose: _closeMenu,
                              itemBuilder: widget.itemBuilder,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        // ── Header (logo + toggle) ──────────────────────────────────────────
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: SafeArea(
            child: Padding(
              padding: t.headerPadding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.logo ?? const SizedBox.shrink(),
                  _ToggleButton(
                    open: _open,
                    ctrl: _btnCtrl,
                    theme: t,
                    onTap: _toggle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Keyboard handling ──────────────────────────────────────────────────

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      _closeMenu();
    }
  }
}

class _ToggleButton extends StatefulWidget {
  final bool open;
  final AnimationController ctrl;
  final StaggeredMenuThemeData theme;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.open,
    required this.ctrl,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<_ToggleButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    final colorAnim = ColorTween(
      begin: t.toggleColorClosed,
      end: t.toggleColorOpen,
    ).animate(
      CurvedAnimation(
        parent: widget.ctrl,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    final rotAnim =
        Tween<double>(begin: 0, end: t.toggleRotationDegrees * math.pi / 180)
            .animate(
      CurvedAnimation(parent: widget.ctrl, curve: Curves.easeOutBack),
    );

    return Semantics(
      button: true,
      label: widget.open ? 'Close menu' : 'Open menu',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          behavior: HitTestBehavior.opaque,
          child: AnimatedBuilder(
            animation: widget.ctrl,
            builder: (context, _) {
              final color = colorAnim.value ?? t.toggleColorClosed;
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: _hovered ? 0.7 : 1.0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Sliding "Menu" / "Close" label
                    SizedBox(
                      width: 50,
                      height: 20,
                      child: ClipRect(
                        child: Stack(
                          children: [
                            Positioned(
                              top: -20 * widget.ctrl.value,
                              left: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _slideLabel('Menu', color),
                                  _slideLabel('Close', color),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Transform.rotate(
                      angle: rotAnim.value,
                      child: Icon(
                        Icons.add,
                        color: color,
                        size: t.toggleIconSize,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _slideLabel(String text, Color color) => SizedBox(
        height: 20,
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            height: 1.3,
          ),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Panel
// ─────────────────────────────────────────────────────────────────────────────

class _Panel extends StatelessWidget {
  final double width;
  final StaggeredMenuThemeData theme;
  final List<StaggeredMenuItem> items;
  final List<StaggeredSocialItem> socials;
  final Animation<double> progress;
  final VoidCallback onClose;
  final StaggeredMenuItemBuilder? itemBuilder;

  const _Panel({
    required this.width,
    required this.theme,
    required this.items,
    required this.socials,
    required this.progress,
    required this.onClose,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final t = theme;
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Responsive item font size.
    final responsiveSize = (screenWidth * 0.065).clamp(36.0, 52.0);
    final baseItemStyle = t.itemTextStyle.copyWith(fontSize: responsiveSize);
    final hoverItemStyle =
        t.itemHoverTextStyle.copyWith(fontSize: responsiveSize);

    return GestureDetector(
      // Swallow taps so they don't propagate to the barrier.
      onTap: () {},
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: t.blurSigma, sigmaY: t.blurSigma),
          child: Container(
            width: width,
            height: double.infinity,
            padding: t.panelPadding,
            // ignore: deprecated_member_use
            color: t.panelColor.withOpacity(t.panelOpacity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: items.isEmpty ? 1 : items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      if (items.isEmpty) {
                        return Text('No items', style: baseItemStyle);
                      }
                      return _AnimatedItem(
                        index: i,
                        item: items[i],
                        progress: progress,
                        theme: t,
                        baseStyle: baseItemStyle,
                        hoverStyle: hoverItemStyle,
                        itemBuilder: itemBuilder,
                        onTap: () {
                          items[i].onTap?.call();
                          onClose();
                        },
                      );
                    },
                  ),
                ),
                if (socials.isNotEmpty)
                  FadeTransition(
                    opacity: Tween<double>(begin: 0, end: 1).animate(
                      CurvedAnimation(
                        parent: progress,
                        curve: const Interval(
                          0.55,
                          0.9,
                          curve: Curves.easeOut,
                        ),
                      ),
                    ),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.4),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: progress,
                          curve: const Interval(
                            0.55,
                            0.95,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                      ),
                      child: _SocialsSection(theme: t, socials: socials),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Socials section
// ─────────────────────────────────────────────────────────────────────────────

class _SocialsSection extends StatefulWidget {
  final StaggeredMenuThemeData theme;
  final List<StaggeredSocialItem> socials;

  const _SocialsSection({required this.theme, required this.socials});

  @override
  State<_SocialsSection> createState() => _SocialsSectionState();
}

class _SocialsSectionState extends State<_SocialsSection> {
  bool _groupHovered = false;
  int _hoveredIndex = -1;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Socials',
            style: t.socialsTitleStyle.copyWith(color: t.accentColor),
          ),
          const SizedBox(height: 10),
          MouseRegion(
            onEnter: (_) => setState(() => _groupHovered = true),
            onExit: (_) => setState(() {
              _groupHovered = false;
              _hoveredIndex = -1;
            }),
            child: Wrap(
              spacing: 16,
              runSpacing: 10,
              children: List.generate(widget.socials.length, (i) {
                final s = widget.socials[i];
                final hovered = t.enableHoverEffects && _hoveredIndex == i;
                final opacity = (t.enableHoverEffects && _groupHovered)
                    ? (hovered ? 1.0 : 0.35)
                    : 1.0;

                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _hoveredIndex = i),
                  onExit: (_) => setState(() => _hoveredIndex = -1),
                  child: GestureDetector(
                    onTap: s.onTap,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: opacity,
                      child: DefaultTextStyle(
                        style: (hovered
                                ? t.socialLinkHoverStyle
                                : t.socialLinkStyle)
                            .copyWith(
                          color:
                              hovered ? t.accentColor : t.socialLinkStyle.color,
                        ),
                        child: Text(
                          s.label,
                          semanticsLabel: s.semanticsLabel ?? s.label,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated menu item
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedItem extends StatefulWidget {
  final int index;
  final StaggeredMenuItem item;
  final Animation<double> progress;
  final StaggeredMenuThemeData theme;
  final TextStyle baseStyle;
  final TextStyle hoverStyle;
  final VoidCallback onTap;
  final StaggeredMenuItemBuilder? itemBuilder;

  const _AnimatedItem({
    required this.index,
    required this.item,
    required this.progress,
    required this.theme,
    required this.baseStyle,
    required this.hoverStyle,
    required this.onTap,
    this.itemBuilder,
  });

  @override
  State<_AnimatedItem> createState() => _AnimatedItemState();
}

class _AnimatedItemState extends State<_AnimatedItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;

    final s = (0.28 + widget.index * t.itemStagger).clamp(0.0, 0.9);
    final e = (s + 0.5).clamp(0.0, 1.0);
    final curve = CurvedAnimation(
      parent: widget.progress,
      curve: Interval(s, e, curve: t.itemCurve),
    );

    return AnimatedBuilder(
      animation: curve,
      builder: (context, _) {
        final v = curve.value;
        final yOffset = (1 - v) * 44.0;
        final rotation = (1 - v) * (10 * math.pi / 180);

        final isHovered = t.enableHoverEffects && _hovered;

        return Transform.translate(
          offset: Offset(0, yOffset),
          child: Transform(
            alignment: Alignment.bottomLeft,
            transform: Matrix4.rotationZ(rotation),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: Semantics(
                button: true,
                label: widget.item.semanticsLabel ?? widget.item.label,
                child: GestureDetector(
                  onTap: widget.onTap,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: widget.itemBuilder != null
                        // ── Custom builder slot ─────────────────────────
                        ? widget.itemBuilder!(
                            context,
                            widget.item,
                            widget.index,
                            isHovered,
                          )
                        // ── Default rendering ───────────────────────────
                        : Stack(
                            clipBehavior: Clip.none,
                            children: [
                              DefaultTextStyle(
                                style: (isHovered
                                        ? widget.hoverStyle
                                        : widget.baseStyle)
                                    .copyWith(
                                  color: isHovered
                                      ? t.accentColor
                                      : widget.baseStyle.color,
                                ),
                                child: Text(widget.item.label.toUpperCase()),
                              ),
                              if (t.showItemNumbering)
                                Positioned(
                                  top: 8,
                                  right: -20,
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: v,
                                    child: Text(
                                      (widget.index + 1)
                                          .toString()
                                          .padLeft(2, '0'),
                                      style: t.numberTextStyle
                                          .copyWith(color: t.accentColor),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
