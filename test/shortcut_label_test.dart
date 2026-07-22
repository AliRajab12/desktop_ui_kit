import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

void main() {
  group('DesktopShortcutLabel', () {
    Widget buildApp(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: DesktopTheme(
            data: DesktopThemeData.light(),
            child: child,
          ),
        ),
      );
    }

    testWidgets('renders single key', (tester) async {
      await tester.pumpWidget(buildApp(
        DesktopShortcutLabel.keys(
          keys: [LogicalKeyboardKey.keyA],
        ),
      ));
      expect(find.textContaining('A'), findsOneWidget);
    });

    testWidgets('renders key combination with separator', (tester) async {
      await tester.pumpWidget(buildApp(
        DesktopShortcutLabel.keys(
          keys: [
            LogicalKeyboardKey.control,
            LogicalKeyboardKey.keyS,
          ],
        ),
      ));
      expect(find.byType(DesktopShortcutLabel), findsOneWidget);
      expect(find.text('+'), findsOneWidget);
    });

    testWidgets('renders modifier keys', (tester) async {
      await tester.pumpWidget(buildApp(
        DesktopShortcutLabel.keys(
          keys: [
            LogicalKeyboardKey.control,
            LogicalKeyboardKey.alt,
            LogicalKeyboardKey.delete,
          ],
        ),
      ));
      // Should render 3 key badges + 2 separators
      expect(find.text('Ctrl'), findsOneWidget);
      expect(find.text('Alt'), findsOneWidget);
      expect(find.text('Del'), findsOneWidget);
    });

    testWidgets('renders with custom colors', (tester) async {
      await tester.pumpWidget(buildApp(
        DesktopShortcutLabel.keys(
          keys: [LogicalKeyboardKey.keyS],
          color: Colors.red,
          backgroundColor: Colors.blue,
        ),
      ));
      expect(find.byType(DesktopShortcutLabel), findsOneWidget);
    });

    testWidgets('renders LogicalKeySet shortcut', (tester) async {
      await tester.pumpWidget(buildApp(
        DesktopShortcutLabel(
          shortcut: LogicalKeySet.fromSet({
            LogicalKeyboardKey.control,
            LogicalKeyboardKey.keyZ,
          }),
        ),
      ));
      expect(find.text('+'), findsOneWidget);
      expect(find.text('Z'), findsOneWidget);
    });
  });
}
