import 'dart:ui';

const _baseUnit = 4.0;

class DesktopTokens {
  DesktopTokens._();

  // ── Spacing ──────────────────────────────────────────
  static const double spaceXxs = _baseUnit * 0.5; // 2
  static const double spaceXs = _baseUnit; // 4
  static const double spaceSm = _baseUnit * 2; // 8
  static const double spaceMd = _baseUnit * 3; // 12
  static const double spaceLg = _baseUnit * 4; // 16
  static const double spaceXl = _baseUnit * 5; // 20
  static const double spaceXxl = _baseUnit * 6; // 24
  static const double spaceXxxl = _baseUnit * 8; // 32
  static const double spaceXxxxl = _baseUnit * 10; // 40

  // ── Border Radius ────────────────────────────────────
  static const double radiusNone = 0;
  static const double radiusSm = 2;
  static const double radiusMd = 4;
  static const double radiusLg = 6;
  static const double radiusXl = 8;
  static const double radiusXxl = 12;
  static const double radiusFull = 9999;

  // ── Border Width ─────────────────────────────────────
  static const double borderNone = 0;
  static const double borderThin = 0.5;
  static const double borderNormal = 1;
  static const double borderThick = 2;

  // ── Icon Sizes ───────────────────────────────────────
  static const double iconXs = 12;
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;

  // ── Durations ────────────────────────────────────────
  static const Duration durationInstant = Duration.zero;
  static const Duration durationFast = Duration(milliseconds: 100);
  static const Duration durationNormal = Duration(milliseconds: 200);
  static const Duration durationSlow = Duration(milliseconds: 350);

  // ── Elevation / Shadows ──────────────────────────────
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
  static const double inputHeight = 32;
  static const double buttonHeight = 32;
  static const double toolbarHeight = 48;
  static const double menuBarHeight = 32;
  static const double statusBarHeight = 28;
  static const double tabHeight = 36;
  static const double sidePanelMinWidth = 200;
  static const double sidePanelMaxWidth = 400;

  // ── Hit Area ─────────────────────────────────────────
  static const double minHitArea = 32;

  // ── Opacity ──────────────────────────────────────────
  static const double opacityDisabled = 0.38;
  static const double opacityHover = 0.08;
  static const double opacityFocus = 0.12;
  static const double opacityPressed = 0.16;
  static const double opacityDrag = 0.20;
}
