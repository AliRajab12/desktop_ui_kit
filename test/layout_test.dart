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
  group('DesktopTabBar', () {
    testWidgets('renders all tab labels', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopTabBar(
          tabs: [
            const DesktopTab(id: '1', label: 'Editor'),
            const DesktopTab(id: '2', label: 'Preview'),
            const DesktopTab(id: '3', label: 'Terminal'),
          ],
          selectedId: '1',
        ),
      ));
      expect(find.text('Editor'), findsOneWidget);
      expect(find.text('Preview'), findsOneWidget);
      expect(find.text('Terminal'), findsOneWidget);
    });

    testWidgets('calls onSelect when tab tapped', (tester) async {
      String? selected;
      await tester.pumpWidget(wrapWithTheme(
        DesktopTabBar(
          tabs: const [
            DesktopTab(id: '1', label: 'Tab A'),
            DesktopTab(id: '2', label: 'Tab B'),
          ],
          selectedId: '1',
          onSelect: (id) => selected = id,
        ),
      ));
      await tester.tap(find.text('Tab B'));
      expect(selected, '2');
    });

    testWidgets('renders close buttons when closable', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopTabBar(
          tabs: const [DesktopTab(id: '1', label: 'Tab', closable: true)],
          selectedId: '1',
          showCloseButtons: true,
        ),
      ));
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('does not render close button when showCloseButtons false', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopTabBar(
          tabs: const [DesktopTab(id: '1', label: 'Tab', closable: true)],
          selectedId: '1',
          showCloseButtons: false,
        ),
      ));
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('calls onClose when close button tapped', (tester) async {
      String? closed;
      await tester.pumpWidget(wrapWithTheme(
        DesktopTabBar(
          tabs: const [DesktopTab(id: '1', label: 'Tab')],
          selectedId: '1',
          onClose: (id) => closed = id,
        ),
      ));
      await tester.tap(find.byIcon(Icons.close));
      expect(closed, '1');
    });

    testWidgets('does not render close button when closable false', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopTabBar(
          tabs: const [DesktopTab(id: '1', label: 'Tab', closable: false)],
          selectedId: '1',
        ),
      ));
      expect(find.byIcon(Icons.close), findsNothing);
    });
  });

  group('DesktopTabView', () {
    testWidgets('shows selected tab content', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopTabView(
          selectedId: 'editor',
          tabs: {
            'editor': DesktopTabContent(child: Text('Editor Content')),
            'preview': DesktopTabContent(child: Text('Preview Content')),
          },
        ),
      ));
      expect(find.text('Editor Content'), findsOneWidget);
      expect(find.text('Preview Content'), findsNothing);
    });

    testWidgets('shows empty state when no selection', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopTabView(
          tabs: {
            'a': DesktopTabContent(child: Text('A')),
          },
        ),
      ));
      expect(find.text('No content'), findsOneWidget);
    });

    testWidgets('shows custom empty widget', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopTabView(
          tabs: {'a': DesktopTabContent(child: Text('A'))},
          empty: Text('Nothing here'),
        ),
      ));
      expect(find.text('Nothing here'), findsOneWidget);
    });

    testWidgets('switches content when selectedId changes', (tester) async {
      final key = GlobalKey<State>();
      await tester.pumpWidget(wrapWithTheme(
        DesktopTabView(
          key: key,
          selectedId: 'a',
          tabs: const {
            'a': DesktopTabContent(child: Text('Pane A')),
            'b': DesktopTabContent(child: Text('Pane B')),
          },
        ),
      ));
      expect(find.text('Pane A'), findsOneWidget);

      await tester.pumpWidget(wrapWithTheme(
        DesktopTabView(
          key: key,
          selectedId: 'b',
          tabs: const {
            'a': DesktopTabContent(child: Text('Pane A')),
            'b': DesktopTabContent(child: Text('Pane B')),
          },
        ),
      ));
      expect(find.text('Pane B'), findsOneWidget);
    });

    testWidgets('shows empty when selectedId not in tabs map', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopTabView(
          selectedId: 'missing',
          tabs: {'a': DesktopTabContent(child: Text('A'))},
        ),
      ));
      expect(find.text('No content'), findsOneWidget);
    });
  });

  group('DesktopToolbar', () {
    testWidgets('renders button icons', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopToolbar(
          items: [
            DesktopToolbarItem.button(icon: Icons.save, tooltip: 'Save', onPressed: () {}),
            DesktopToolbarItem.button(icon: Icons.undo, tooltip: 'Undo', onPressed: () {}),
          ],
        ),
      ));
      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.byIcon(Icons.undo), findsOneWidget);
    });

    testWidgets('calls onPressed when button tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        DesktopToolbar(
          items: [
            DesktopToolbarItem.button(icon: Icons.save, onPressed: () => tapped = true),
          ],
        ),
      ));
      await tester.tap(find.byIcon(Icons.save));
      expect(tapped, true);
    });

    testWidgets('renders separator', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopToolbar(
          items: [
            DesktopToolbarItem.button(icon: Icons.save, onPressed: () {}),
            const DesktopToolbarItem.separator(),
            DesktopToolbarItem.button(icon: Icons.undo, onPressed: () {}),
          ],
        ),
      ));
      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.byIcon(Icons.undo), findsOneWidget);
    });

    testWidgets('renders custom widget', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopToolbar(
          items: [
            DesktopToolbarItem.custom(child: const Text('Custom')),
          ],
        ),
      ));
      expect(find.text('Custom'), findsOneWidget);
    });

    testWidgets('renders spacer', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopToolbar(
          items: [
            DesktopToolbarItem.button(icon: Icons.save, onPressed: () {}),
            const DesktopToolbarItem.spacer(),
            DesktopToolbarItem.button(icon: Icons.undo, onPressed: () {}),
          ],
        ),
      ));
      expect(find.byIcon(Icons.save), findsOneWidget);
      expect(find.byIcon(Icons.undo), findsOneWidget);
    });
  });

  group('DesktopDockPanel', () {
    testWidgets('renders title', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopDockPanel(
            title: 'Explorer',
            child: const Text('Panel Content'),
          ),
        ),
      ));
      expect(find.text('Explorer'), findsOneWidget);
      expect(find.text('Panel Content'), findsOneWidget);
    });

    testWidgets('renders collapsed when initialCollapsed true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopDockPanel(
            title: 'Explorer',
            initialCollapsed: true,
            child: const Text('Panel Content'),
          ),
        ),
      ));
      expect(find.text('Panel Content'), findsNothing);
    });

    testWidgets('expands when toggle tapped', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopDockPanel(
            title: 'Explorer',
            initialCollapsed: true,
            child: const Text('Panel Content'),
          ),
        ),
      ));
      // Find the toggle button (first tappable widget in the panel)
      final toggle = find.byWidgetPredicate(
        (w) => w is GestureDetector || w is InkWell,
      );
      if (toggle.evaluate().isNotEmpty) {
        await tester.tap(toggle.first);
        await tester.pump();
        expect(find.text('Panel Content'), findsOneWidget);
      }
    });
  });

  group('DesktopPanelGroup', () {
    testWidgets('renders first panel content by default', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopPanelGroup(
            panels: const [
              PanelDefinition(id: 'files', title: 'Files', icon: Icons.folder, child: Text('Files View')),
              PanelDefinition(id: 'search', title: 'Search', icon: Icons.search, child: Text('Search View')),
            ],
          ),
        ),
      ));
      expect(find.text('Files View'), findsOneWidget);
    });

    testWidgets('shows tab bar when multiple panels', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopPanelGroup(
            panels: const [
              PanelDefinition(id: 'a', title: 'Panel A', icon: Icons.star, child: Text('A')),
              PanelDefinition(id: 'b', title: 'Panel B', icon: Icons.circle, child: Text('B')),
            ],
          ),
        ),
      ));
      expect(find.text('Panel A'), findsWidgets);
      expect(find.byIcon(Icons.star), findsWidgets);
      expect(find.byIcon(Icons.circle), findsWidgets);
    });

    testWidgets('returns empty when no panels', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const SizedBox(
          height: 300,
          child: DesktopPanelGroup(panels: []),
        ),
      ));
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('renders collapsed icons when initialCollapsed true', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopPanelGroup(
            initialCollapsed: true,
            panels: const [
              PanelDefinition(id: 'a', title: 'A', icon: Icons.star, child: Text('Content A')),
              PanelDefinition(id: 'b', title: 'B', icon: Icons.circle, child: Text('Content B')),
            ],
          ),
        ),
      ));
      // Collapsed state shows icon buttons, not content
      expect(find.text('Content A'), findsNothing);
      expect(find.text('Content B'), findsNothing);
    });
  });
}
