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

  group('DesktopBreadcrumb', () {
    testWidgets('renders all items', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopBreadcrumb(
          items: [
            DesktopBreadcrumbItem(label: 'Home'),
            DesktopBreadcrumbItem(label: 'Docs'),
            DesktopBreadcrumbItem(label: 'file.txt'),
          ],
        ),
      ));
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Docs'), findsOneWidget);
      expect(find.text('file.txt'), findsOneWidget);
    });

    testWidgets('shows default separator', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopBreadcrumb(
          items: [
            DesktopBreadcrumbItem(label: 'A'),
            DesktopBreadcrumbItem(label: 'B'),
          ],
        ),
      ));
      expect(find.text('>'), findsOneWidget);
    });

    testWidgets('shows custom separator', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopBreadcrumb(
          separator: '/',
          items: [
            DesktopBreadcrumbItem(label: 'A'),
            DesktopBreadcrumbItem(label: 'B'),
          ],
        ),
      ));
      expect(find.text('/'), findsOneWidget);
    });

    testWidgets('calls onTap when item tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildTestApp(
        DesktopBreadcrumb(
          items: [
            DesktopBreadcrumbItem(
              label: 'Click me',
              onTap: () => tapped = true,
            ),
          ],
        ),
      ));
      await tester.tap(find.text('Click me'));
      expect(tapped, isTrue);
    });

    testWidgets('shows icon when provided', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopBreadcrumb(
          items: [
            DesktopBreadcrumbItem(label: 'Home', icon: Icons.home),
          ],
        ),
      ));
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('collapses with maxItems', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopBreadcrumb(
          maxItems: 3,
          items: [
            DesktopBreadcrumbItem(label: 'A'),
            DesktopBreadcrumbItem(label: 'B'),
            DesktopBreadcrumbItem(label: 'C'),
            DesktopBreadcrumbItem(label: 'D'),
            DesktopBreadcrumbItem(label: 'E'),
          ],
        ),
      ));
      expect(find.text('A'), findsOneWidget);
      expect(find.text('...'), findsOneWidget);
      expect(find.text('E'), findsOneWidget);
    });

    testWidgets('single item renders', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopBreadcrumb(
          items: [
            DesktopBreadcrumbItem(label: 'Only'),
          ],
        ),
      ));
      expect(find.text('Only'), findsOneWidget);
    });

    testWidgets('empty items renders', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopBreadcrumb(items: []),
      ));
      expect(find.byType(DesktopBreadcrumb), findsOneWidget);
    });

    testWidgets('accessibility semantics present', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopBreadcrumb(
          items: [
            DesktopBreadcrumbItem(label: 'A'),
          ],
        ),
      ));
      expect(find.byType(Semantics), findsWidgets);
    });
  });
}
