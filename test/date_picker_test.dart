import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: DesktopTheme(
        data: DesktopThemeData.light(),
        child: child,
      ),
    ),
  );
}

void main() {
  group('DesktopDatePicker', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopDatePicker(label: 'Due Date'),
      ));
      expect(find.text('Due Date'), findsOneWidget);
    });

    testWidgets('shows hint when no date selected', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopDatePicker(hint: 'Pick a date'),
      ));
      expect(find.text('Pick a date'), findsOneWidget);
    });

    testWidgets('shows formatted selected date', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopDatePicker(selectedDate: DateTime(2026, 7, 15)),
      ));
      expect(find.text('2026-07-15'), findsOneWidget);
    });

    testWidgets('opens calendar popup on tap', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopDatePicker(),
      ));
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      expect(find.text('Mo'), findsOneWidget);
      expect(find.text('Tu'), findsOneWidget);
    });

    testWidgets('shows current month name in popup', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopDatePicker(),
      ));
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      final now = DateTime.now();
      final monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      expect(find.text('${monthNames[now.month - 1]} ${now.year}'), findsOneWidget);
    });

    testWidgets('fires onDateChanged when day is tapped', (tester) async {
      DateTime? selected;
      await tester.pumpWidget(wrapWithTheme(
        DesktopDatePicker(
          onDateChanged: (date) => selected = date,
        ),
      ));
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      expect(selected, isNotNull);
      expect(selected!.day, 15);
    });

    testWidgets('navigates to next month', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopDatePicker(),
      ));
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      final now = DateTime.now();
      final nextMonth = now.month == 12 ? 1 : now.month + 1;
      final nextYear = now.month == 12 ? now.year + 1 : now.year;
      final monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text('${monthNames[nextMonth - 1]} $nextYear'), findsOneWidget);
    });

    testWidgets('navigates to previous month', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopDatePicker(),
      ));
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      final now = DateTime.now();
      final prevMonth = now.month == 1 ? 12 : now.month - 1;
      final prevYear = now.month == 1 ? now.year - 1 : now.year;
      final monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(find.text('${monthNames[prevMonth - 1]} $prevYear'), findsOneWidget);
    });

    testWidgets('navigates to next year', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopDatePicker(),
      ));
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      final now = DateTime.now();
      final monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      await tester.tap(find.byIcon(Icons.keyboard_double_arrow_right));
      await tester.pumpAndSettle();
      expect(find.text('${monthNames[now.month - 1]} ${now.year + 1}'), findsOneWidget);
    });

    testWidgets('navigates to previous year', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopDatePicker(),
      ));
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      final now = DateTime.now();
      final monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      await tester.tap(find.byIcon(Icons.keyboard_double_arrow_left));
      await tester.pumpAndSettle();
      expect(find.text('${monthNames[now.month - 1]} ${now.year - 1}'), findsOneWidget);
    });

    testWidgets('closes popup on Escape key', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopDatePicker(),
      ));
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      expect(find.text('Mo'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Mo'), findsNothing);
    });

    testWidgets('does not open popup when disabled', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopDatePicker(disabled: true),
      ));
      await tester.tap(find.byIcon(Icons.calendar_today));
      await tester.pumpAndSettle();
      expect(find.text('Mo'), findsNothing);
    });

    testWidgets('shows calendar icon in field', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopDatePicker(),
      ));
      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('shows dropdown arrow icon in field', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopDatePicker(),
      ));
      expect(find.byIcon(Icons.arrow_drop_down), findsOneWidget);
    });
  });
}
