/// Theme configuration for the staggered menu widget.
library;

import 'package:flutter/material.dart';

/// Immutable description of every visual and motion property of a
/// `StaggeredMenu` widget.
///
/// Pass a [StaggeredMenuThemeData] to `StaggeredMenu.theme` to customise the
/// menu, or start from the defaults and override only what you need with
/// [copyWith]:
///
/// ```dart
/// StaggeredMenuThemeData().copyWith(
///   accentColor: Colors.deepPurple,
///   blurSigma: 20,
/// )
/// ```
@immutable
class StaggeredMenuThemeData {
  // ─── Pre-slide layers ───────────────────────────────────────────────────────

  /// Colours for the decorative layers that slide in behind the main panel.
  /// The list length controls how many layers are rendered.
  /// Defaults to `[Color(0xFFB19EEF), Color(0xFF5227FF)]`.
  final List<Color> preLayerColors;

  // ─── Panel ──────────────────────────────────────────────────────────────────

  /// Base fill colour of the blur panel.
  final Color panelColor;

  /// Opacity applied on top of [panelColor] – `0` is fully transparent,
  /// `1` is fully opaque. Defaults to `0.95`.
  final double panelOpacity;

  /// Standard-deviation for the backdrop blur behind the panel.
  /// Set to `0` to disable blur. Defaults to `12`.
  final double blurSigma;

  // ─── Accent ─────────────────────────────────────────────────────────────────

  /// Primary accent colour used for item numbers, hover states, social title
  /// and hover text. Defaults to `Color(0xFF5227FF)`.
  final Color accentColor;

  // ─── Toggle button ──────────────────────────────────────────────────────────

  /// Icon / label colour when the menu is **closed**.
  final Color toggleColorClosed;

  /// Icon / label colour when the menu is **open**.
  final Color toggleColorOpen;

  /// Size of the `+` icon in the toggle button. Defaults to `22`.
  final double toggleIconSize;

  /// How many degrees the `+` icon rotates when the menu opens.
  /// `225°` produces a diagonal cross–like shape. Defaults to `225`.
  final double toggleRotationDegrees;

  // ─── Layout ─────────────────────────────────────────────────────────────────

  /// Padding around the header row (logo + toggle button).
  final EdgeInsets headerPadding;

  /// Inner padding of the slide-in panel.
  final EdgeInsets panelPadding;

  /// Minimum panel width in logical pixels. Defaults to `260`.
  final double panelMinWidth;

  /// Maximum panel width in logical pixels. Defaults to `420`.
  final double panelMaxWidth;

  /// Panel width as a fraction of screen width.
  /// The result is clamped between [panelMinWidth] and [panelMaxWidth].
  /// On screens narrower than [mobileBreakpoint] the panel fills 100 %.
  /// Defaults to `0.38`.
  final double panelWidthFraction;

  /// Screens narrower than this value (logical pixels) get a full-width panel.
  /// Defaults to `640`.
  final double mobileBreakpoint;

  // ─── Barrier ────────────────────────────────────────────────────────────────

  /// Whether tapping outside the panel closes the menu. Defaults to `true`.
  final bool closeOnClickAway;

  /// Colour of the translucent barrier rendered behind the panel.
  /// Use a non-zero alpha to dim the page content while the menu is open.
  /// Defaults to `Colors.transparent`.
  final Color barrierColor;

  // ─── Typography ─────────────────────────────────────────────────────────────

  /// Text style for un-hovered menu items.
  final TextStyle itemTextStyle;

  /// Text style for **hovered** menu items.
  final TextStyle itemHoverTextStyle;

  /// Text style for the ordinal number rendered next to each item.
  final TextStyle numberTextStyle;

  /// Text style for the "Socials" section heading.
  final TextStyle socialsTitleStyle;

  /// Text style for un-hovered social links.
  final TextStyle socialLinkStyle;

  /// Text style for **hovered** social links.
  final TextStyle socialLinkHoverStyle;

  // ─── Feature toggles ────────────────────────────────────────────────────────

  /// Whether to render a two-digit ordinal next to each menu item.
  /// Defaults to `true`.
  final bool showItemNumbering;

  /// Whether hover / mouse-over effects are active.
  /// Disable for touch-only UIs. Defaults to `true`.
  final bool enableHoverEffects;

  // ─── Motion ─────────────────────────────────────────────────────────────────

