import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

void main() {
  group('DesktopThemeData.copyWith', () {
    test('returns a copy with no changes', () {
      final original = DesktopThemeData.light();
      final copy = original.copyWith();
      expect(copy.colors, original.colors);
      expect(copy.typography, original.typography);
      expect(copy.isDark, original.isDark);
    });

    test('overrides colors when provided', () {
      final original = DesktopThemeData.light();
      final newColors = DesktopColorScheme.light.copyWith(accent: Colors.red);
      final copy = original.copyWith(colors: newColors);
      expect(copy.colors.accent, Colors.red);
      expect(copy.isDark, false);
    });

    test('overrides typography when provided', () {
      final original = DesktopThemeData.light();
      const newTypo = DesktopTextStyle(
        heading1: TextStyle(fontSize: 40),
        heading2: TextStyle(fontSize: 32),
        heading3: TextStyle(fontSize: 24),
        heading4: TextStyle(fontSize: 22),
        heading5: TextStyle(fontSize: 18),
        heading6: TextStyle(fontSize: 16),
        bodyLarge: TextStyle(fontSize: 18),
        body: TextStyle(fontSize: 16),
        bodySmall: TextStyle(fontSize: 14),
        label: TextStyle(fontSize: 15),
        caption: TextStyle(fontSize: 13),
        overline: TextStyle(fontSize: 12),
        code: TextStyle(fontSize: 15),
      );
      final copy = original.copyWith(typography: newTypo);
      expect(copy.typography.heading1.fontSize, 40);
    });

    test('overrides isDark when provided', () {
      final original = DesktopThemeData.light();
      final copy = original.copyWith(isDark: true);
      expect(copy.isDark, true);
    });

    test('produces valid Material ThemeData', () {
      final original = DesktopThemeData.light();
      final copy = original.copyWith(
        isDark: true,
        colors: DesktopColorScheme.dark,
      );
      final material = copy.toMaterialTheme();
      expect(material.colorScheme.brightness, Brightness.dark);
    });
  });

  group('DesktopThemeOverride', () {
    testWidgets('provides overridden colors to descendants', (tester) async {
      final customColors = DesktopColorScheme.light.copyWith(
        accent: Colors.red,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: DesktopTheme(
            data: DesktopThemeData.light(),
            child: DesktopThemeOverride(
              colors: customColors,
              child: Builder(
                builder: (context) {
                  final colors = DesktopTheme.of(context).colors;
                  return Text('accent:${colors.accent == Colors.red}');
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('accent:true'), findsOneWidget);
    });

    testWidgets('preserves parent colors when no override given', (tester) async {
      final originalAccent = DesktopColorScheme.light.accent;

      await tester.pumpWidget(
        MaterialApp(
          home: DesktopTheme(
            data: DesktopThemeData.light(),
            child: DesktopThemeOverride(
              child: Builder(
                builder: (context) {
                  final colors = DesktopTheme.of(context).colors;
                  return Text('accent:${colors.accent == originalAccent}');
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('accent:true'), findsOneWidget);
    });

    testWidgets('overrides typography for subtree', (tester) async {
      const customTypo = DesktopTextStyle(
        heading1: TextStyle(fontSize: 99),
        heading2: TextStyle(fontSize: 32),
        heading3: TextStyle(fontSize: 24),
        heading4: TextStyle(fontSize: 22),
        heading5: TextStyle(fontSize: 18),
        heading6: TextStyle(fontSize: 16),
        bodyLarge: TextStyle(fontSize: 18),
        body: TextStyle(fontSize: 16),
        bodySmall: TextStyle(fontSize: 14),
        label: TextStyle(fontSize: 15),
        caption: TextStyle(fontSize: 13),
        overline: TextStyle(fontSize: 12),
        code: TextStyle(fontSize: 15),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: DesktopTheme(
            data: DesktopThemeData.light(),
            child: DesktopThemeOverride(
              typography: customTypo,
              child: Builder(
                builder: (context) {
                  final typo = DesktopTheme.of(context).typography;
                  return Text('size:${typo.heading1.fontSize}');
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('size:99.0'), findsOneWidget);
    });

    testWidgets('nested overrides use inner override values', (tester) async {
      final outerColors = DesktopColorScheme.light.copyWith(accent: Colors.red);
      final innerColors = DesktopColorScheme.light.copyWith(accent: Colors.blue);

      await tester.pumpWidget(
        MaterialApp(
          home: DesktopTheme(
            data: DesktopThemeData.light(),
            child: DesktopThemeOverride(
              colors: outerColors,
              child: DesktopThemeOverride(
                colors: innerColors,
                child: Builder(
                  builder: (context) {
                    final colors = DesktopTheme.of(context).colors;
                    return Text('accent:${colors.accent == Colors.blue}');
                  },
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('accent:true'), findsOneWidget);
    });

    testWidgets('outer override visible when inner has no colors', (tester) async {
      final outerColors = DesktopColorScheme.light.copyWith(accent: Colors.red);

      await tester.pumpWidget(
        MaterialApp(
          home: DesktopTheme(
            data: DesktopThemeData.light(),
            child: DesktopThemeOverride(
              colors: outerColors,
              child: DesktopThemeOverride(
                child: Builder(
                  builder: (context) {
                    final colors = DesktopTheme.of(context).colors;
                    return Text('accent:${colors.accent == Colors.red}');
                  },
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('accent:true'), findsOneWidget);
    });
  });

  group('DesktopApp', () {
    testWidgets('accepts lightColors override', (tester) async {
      await tester.pumpWidget(
        DesktopApp(
          themeMode: ThemeMode.light,
          lightColors: DesktopColorScheme.light.copyWith(accent: Colors.green),
          home: Builder(
            builder: (context) {
              final colors = DesktopTheme.of(context).colors;
              return Text('accent:${colors.accent == Colors.green}');
            },
          ),
        ),
      );

      expect(find.text('accent:true'), findsOneWidget);
    });
  });
}
