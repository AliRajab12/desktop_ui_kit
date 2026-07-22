import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

void main() {
  group('DesktopColorScheme', () {
    test('highContrastLight has black text on white background', () {
      final scheme = DesktopColorScheme.highContrastLight;
      expect(scheme.isDark, false);
      expect(scheme.textPrimary, const Color(0xFF000000));
      expect(scheme.surface, const Color(0xFFFFFFFF));
    });

    test('highContrastDark has white text on black background', () {
      final scheme = DesktopColorScheme.highContrastDark;
      expect(scheme.isDark, true);
      expect(scheme.textPrimary, const Color(0xFFFFFFFF));
      expect(scheme.surface, const Color(0xFF000000));
    });

    test('highContrastLight has strong borders', () {
      final scheme = DesktopColorScheme.highContrastLight;
      expect(scheme.border, const Color(0xFF000000));
      expect(scheme.borderFocused, const Color(0xFF0000CC));
    });

    test('highContrastDark has strong borders', () {
      final scheme = DesktopColorScheme.highContrastDark;
      expect(scheme.border, const Color(0xFFFFFFFF));
      expect(scheme.borderFocused, const Color(0xFF6699FF));
    });

    test('highContrastLight copyWith works', () {
      final scheme = DesktopColorScheme.highContrastLight;
      final modified = scheme.copyWith(accent: const Color(0xFF00FF00));
      expect(modified.accent, const Color(0xFF00FF00));
      expect(modified.textPrimary, scheme.textPrimary);
    });
  });

  group('DesktopThemeData', () {
    test('highContrastLight factory creates correct theme', () {
      final theme = DesktopThemeData.highContrastLight();
      expect(theme.isDark, false);
      expect(theme.colors, DesktopColorScheme.highContrastLight);
    });

    test('highContrastDark factory creates correct theme', () {
      final theme = DesktopThemeData.highContrastDark();
      expect(theme.isDark, true);
      expect(theme.colors, DesktopColorScheme.highContrastDark);
    });

    test('highContrastLight toMaterialTheme works', () {
      final theme = DesktopThemeData.highContrastLight();
      final materialTheme = theme.toMaterialTheme();
      expect(materialTheme, isA<ThemeData>());
    });

    test('highContrastDark toMaterialTheme works', () {
      final theme = DesktopThemeData.highContrastDark();
      final materialTheme = theme.toMaterialTheme();
      expect(materialTheme, isA<ThemeData>());
    });

    testWidgets('DesktopApp with highContrast uses high-contrast themes', (tester) async {
      await tester.pumpWidget(
        DesktopApp(
          highContrast: true,
          home: Builder(
            builder: (context) {
              final colors = DesktopTheme.of(context).colors;
              return MaterialApp(
                home: Scaffold(
                  body: Text('bg: ${colors.surface}'),
                ),
              );
            },
          ),
        ),
      );
      expect(find.textContaining('bg:'), findsOneWidget);
    });
  });
}
