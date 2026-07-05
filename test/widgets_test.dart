import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

Widget wrapWithTheme(Widget child) {
  return DesktopTheme(
    data: DesktopThemeData.light(),
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('DesktopButton', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopButton(label: 'Click Me', onPressed: () {}),
      ));
      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('fires onPressed when tapped', (tester) async {
      var clicked = false;
      await tester.pumpWidget(wrapWithTheme(
        DesktopButton(label: 'Click', onPressed: () => clicked = true),
      ));
      await tester.tap(find.text('Click'));
      expect(clicked, true);
    });

    testWidgets('does not fire when disabled', (tester) async {
      var clicked = false;
      await tester.pumpWidget(wrapWithTheme(
        DesktopButton(label: 'Click', onPressed: null),
      ));
      // should not crash when tapping disabled button
      await tester.tap(find.text('Click'));
      expect(clicked, false);
    });
  });

  group('DesktopDialog', () {
    testWidgets('shows title and content', (tester) async {
      await tester.pumpWidget(
        DesktopTheme(
          data: DesktopThemeData.light(),
          child: MaterialApp(
            home: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  DesktopDialog.show(
                    context,
                    DesktopDialog(
                      title: 'Test Dialog',
                      content: const Text('Dialog body'),
                      actions: [
                        DesktopButton(
                          label: 'OK',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Test Dialog'), findsOneWidget);
      expect(find.text('Dialog body'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });
  });

  group('DesktopDataTable', () {
    testWidgets('renders columns and rows', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopDataTable(
            columns: [
              DesktopColumn(
                header: 'Name',
                sortable: true,
                cellBuilder: (v) => Text('$v'),
              ),
            ],
            rows: [
              {'Name': 'Alice'},
              {'Name': 'Bob'},
            ],
          ),
        ),
      ));
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });
  });

  group('DesktopTreeView', () {
    testWidgets('renders root nodes', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 200,
          child: DesktopTreeView(
            roots: [
              TreeNode(key: 'a', label: 'Node A'),
              TreeNode(key: 'b', label: 'Node B'),
            ],
          ),
        ),
      ));
      expect(find.text('Node A'), findsOneWidget);
      expect(find.text('Node B'), findsOneWidget);
    });
  });
}
