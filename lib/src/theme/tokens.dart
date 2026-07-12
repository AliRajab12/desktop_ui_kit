import 'dart:ui';

const _baseUnit = 4.0;

/// Design tokens for consistent spacing, sizing, and visual properties.
///
/// All values are multiples of the base unit (4px) for pixel-perfect alignment.
/// Use these constants throughout the library for consistent desktop styling.
class DesktopTokens {
  DesktopTokens._();

  // ── Spacing ──────────────────────────────────────────
  /// Extra extra extra small spacing (2px).
  static const double spaceXxs = _baseUnit * 0.5; // 2

  /// Extra extra small spacing (4px).
  static const double spaceXs = _baseUnit; // 4

  /// Extra small spacing (8px).
  static const double spaceSm = _baseUnit * 2; // 8

  /// Medium spacing (12px).
  static const double spaceMd = _baseUnit * 3; // 12

  /// Large spacing (16px).
  static const double spaceLg = _baseUnit * 4; // 16

  /// Extra large spacing (20px).
  static const double spaceXl = _baseUnit * 5; // 20

  /// Extra extra large spacing (24px).
  static const double spaceXxl = _baseUnit * 6; // 24

  /// Extra extra extra large spacing (32px).
  static const double spaceXxxl = _baseUnit * 8; // 32

  /// Extra extra extra extra large spacing (40px).
  static const double spaceXxxxl = _baseUnit * 10; // 40

  // ── Border Radius ────────────────────────────────────
  /// No border radius.
  static const double radiusNone = 0;

  /// Small border radius (2px).
  static const double radiusSm = 2;

  /// Medium border radius (4px).
  static const double radiusMd = 4;

  /// Large border radius (6px).
  static const double radiusLg = 6;

  /// Extra large border radius (8px).
  static const double radiusXl = 8;

  /// Extra extra large border radius (12px).
  static const double radiusXxl = 12;

  /// Full/pill border radius.
  static const double radiusFull = 9999;

  // ── Border Width ─────────────────────────────────────
  /// No border.
  static const double borderNone = 0;

  /// Thin border (0.5px).
  static const double borderThin = 0.5;

  /// Normal border (1px).
  static const double borderNormal = 1;

  /// Thick border (2px).
  static const double borderThick = 2;

  // ── Icon Sizes ───────────────────────────────────────
  /// Extra small icon size (12px).
  static const double iconXs = 12;

  /// Small icon size (16px).
  static const double iconSm = 16;

  /// Medium icon size (20px).
  static const double iconMd = 20;

  /// Large icon size (24px).
  static const double iconLg = 24;

  /// Extra large icon size (32px).
  static const double iconXl = 32;

  // ── Durations ────────────────────────────────────────
  /// Instant duration (0ms).
  static const Duration durationInstant = Duration.zero;

  /// Fast duration (100ms) for micro-interactions.
  static const Duration durationFast = Duration(milliseconds: 100);

  /// Normal duration (200ms) for standard animations.
  static const Duration durationNormal = Duration(milliseconds: 200);

  /// Slow duration (350ms) for complex animations.
  static const Duration durationSlow = Duration(milliseconds: 350);

  /// Tooltip display delay (500ms).
  static const Duration tooltipDelay = Duration(milliseconds: 500);

  // ── Elevation / Shadows ──────────────────────────────
  /// Returns a list of [Shadow] for the given elevation level (0-5).
  static List<Shadow> elevation(int level) {
    return switch (level) {
      0 => [],
      1 => [
          Shadow(
            blurRadius: 4,
            offset: const Offset(0, 1),
            color: Color(0x1A000000),
          ),
        ],
      2 => [
          Shadow(
            blurRadius: 8,
            offset: const Offset(0, 2),
            color: Color(0x26000000),
          ),
        ],
      3 => [
          Shadow(
            blurRadius: 16,
            offset: const Offset(0, 4),
            color: Color(0x33000000),
          ),
        ],
      4 => [
          Shadow(
            blurRadius: 24,
            offset: const Offset(0, 8),
            color: Color(0x40000000),
          ),
        ],
      _ => [
          Shadow(
            blurRadius: 32,
            offset: const Offset(0, 12),
            color: Color(0x4D000000),
          ),
        ],
    };
  }

  // ── Sizing ───────────────────────────────────────────
  /// Standard input field height (32px).
  static const double inputHeight = 32;

  /// Standard button height (32px).
  static const double buttonHeight = 32;

  /// Standard toolbar height (48px).
  static const double toolbarHeight = 48;

  /// Standard menu bar height (32px).
  static const double menuBarHeight = 32;

  /// Standard status bar height (28px).
  static const double statusBarHeight = 28;

  /// Standard tab height (36px).
  static const double tabHeight = 36;

  /// Panel header height (32px).
  static const double panelHeaderHeight = 32;

  /// Panel tab bar height (32px).
  static const double panelTabBarHeight = 32;

  /// Minimum side panel width (200px).
  static const double sidePanelMinWidth = 200;

  /// Maximum side panel width (400px).
  static const double sidePanelMaxWidth = 400;

  /// Resizable divider thickness (4px).
  static const double dividerThickness = 4;

  /// Collapsed panel toggle size (24px).
  static const double collapsedPanelSize = 24;

  /// Toolbar action button size (20px).
  static const double actionButtonSize = 20;

  /// Icon inside action button (14px).
  static const double actionButtonIconSize = 14;

  // ── Hit Area ─────────────────────────────────────────
  /// Minimum hit area size for touch targets (32px).
  static const double minHitArea = 32;

  // ── Opacity ──────────────────────────────────────────
  /// Disabled state opacity (0.38).
  static const double opacityDisabled = 0.38;

  /// Hover state opacity (0.08).
  static const double opacityHover = 0.08;

  /// Focus state opacity (0.12).
  static const double opacityFocus = 0.12;

  /// Pressed state opacity (0.16).
  static const double opacityPressed = 0.16;

  /// Drag state opacity (0.20).
  static const double opacityDrag = 0.20;
}
