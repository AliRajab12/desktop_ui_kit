import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

void main() {
  group('DesktopColorScheme', () {
    test('light scheme has correct values', () {
      final scheme = DesktopColorScheme.light;
      expect(scheme.isDark, false);
      expect(scheme.accent, const Color(0xFF0066CC));
      expect(scheme.surface, const Color(0xFFF9FAFB));
      expect(scheme.textPrimary, const Color(0xFF111827));
    });

    test('dark scheme has correct values', () {
      final scheme = DesktopColorScheme.dark;
      expect(scheme.isDark, true);
      expect(scheme.accent, const Color(0xFF4CA3FF));
      expect(scheme.surface, const Color(0xFF1A1B1E));
      expect(scheme.textPrimary, const Color(0xFFF3F4F6));
    });
  });

  group('DesktopThemeData', () {
    test('light theme creates valid Material ThemeData', () {
      final theme = DesktopThemeData.light();
      expect(theme.isDark, false);
      final material = theme.toMaterialTheme();
      expect(material.colorScheme.brightness, Brightness.light);
    });

    test('dark theme creates valid Material ThemeData', () {
      final theme = DesktopThemeData.dark();
      expect(theme.isDark, true);
      final material = theme.toMaterialTheme();
      expect(material.colorScheme.brightness, Brightness.dark);
    });
  });

  group('DesktopTokens', () {
    test('spacing values are multiples of base unit', () {
      expect(DesktopTokens.spaceXs, 4);
      expect(DesktopTokens.spaceSm, 8);
      expect(DesktopTokens.spaceMd, 12);
      expect(DesktopTokens.spaceLg, 16);
    });

    test('radius values are defined', () {
      expect(DesktopTokens.radiusSm, 2);
      expect(DesktopTokens.radiusMd, 4);
      expect(DesktopTokens.radiusLg, 6);
    });

    test('elevation returns correct number of shadows', () {
      expect(DesktopTokens.elevation(0), isEmpty);
      expect(DesktopTokens.elevation(1).length, 1);
      expect(DesktopTokens.elevation(4).length, 1);
    });
  });

  group('DesktopPlatformUtils', () {
    test('modifier key is Ctrl by default on non-macOS platforms', () {
      // On test runner (linux), this should be Ctrl
      expect(DesktopPlatformUtils.modifierKey, 'Ctrl');
    });
  });
}
