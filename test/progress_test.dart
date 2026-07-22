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

  group('DesktopProgress', () {
    testWidgets('renders determinate circular', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopProgress(value: 0.5),
      ));
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('renders indeterminate circular', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopProgress(),
      ));
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('renders determinate bar', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopProgress.bar(value: 0.7),
      ));
      expect(find.byType(FractionallySizedBox), findsOneWidget);
    });

    testWidgets('renders indeterminate bar', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopProgress.bar(),
      ));
      expect(find.byType(FractionallySizedBox), findsWidgets);
    });

    testWidgets('shows percentage label when showLabel true', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopProgress(value: 0.42, showLabel: true),
      ));
      expect(find.text('42%'), findsOneWidget);
    });

    testWidgets('shows bar percentage label', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopProgress.bar(value: 0.75, showLabel: true),
      ));
      expect(find.text('75%'), findsOneWidget);
    });

    testWidgets('full value shows 100%', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopProgress(value: 1.0, showLabel: true),
      ));
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('zero value shows 0%', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopProgress(value: 0.0, showLabel: true),
      ));
      expect(find.text('0%'), findsOneWidget);
    });

    testWidgets('accessibility semantics present', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopProgress(value: 0.5),
      ));
      expect(find.byType(Semantics), findsWidgets);
    });
  });
}
