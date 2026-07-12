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

  group('DesktopTextField', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopTextField(label: 'Username'),
      ));
      expect(find.text('Username'), findsOneWidget);
    });

    testWidgets('shows hint text', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopTextField(hint: 'Enter value'),
      ));
      expect(find.text('Enter value'), findsOneWidget);
    });

    testWidgets('calls onChanged when text changes', (tester) async {
      String? changed;
      await tester.pumpWidget(buildTestApp(
        DesktopTextField(onChanged: (v) => changed = v),
      ));
      await tester.enterText(find.byType(TextField), 'hello');
      expect(changed, 'hello');
    });

    testWidgets('shows error message', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopTextField(error: 'Required field'),
      ));
      expect(find.text('Required field'), findsOneWidget);
    });

    testWidgets('shows helper text', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopTextField(helper: 'Help text'),
      ));
      expect(find.text('Help text'), findsOneWidget);
    });
  });

  group('DesktopDropdown', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopDropdown<String>(
          label: 'Country',
          options: [],
        ),
      ));
      expect(find.text('Country'), findsOneWidget);
    });

    testWidgets('shows hint when no value selected', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopDropdown<String>(
          hint: 'Select...',
          options: [],
        ),
      ));
      expect(find.text('Select...'), findsOneWidget);
    });

    testWidgets('shows selected value', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopDropdown<String>(
          value: 'us',
          options: [
            DropdownOption(value: 'us', label: 'United States'),
          ],
        ),
      ));
      expect(find.text('United States'), findsOneWidget);
    });
  });

  group('DesktopCheckbox', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopCheckbox(
          value: false,
          label: 'Enable',
        ),
      ));
      expect(find.text('Enable'), findsOneWidget);
    });

    testWidgets('calls onChanged when tapped', (tester) async {
      bool? value = false;
      await tester.pumpWidget(buildTestApp(
        DesktopCheckbox(
          value: value,
          onChanged: (v) => value = v,
        ),
      ));
      await tester.tap(find.byType(DesktopCheckbox));
      expect(value, true);
    });

    testWidgets('shows check icon when checked', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopCheckbox(
          value: true,
          label: 'Checked',
        ),
      ));
      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });

  group('DesktopRadio', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopRadio<bool>(
          value: true,
          groupValue: false,
          label: 'Option A',
        ),
      ));
      expect(find.text('Option A'), findsOneWidget);
    });

    testWidgets('calls onChanged when tapped', (tester) async {
      bool? selected;
      await tester.pumpWidget(buildTestApp(
        DesktopRadio<bool>(
          value: true,
          groupValue: false,
          onChanged: (v) => selected = v,
        ),
      ));
      await tester.tap(find.byType(DesktopRadio<bool>));
      expect(selected, true);
    });
  });

  group('DesktopSwitch', () {
    testWidgets('renders label', (tester) async {
      await tester.pumpWidget(buildTestApp(
        const DesktopSwitch(
          value: false,
          label: 'Dark mode',
        ),
      ));
      expect(find.text('Dark mode'), findsOneWidget);
    });

    testWidgets('calls onChanged when tapped', (tester) async {
      bool value = false;
      await tester.pumpWidget(buildTestApp(
        DesktopSwitch(
          value: value,
          onChanged: (v) => value = v,
        ),
      ));
      await tester.tap(find.byType(DesktopSwitch));
      expect(value, true);
    });

    testWidgets('does not call onChanged when disabled', (tester) async {
      bool value = false;
      await tester.pumpWidget(buildTestApp(
        DesktopSwitch(
          value: value,
          disabled: true,
          onChanged: (v) => value = v,
        ),
      ));
      await tester.tap(find.byType(DesktopSwitch));
      expect(value, false);
    });
  });
}
