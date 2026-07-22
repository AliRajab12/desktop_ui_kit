import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

void main() {
  Widget buildTestMenu(List<DesktopContextMenuItem> items) {
    return MaterialApp(
      home: Scaffold(
        body: DesktopTheme(
          data: DesktopThemeData.light(),
          child: Builder(
            builder: (context) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                DesktopContextMenu.show(
                  context,
                  position: Offset.zero,
                  items: items,
                );
              },
              child: const SizedBox(width: 200, height: 200),
            ),
          ),
        ),
      ),
    );
  }

  group('DesktopContextMenu', () {
    testWidgets('shows menu items', (tester) async {
      await tester.pumpWidget(buildTestMenu([
        const DesktopContextMenuItem(label: 'Copy'),
        const DesktopContextMenuItem(label: 'Paste'),
      ]));
      await tester.pumpAndSettle();
      // Tap at center of screen to trigger GestureDetector
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Paste'), findsOneWidget);
    });

    testWidgets('calls onPressed when item tapped', (tester) async {
      bool called = false;
      await tester.pumpWidget(buildTestMenu([
        DesktopContextMenuItem(
          label: 'Action',
          onPressed: () => called = true,
        ),
      ]));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Action'));
      await tester.pumpAndSettle();
      expect(called, isTrue);
    });

    testWidgets('renders divider', (tester) async {
      await tester.pumpWidget(buildTestMenu([
        const DesktopContextMenuItem(label: 'Cut'),
        const DesktopContextMenuItem.divider(),
        const DesktopContextMenuItem(label: 'Paste'),
      ]));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      expect(find.text('Cut'), findsOneWidget);
      expect(find.text('Paste'), findsOneWidget);
    });

    testWidgets('shows icon when provided', (tester) async {
      await tester.pumpWidget(buildTestMenu([
        const DesktopContextMenuItem(
          label: 'Copy',
          icon: Icons.copy,
        ),
      ]));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets('shows shortcut hint', (tester) async {
      await tester.pumpWidget(buildTestMenu([
        const DesktopContextMenuItem(
          label: 'Copy',
          shortcut: 'Ctrl+C',
        ),
      ]));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      expect(find.text('Ctrl+C'), findsOneWidget);
    });

    testWidgets('disabled item not tappable', (tester) async {
      bool called = false;
      await tester.pumpWidget(buildTestMenu([
        DesktopContextMenuItem(
          label: 'Disabled',
          disabled: true,
          onPressed: () => called = true,
        ),
      ]));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();
      expect(called, isFalse);
    });

    testWidgets('closes on tap outside', (tester) async {
      await tester.pumpWidget(buildTestMenu([
        const DesktopContextMenuItem(label: 'Item'),
      ]));
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(100, 100));
      await tester.pumpAndSettle();
      expect(find.text('Item'), findsOneWidget);
      await tester.tapAt(const Offset(500, 500));
      await tester.pumpAndSettle();
      expect(find.text('Item'), findsNothing);
    });
  });
}
