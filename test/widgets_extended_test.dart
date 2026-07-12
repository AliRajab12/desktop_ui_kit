import 'package:flutter/material.dart';
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
  group('DesktopSplitPanel', () {
    testWidgets('renders both children', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const SizedBox(
          height: 300,
          width: 800,
          child: DesktopSplitPanel(
            first: Text('Left'),
            second: Text('Right'),
          ),
        ),
      ));
      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
    });

    testWidgets('renders vertical split', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const SizedBox(
          height: 800,
          width: 600,
          child: DesktopSplitPanel(
            direction: SplitDirection.vertical,
            first: Text('Top'),
            second: Text('Bottom'),
          ),
        ),
      ));
      expect(find.text('Top'), findsOneWidget);
      expect(find.text('Bottom'), findsOneWidget);
    });
  });

  group('DesktopMenuBar', () {
    testWidgets('renders menu groups', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopMenuBar(groups: [
          DesktopMenuGroup('File', [
            DesktopMenuEntry(label: 'New', onPressed: () {}),
            DesktopMenuEntry(label: 'Open', onPressed: () {}),
          ]),
          DesktopMenuGroup('Edit', [
            DesktopMenuEntry(label: 'Copy', onPressed: () {}),
          ]),
        ]),
      ));
      expect(find.text('File'), findsOneWidget);
      expect(find.text('Edit'), findsOneWidget);
    });
  });

  group('DesktopCommandPalette', () {
    testWidgets('renders search field and entries', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopCommandPalette(
          entries: [
            CommandPaletteEntry(id: '1', title: 'Save File', action: () {}),
            CommandPaletteEntry(id: '2', title: 'Open File', action: () {}),
          ],
        ),
      ));
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Save File'), findsOneWidget);
      expect(find.text('Open File'), findsOneWidget);
    });

    testWidgets('filters entries on text input', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopCommandPalette(
          entries: [
            CommandPaletteEntry(id: '1', title: 'Save File', action: () {}),
            CommandPaletteEntry(id: '2', title: 'Open File', action: () {}),
            CommandPaletteEntry(id: '3', title: 'Close Tab', action: () {}),
          ],
        ),
      ));
      await tester.enterText(find.byType(TextField), 'save');
      await tester.pump();
      expect(find.text('Save File'), findsOneWidget);
      expect(find.text('Open File'), findsNothing);
    });

    testWidgets('shows no results message when filter matches nothing', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopCommandPalette(
          entries: [
            CommandPaletteEntry(id: '1', title: 'Save', action: () {}),
          ],
        ),
      ));
      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pump();
      expect(find.text('No results found'), findsOneWidget);
    });
  });

  group('DesktopInputDecorator', () {
    test('resolveBorderColor returns danger when hasError', () {
      final colors = DesktopColorScheme.light;
      expect(
        DesktopInputDecorator.resolveBorderColor(colors: colors, hasError: true, focused: false, disabled: false),
        colors.danger,
      );
    });

    test('resolveBorderColor returns borderFocused when focused', () {
      final colors = DesktopColorScheme.light;
      expect(
        DesktopInputDecorator.resolveBorderColor(colors: colors, hasError: false, focused: true, disabled: false),
        colors.borderFocused,
      );
    });

    test('resolveBorderColor returns borderDisabled when disabled', () {
      final colors = DesktopColorScheme.light;
      expect(
        DesktopInputDecorator.resolveBorderColor(colors: colors, hasError: false, focused: false, disabled: true),
        colors.borderDisabled,
      );
    });

    test('resolveBorderColor returns border by default', () {
      final colors = DesktopColorScheme.light;
      expect(
        DesktopInputDecorator.resolveBorderColor(colors: colors, hasError: false, focused: false, disabled: false),
        colors.border,
      );
    });

    testWidgets('buildLabel returns null when label is null', (tester) async {
      final result = DesktopInputDecorator.buildLabel(null, false, DesktopColorScheme.light, DesktopTextStyle.platformAdaptive(colorScheme: const ColorScheme.light()));
      expect(result, isNull);
    });

    testWidgets('buildLabel returns widget when label provided', (tester) async {
      final result = DesktopInputDecorator.buildLabel('Email', false, DesktopColorScheme.light, DesktopTextStyle.platformAdaptive(colorScheme: const ColorScheme.light()));
      expect(result, isNotNull);
    });

    testWidgets('buildErrorText returns null when error is null', (tester) async {
      final result = DesktopInputDecorator.buildErrorText(null, DesktopTextStyle.platformAdaptive(colorScheme: const ColorScheme.light()), DesktopColorScheme.light);
      expect(result, isNull);
    });

    testWidgets('buildHelperText returns null when helper is null', (tester) async {
      final result = DesktopInputDecorator.buildHelperText(null, false, DesktopTextStyle.platformAdaptive(colorScheme: const ColorScheme.light()), DesktopColorScheme.light);
      expect(result, isNull);
    });

    testWidgets('buildHelperText returns null when hasError', (tester) async {
      final result = DesktopInputDecorator.buildHelperText('Help', true, DesktopTextStyle.platformAdaptive(colorScheme: const ColorScheme.light()), DesktopColorScheme.light);
      expect(result, isNull);
    });
  });

  group('DesktopFormControl', () {
    testWidgets('renders label and control', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopFormControl(
          onTap: null,
          disabled: false,
          label: 'My Control',
          control: Icon(Icons.check),
        ),
      ));
      expect(find.text('My Control'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        DesktopFormControl(
          onTap: () => tapped = true,
          disabled: false,
          control: const Icon(Icons.check),
        ),
      ));
      await tester.tap(find.byType(DesktopFormControl));
      expect(tapped, true);
    });
  });

  group('DesktopResizableDivider', () {
    testWidgets('renders horizontal divider', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 100,
          child: DesktopResizableDivider(
            isHorizontal: true,
            isDragging: false,
            colors: DesktopColorScheme.light,
            onDragUpdate: (_) {},
            onDragStart: () {},
            onDragEnd: () {},
          ),
        ),
      ));
      expect(find.byType(DesktopResizableDivider), findsOneWidget);
    });

    testWidgets('renders vertical divider', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          width: 100,
          child: DesktopResizableDivider(
            isHorizontal: false,
            isDragging: false,
            colors: DesktopColorScheme.light,
            onDragUpdate: (_) {},
            onDragStart: () {},
            onDragEnd: () {},
          ),
        ),
      ));
      expect(find.byType(DesktopResizableDivider), findsOneWidget);
    });
  });

  group('DesktopApp', () {
    testWidgets('renders home widget', (tester) async {
      await tester.pumpWidget(
        const DesktopApp(home: Text('App Home')),
      );
      expect(find.text('App Home'), findsOneWidget);
    });

    testWidgets('provides DesktopTheme data', (tester) async {
      await tester.pumpWidget(
        DesktopApp(
          home: Builder(
            builder: (context) {
              final theme = DesktopTheme.of(context);
              return Text('isDark: ${theme.colors.isDark}');
            },
          ),
        ),
      );
      expect(find.text('isDark: false'), findsOneWidget);
    });
  });
}
