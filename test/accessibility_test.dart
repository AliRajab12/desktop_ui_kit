import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

void main() {
  Widget wrapInApp(Widget child) {
    return MaterialApp(
      home: DesktopTheme(
        data: DesktopThemeData.light(),
        child: Scaffold(body: child),
      ),
    );
  }

  group('DesktopSemantics', () {
    testWidgets('wraps child with Semantics widget', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopSemantics(
          label: 'My widget',
          child: Text('Hello'),
        ),
      ));

      expect(find.byType(Semantics), findsWidgets);
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('passes label to Semantics', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopSemantics(
          label: 'My label',
          child: Text('Content'),
        ),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasLabel = semanticsList.any((s) => s.properties.label == 'My label');
      expect(hasLabel, true);
    });

    testWidgets('passes button property to Semantics', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopSemantics(
          button: true,
          label: 'Submit',
          child: Text('Submit'),
        ),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasButton = semanticsList.any((s) => s.properties.button == true);
      expect(hasButton, true);
    });

    testWidgets('passes toggled property', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopSemantics(
          toggled: true,
          child: Text('Toggle'),
        ),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasToggled = semanticsList.any((s) => s.properties.toggled == true);
      expect(hasToggled, true);
    });

    testWidgets('passes checked property', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopSemantics(
          checked: true,
          child: Text('Check'),
        ),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasChecked = semanticsList.any((s) => s.properties.checked == true);
      expect(hasChecked, true);
    });

    testWidgets('passes header property', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopSemantics(
          isHeader: true,
          child: Text('Title'),
        ),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasHeader = semanticsList.any((s) => s.properties.header == true);
      expect(hasHeader, true);
    });

    testWidgets('passes link property', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopSemantics(
          isLink: true,
          child: Text('Link'),
        ),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasLink = semanticsList.any((s) => s.properties.link == true);
      expect(hasLink, true);
    });

    testWidgets('passes selected property', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopSemantics(
          selected: true,
          child: Text('Tab'),
        ),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasSelected = semanticsList.any((s) => s.properties.selected == true);
      expect(hasSelected, true);
    });

    testWidgets('passes expanded property', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopSemantics(
          expanded: true,
          child: Text('Tree'),
        ),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasExpanded = semanticsList.any((s) => s.properties.expanded == true);
      expect(hasExpanded, true);
    });

    testWidgets('passes liveRegion property', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopSemantics(
          liveRegion: true,
          child: Text('Status'),
        ),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasLiveRegion = semanticsList.any((s) => s.properties.liveRegion == true);
      expect(hasLiveRegion, true);
    });

    testWidgets('passes value property', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopSemantics(
          value: '50%',
          child: Text('Progress'),
        ),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasValue = semanticsList.any((s) => s.properties.value == '50%');
      expect(hasValue, true);
    });
  });

  group('DesktopReduceMotion', () {
    testWidgets('provides reduceMotion=true to descendants', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopReduceMotion(
          reduceMotion: true,
          child: _ReduceMotionReader(),
        ),
      ));
      expect(find.text('reduce:true'), findsOneWidget);
    });

    testWidgets('provides reduceMotion=false to descendants', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopReduceMotion(
          reduceMotion: false,
          child: _ReduceMotionReader(),
        ),
      ));
      expect(find.text('reduce:false'), findsOneWidget);
    });

    testWidgets('returns false when not in tree', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const _ReduceMotionReader(),
      ));
      expect(find.text('reduce:false'), findsOneWidget);
    });
  });

  group('DesktopFocusIndicator', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopFocusIndicator(
          child: Text('Focusable'),
        ),
      ));
      expect(find.text('Focusable'), findsOneWidget);
    });

    testWidgets('contains Focus widget', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopFocusIndicator(
          child: Text('Focusable'),
        ),
      ));
      expect(find.byType(Focus), findsWidgets);
    });
  });

  group('Widget semantics integration', () {
    testWidgets('DesktopButton wraps with Semantics', (tester) async {
      await tester.pumpWidget(wrapInApp(
        DesktopButton(label: 'Save', onPressed: () {}),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasButton = semanticsList.any((s) => s.properties.button == true);
      expect(hasButton, true);
    });

    testWidgets('DesktopSwitch wraps with Semantics toggled', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopSwitch(value: true, label: 'Toggle'),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasToggled = semanticsList.any((s) => s.properties.toggled == true);
      expect(hasToggled, true);
    });

    testWidgets('DesktopCheckbox wraps with Semantics checked', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopCheckbox(value: true, label: 'Check'),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasChecked = semanticsList.any((s) => s.properties.checked == true);
      expect(hasChecked, true);
    });

    testWidgets('DesktopDialog wraps with Semantics', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopDialog(
          title: 'Alert',
          content: Text('Message'),
          actions: [],
        ),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasLabel = semanticsList.any((s) => s.properties.label == 'Alert');
      expect(hasLabel, true);
    });

    testWidgets('DesktopMenuBar wraps with Semantics', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopMenuBar(groups: [DesktopMenuGroup('File', [])]),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasLabel = semanticsList.any((s) => s.properties.label == 'Menu bar');
      expect(hasLabel, true);
    });

    testWidgets('DesktopToolbar wraps with Semantics', (tester) async {
      await tester.pumpWidget(wrapInApp(
        const DesktopToolbar(items: []),
      ));

      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasLabel = semanticsList.any((s) => s.properties.label == 'Toolbar');
      expect(hasLabel, true);
    });
  });
}

class _ReduceMotionReader extends StatelessWidget {
  const _ReduceMotionReader();

  @override
  Widget build(BuildContext context) {
    final reduce = DesktopReduceMotion.of(context);
    return Text('reduce:$reduce');
  }
}
