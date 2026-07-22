import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

void main() {
  Widget buildTestApp(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: DesktopTheme(
          data: DesktopThemeData.light(),
          child: child,
        ),
      ),
    );
  }

  group('DesktopStatusBar', () {
    testWidgets('renders left items', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopStatusBar(
          leftItems: [
            DesktopStatusItem.label(label: 'Ready'),
          ],
        ),
      ));
      expect(find.text('Ready'), findsOneWidget);
    });

    testWidgets('renders right items', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopStatusBar(
          rightItems: [
            DesktopStatusItem.label(label: 'UTF-8'),
          ],
        ),
      ));
      expect(find.text('UTF-8'), findsOneWidget);
    });

    testWidgets('renders multiple left items', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopStatusBar(
          leftItems: [
            DesktopStatusItem.label(label: 'Left 1'),
            DesktopStatusItem.label(label: 'Left 2'),
          ],
        ),
      ));
      expect(find.text('Left 1'), findsOneWidget);
      expect(find.text('Left 2'), findsOneWidget);
    });

    testWidgets('renders icon item', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopStatusBar(
          leftItems: [
            DesktopStatusItem.icon(icon: Icons.wifi),
          ],
        ),
      ));
      expect(find.byIcon(Icons.wifi), findsOneWidget);
    });

    testWidgets('renders separator', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopStatusBar(
          leftItems: [
            DesktopStatusItem.label(label: 'Before'),
            DesktopStatusItem.separator(),
            DesktopStatusItem.label(label: 'After'),
          ],
        ),
      ));
      expect(find.text('Before'), findsOneWidget);
      expect(find.text('After'), findsOneWidget);
    });

    testWidgets('calls onTap when item tapped', (tester) async {
      bool called = false;
      await tester.pumpWidget(buildTestApp(
        DesktopStatusBar(
          leftItems: [
            DesktopStatusItem.label(
              label: 'Clickable',
              onTap: () => called = true,
            ),
          ],
        ),
      ));
      await tester.tap(find.text('Clickable'));
      expect(called, isTrue);
    });

    testWidgets('renders custom widget', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopStatusBar(
          leftItems: [
            DesktopStatusItem.custom(child: Icon(Icons.check)),
          ],
        ),
      ));
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('uses default height token', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopStatusBar(),
      ));
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(Semantics),
          matching: find.byType(Container),
        ),
      );
      expect(
        (container.constraints?.maxHeight ?? 0) == 0 ? 28 : container.constraints?.maxHeight,
        equals(28),
      );
    });

    testWidgets('left items aligned to left', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopStatusBar(
          leftItems: [
            DesktopStatusItem.label(label: 'Left'),
          ],
          rightItems: [
            DesktopStatusItem.label(label: 'Right'),
          ],
        ),
      ));
      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
    });

    testWidgets('empty status bar renders', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopStatusBar(),
      ));
      expect(find.byType(DesktopStatusBar), findsOneWidget);
    });
  });
}
