import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Platform-adaptive text styles for desktop applications.
///
/// Uses native system fonts for each platform:
/// - Windows: Segoe UI
/// - macOS: SF Pro
/// - Linux: Cantarell
///
/// Use [platformAdaptive] to create text styles with the correct fonts.
class DesktopTextStyle {
  /// Large heading style (32px).
  final TextStyle heading1;

  /// Medium heading style (24px).
  final TextStyle heading2;

  /// Section heading style (20px).
  final TextStyle heading3;

  /// Subsection heading style (18px).
  final TextStyle heading4;

  /// Title heading style (16px).
  final TextStyle heading5;

  /// Small heading style (14px).
  final TextStyle heading6;

  /// Large body text style (16px).
  final TextStyle bodyLarge;

  /// Default body text style (14px).
  final TextStyle body;

  /// Small body text style (12px).
  final TextStyle bodySmall;

  /// Label/button text style (13px).
  final TextStyle label;

  /// Caption/metadata text style (11px).
  final TextStyle caption;

  /// Overline/eyebrow text style (10px).
  final TextStyle overline;

  /// Monospace code text style.
  final TextStyle code;

  /// Creates a text style collection.
  const DesktopTextStyle({
    required this.heading1,
    required this.heading2,
    required this.heading3,
    required this.heading4,
    required this.heading5,
    required this.heading6,
    required this.bodyLarge,
    required this.body,
    required this.bodySmall,
    required this.label,
    required this.caption,
    required this.overline,
    required this.code,
  });

  static const _fontFamilies = <String, List<String>>{
    'windows': ['Segoe UI', 'Segoe UI Variable', 'Roboto', 'sans-serif'],
    'macos': [
      'SF Pro Display',
      'SF Pro Text',
      'Helvetica Neue',
      'Helvetica',
      'Arial',
      'sans-serif',
    ],
    'linux': ['Cantarell', 'Noto Sans', 'Ubuntu', 'DejaVu Sans', 'sans-serif'],
  };

  static List<String> _familyForPlatform() {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return _fontFamilies['windows']!;
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      return _fontFamilies['macos']!;
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return _fontFamilies['linux']!;
    }
    return ['Roboto', 'sans-serif'];
  }

  /// Creates platform-adaptive text styles.
  ///
  /// Returns text styles using native system fonts for the current platform.
  static DesktopTextStyle platformAdaptive({required ColorScheme colorScheme}) {
    final family = _familyForPlatform();
    return DesktopTextStyle(
      heading1: TextStyle(
        fontFamilyFallback: family,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.5,
        color: colorScheme.onSurface,
      ),
      heading2: TextStyle(
        fontFamilyFallback: family,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: -0.25,
        color: colorScheme.onSurface,
      ),
      heading3: TextStyle(
        fontFamilyFallback: family,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: colorScheme.onSurface,
      ),
      heading4: TextStyle(
        fontFamilyFallback: family,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: colorScheme.onSurface,
      ),
      heading5: TextStyle(
        fontFamilyFallback: family,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.45,
        color: colorScheme.onSurface,
      ),
      heading6: TextStyle(
        fontFamilyFallback: family,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.5,
        color: colorScheme.onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamilyFallback: family,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: colorScheme.onSurface,
      ),
      body: TextStyle(
        fontFamilyFallback: family,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: colorScheme.onSurface,
      ),
      bodySmall: TextStyle(
        fontFamilyFallback: family,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: colorScheme.onSurfaceVariant,
      ),
      label: TextStyle(
        fontFamilyFallback: family,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.25,
        color: colorScheme.onSurface,
      ),
      caption: TextStyle(
        fontFamilyFallback: family,
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0.25,
        color: colorScheme.onSurfaceVariant,
      ),
      overline: TextStyle(
        fontFamilyFallback: family,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 1.3,
        letterSpacing: 1.0,
        color: colorScheme.onSurfaceVariant,
      ),
      code: TextStyle(
        fontFamily: 'JetBrains Mono',
        fontFamilyFallback: [
          'Fira Code',
          'Cascadia Code',
          'Consolas',
          'SF Mono',
          'monospace',
        ],
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: colorScheme.onSurface,
      ),
    );
  }
}