  /// Total duration of the open / close animation. Defaults to `900 ms`.
  final Duration duration;

  /// Easing curve for the main blur panel slide. Defaults to
  /// [Curves.easeOutQuart].
  final Curve panelCurve;

  /// Easing curve for each pre-layer slide. Defaults to
  /// [Curves.easeOutQuart].
  final Curve layerCurve;

  /// Easing curve for each menu item entrance. Defaults to
  /// [Curves.easeOutQuart].
  final Curve itemCurve;

  /// Normalised (0–1) time offset between consecutive pre-layers.
  /// Defaults to `0.08`.
  final double layerStagger;

  /// Normalised (0–1) time offset between consecutive menu items.
  /// Defaults to `0.07`.
  final double itemStagger;

  /// Creates a fully-specified [StaggeredMenuThemeData].
  ///
  /// Every parameter has a sensible default so you can construct an instance
  /// with no arguments and override only what you need via [copyWith].
  const StaggeredMenuThemeData({
    this.preLayerColors = const [Color(0xFFB19EEF), Color(0xFF5227FF)],
    this.panelColor = Colors.white,
    this.panelOpacity = 0.95,
    this.blurSigma = 12,
    this.accentColor = const Color(0xFF5227FF),
    this.toggleColorClosed = Colors.white,
    this.toggleColorOpen = Colors.black,
    this.toggleIconSize = 22,
    this.toggleRotationDegrees = 225,
    this.headerPadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    this.panelPadding = const EdgeInsets.fromLTRB(28, 96, 28, 28),
    this.panelMinWidth = 260,
    this.panelMaxWidth = 420,
    this.panelWidthFraction = 0.38,
    this.mobileBreakpoint = 640,
    this.closeOnClickAway = true,
    this.barrierColor = const Color(0x00000000),
    this.itemTextStyle = const TextStyle(
      fontSize: 48,
      height: 1.05,
      letterSpacing: -1.5,
      fontWeight: FontWeight.w900,
      color: Colors.black,
    ),
    this.itemHoverTextStyle = const TextStyle(
      fontSize: 48,
      height: 1.05,
      letterSpacing: -1.5,
      fontWeight: FontWeight.w900,
      color: Color(0xFF5227FF),
    ),
    this.numberTextStyle = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      color: Color(0xFF5227FF),
    ),
    this.socialsTitleStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF5227FF),
    ),
    this.socialLinkStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    this.socialLinkHoverStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Color(0xFF5227FF),
    ),
    this.showItemNumbering = true,
    this.enableHoverEffects = true,
    this.duration = const Duration(milliseconds: 900),
    this.panelCurve = Curves.easeOutQuart,
    this.layerCurve = Curves.easeOutQuart,
    this.itemCurve = Curves.easeOutQuart,
    this.layerStagger = 0.08,
    this.itemStagger = 0.07,
  });

  /// Returns a copy of this theme with the given fields replaced.
  StaggeredMenuThemeData copyWith({
    List<Color>? preLayerColors,
    Color? panelColor,
    double? panelOpacity,
    double? blurSigma,
    Color? accentColor,
    Color? toggleColorClosed,
    Color? toggleColorOpen,
    double? toggleIconSize,
    double? toggleRotationDegrees,
    EdgeInsets? headerPadding,
    EdgeInsets? panelPadding,
    double? panelMinWidth,
    double? panelMaxWidth,
    double? panelWidthFraction,
    double? mobileBreakpoint,
    bool? closeOnClickAway,
    Color? barrierColor,
    TextStyle? itemTextStyle,
    TextStyle? itemHoverTextStyle,
    TextStyle? numberTextStyle,
    TextStyle? socialsTitleStyle,
    TextStyle? socialLinkStyle,
    TextStyle? socialLinkHoverStyle,
    bool? showItemNumbering,
    bool? enableHoverEffects,
    Duration? duration,
    Curve? panelCurve,
    Curve? layerCurve,
    Curve? itemCurve,
    double? layerStagger,
    double? itemStagger,
  }) {
    return StaggeredMenuThemeData(
      preLayerColors: preLayerColors ?? this.preLayerColors,
      panelColor: panelColor ?? this.panelColor,
      panelOpacity: panelOpacity ?? this.panelOpacity,
      blurSigma: blurSigma ?? this.blurSigma,
      accentColor: accentColor ?? this.accentColor,
      toggleColorClosed: toggleColorClosed ?? this.toggleColorClosed,
      toggleColorOpen: toggleColorOpen ?? this.toggleColorOpen,
      toggleIconSize: toggleIconSize ?? this.toggleIconSize,
      toggleRotationDegrees:
          toggleRotationDegrees ?? this.toggleRotationDegrees,
      headerPadding: headerPadding ?? this.headerPadding,
      panelPadding: panelPadding ?? this.panelPadding,
      panelMinWidth: panelMinWidth ?? this.panelMinWidth,
      panelMaxWidth: panelMaxWidth ?? this.panelMaxWidth,
      panelWidthFraction: panelWidthFraction ?? this.panelWidthFraction,
      mobileBreakpoint: mobileBreakpoint ?? this.mobileBreakpoint,
      closeOnClickAway: closeOnClickAway ?? this.closeOnClickAway,
      barrierColor: barrierColor ?? this.barrierColor,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      itemHoverTextStyle: itemHoverTextStyle ?? this.itemHoverTextStyle,
      numberTextStyle: numberTextStyle ?? this.numberTextStyle,
      socialsTitleStyle: socialsTitleStyle ?? this.socialsTitleStyle,
      socialLinkStyle: socialLinkStyle ?? this.socialLinkStyle,
      socialLinkHoverStyle: socialLinkHoverStyle ?? this.socialLinkHoverStyle,
      showItemNumbering: showItemNumbering ?? this.showItemNumbering,
      enableHoverEffects: enableHoverEffects ?? this.enableHoverEffects,
      duration: duration ?? this.duration,
      panelCurve: panelCurve ?? this.panelCurve,
      layerCurve: layerCurve ?? this.layerCurve,
      itemCurve: itemCurve ?? this.itemCurve,
      layerStagger: layerStagger ?? this.layerStagger,
      itemStagger: itemStagger ?? this.itemStagger,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StaggeredMenuThemeData &&
        other.preLayerColors == preLayerColors &&
        other.panelColor == panelColor &&
        other.panelOpacity == panelOpacity &&
        other.blurSigma == blurSigma &&
        other.accentColor == accentColor &&
        other.toggleColorClosed == toggleColorClosed &&
        other.toggleColorOpen == toggleColorOpen &&
        other.toggleIconSize == toggleIconSize &&
        other.toggleRotationDegrees == toggleRotationDegrees &&
        other.headerPadding == headerPadding &&
        other.panelPadding == panelPadding &&
        other.panelMinWidth == panelMinWidth &&
        other.panelMaxWidth == panelMaxWidth &&
        other.panelWidthFraction == panelWidthFraction &&
        other.mobileBreakpoint == mobileBreakpoint &&
        other.closeOnClickAway == closeOnClickAway &&
        other.barrierColor == barrierColor &&
        other.itemTextStyle == itemTextStyle &&
        other.itemHoverTextStyle == itemHoverTextStyle &&
        other.numberTextStyle == numberTextStyle &&
        other.socialsTitleStyle == socialsTitleStyle &&
        other.socialLinkStyle == socialLinkStyle &&
        other.socialLinkHoverStyle == socialLinkHoverStyle &&
        other.showItemNumbering == showItemNumbering &&
        other.enableHoverEffects == enableHoverEffects &&
        other.duration == duration &&
        other.panelCurve == panelCurve &&
        other.layerCurve == layerCurve &&
        other.itemCurve == itemCurve &&
        other.layerStagger == layerStagger &&
        other.itemStagger == itemStagger;
  }

  @override
  int get hashCode => Object.hashAll([
        preLayerColors,
        panelColor,
        panelOpacity,
        blurSigma,
        accentColor,
        toggleColorClosed,
        toggleColorOpen,
        toggleIconSize,
        toggleRotationDegrees,
        headerPadding,
        panelPadding,
        panelMinWidth,
        panelMaxWidth,
        panelWidthFraction,
        mobileBreakpoint,
        closeOnClickAway,
        barrierColor,
        itemTextStyle,
        itemHoverTextStyle,
        numberTextStyle,
        socialsTitleStyle,
        socialLinkStyle,
        socialLinkHoverStyle,
        showItemNumbering,
        enableHoverEffects,
        duration,
        panelCurve,
        layerCurve,
        itemCurve,
        layerStagger,
        itemStagger,
      ]);
}
