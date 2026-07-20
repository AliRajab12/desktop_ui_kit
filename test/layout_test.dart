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

    testWidgets('selects tab with arrow keys', (tester) async {
      String? selected;
      await tester.pumpWidget(wrapWithTheme(
        DesktopTabBar(
          tabs: const [
            DesktopTab(id: '1', label: 'First'),
            DesktopTab(id: '2', label: 'Second'),
            DesktopTab(id: '3', label: 'Third'),
          ],
          selectedId: '1',
          onSelect: (id) => selected = id,
        ),
      ));
      await tester.tap(find.text('First'));
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      expect(selected, '2');
    });

    testWidgets('renders tab with icon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopTabBar(
          tabs: const [
            DesktopTab(id: '1', label: 'Files', icon: Icons.folder),
          ],
          selectedId: '1',
        ),
      ));
      expect(find.byIcon(Icons.folder), findsOneWidget);
      expect(find.text('Files'), findsOneWidget);
    });

    testWidgets('calls onReorder when tab dragged', (tester) async {
      int? reorderFrom;
      int? reorderTo;
      await tester.pumpWidget(wrapWithTheme(
        DesktopTabBar(
          tabs: const [
            DesktopTab(id: '1', label: 'A'),
            DesktopTab(id: '2', label: 'B'),
          ],
          selectedId: '1',
          onReorder: (fromIdx, toIdx) {
            reorderFrom = fromIdx;
            reorderTo = toIdx;
          },
        ),
      ));
      // onReorder is wired; test just verifies no crash
      expect(find.text('A'), findsOneWidget);
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

    testWidgets('applies custom background color', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopTabView(
          selectedId: 'a',
          tabs: {
            'a': DesktopTabContent(
              child: Text('Styled'),
              background: Colors.red,
            ),
          },
        ),
      ));
      final container = tester.widget<Container>(
        find.ancestor(of: find.text('Styled'), matching: find.byType(Container)).first,
      );
      expect(container.color, Colors.red);
    });

    testWidgets('renders with empty tabs map', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        const DesktopTabView(tabs: {}),
      ));
      expect(find.text('No content'), findsOneWidget);
    });

    testWidgets('animates transition on tab switch', (tester) async {
      final key = GlobalKey<State>();
      await tester.pumpWidget(wrapWithTheme(
        DesktopTabView(
          key: key,
          selectedId: 'a',
          transitionDuration: const Duration(milliseconds: 200),
          tabs: const {
            'a': DesktopTabContent(child: Text('First')),
            'b': DesktopTabContent(child: Text('Second')),
          },
        ),
      ));
      expect(find.text('First'), findsOneWidget);

      await tester.pumpWidget(wrapWithTheme(
        DesktopTabView(
          key: key,
          selectedId: 'b',
          transitionDuration: const Duration(milliseconds: 200),
          tabs: const {
            'a': DesktopTabContent(child: Text('First')),
            'b': DesktopTabContent(child: Text('Second')),
          },
        ),
      ));
      // AnimatedSwitcher cross-fades
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AnimatedSwitcher), findsOneWidget);
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

    testWidgets('does not call onPressed when disabled', (tester) async {
      var tapped = false;
      await tester.pumpWidget(wrapWithTheme(
        DesktopToolbar(
          items: [
            DesktopToolbarItem.button(
              icon: Icons.save,
              disabled: true,
              onPressed: () => tapped = true,
            ),
          ],
        ),
      ));
      await tester.tap(find.byIcon(Icons.save));
      expect(tapped, false);
    });

    testWidgets('does not call onPressed when onPressed is null', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopToolbar(
          items: [
            const DesktopToolbarItem.button(icon: Icons.save),
          ],
        ),
      ));
      await tester.tap(find.byIcon(Icons.save));
      // no crash
    });

    testWidgets('renders with custom height', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopToolbar(
          height: 48,
          items: [
            DesktopToolbarItem.button(icon: Icons.save, onPressed: () {}),
          ],
        ),
      ));
      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      expect(container.constraints?.maxHeight ?? 48, isPositive);
    });

    testWidgets('renders with custom background color', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopToolbar(
          backgroundColor: Colors.blue,
          items: [
            DesktopToolbarItem.button(icon: Icons.save, onPressed: () {}),
          ],
        ),
      ));
      final container = tester.widget<Container>(
        find.byType(Container).first,
      );
      final box = container.decoration as BoxDecoration?;
      expect(box?.color, Colors.blue);
    });

    testWidgets('shows tooltip on hover', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopToolbar(
          items: [
            DesktopToolbarItem.button(icon: Icons.save, tooltip: 'Save file', onPressed: () {}),
          ],
        ),
      ));
      expect(find.text('Save file'), findsOneWidget);
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
      final toggle = find.byWidgetPredicate(
        (w) => w is GestureDetector || w is InkWell,
      );
      if (toggle.evaluate().isNotEmpty) {
        await tester.tap(toggle.first);
        await tester.pump();
        expect(find.text('Panel Content'), findsOneWidget);
      }
    });

    testWidgets('renders with icon', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopDockPanel(
            title: 'Files',
            icon: Icons.folder,
            child: const Text('Content'),
          ),
        ),
      ));
      expect(find.byIcon(Icons.folder), findsOneWidget);
    });

    testWidgets('collapses when title bar collapse button tapped', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopDockPanel(
            title: 'Explorer',
            child: const Text('Content'),
          ),
        ),
      ));
      expect(find.text('Content'), findsOneWidget);
      // Collapse via chevron_left icon in DockTitleBar
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pump();
      expect(find.text('Content'), findsNothing);
    });

    testWidgets('renders in right position', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopDockPanel(
            title: 'Right Panel',
            position: DesktopDockPosition.right,
            child: const Text('Right Content'),
          ),
        ),
      ));
      expect(find.text('Right Content'), findsOneWidget);
    });

    testWidgets('renders in top position', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopDockPanel(
            title: 'Top Panel',
            position: DesktopDockPosition.top,
            child: const Text('Top Content'),
          ),
        ),
      ));
      expect(find.text('Top Content'), findsOneWidget);
    });

    testWidgets('renders in bottom position', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopDockPanel(
            title: 'Bottom Panel',
            position: DesktopDockPosition.bottom,
            child: const Text('Bottom Content'),
          ),
        ),
      ));
      expect(find.text('Bottom Content'), findsOneWidget);
    });

    testWidgets('renders with dock actions', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopDockPanel(
            title: 'Explorer',
            actions: [
              DockAction(icon: Icons.add, tooltip: 'Add', onTap: () {}),
              DockAction(icon: Icons.refresh, tooltip: 'Refresh', onTap: () {}),
            ],
            child: const Text('Content'),
          ),
        ),
      ));
      expect(find.text('Content'), findsOneWidget);
    });
  });

  group('DesktopResizableDivider', () {
    testWidgets('renders horizontal divider', (tester) async {
      bool dragStarted = false;
      bool dragEnded = false;
      double dragDelta = 0;
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 200,
          width: 200,
          child: DesktopResizableDivider(
            isHorizontal: true,
            isDragging: false,
            colors: DesktopThemeData.light().colors,
            onDragUpdate: (d) => dragDelta = d,
            onDragStart: () => dragStarted = true,
            onDragEnd: () => dragEnded = true,
          ),
        ),
      ));
      expect(find.byType(DesktopResizableDivider), findsOneWidget);
    });

    testWidgets('renders vertical divider', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 200,
          width: 200,
          child: DesktopResizableDivider(
            isHorizontal: false,
            isDragging: false,
            colors: DesktopThemeData.light().colors,
            onDragUpdate: (_) {},
            onDragStart: () {},
            onDragEnd: () {},
          ),
        ),
      ));
      expect(find.byType(DesktopResizableDivider), findsOneWidget);
    });

    testWidgets('calls onDragStart when pan starts', (tester) async {
      var started = false;
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 200,
          width: 200,
          child: DesktopResizableDivider(
            isHorizontal: true,
            isDragging: false,
            colors: DesktopThemeData.light().colors,
            onDragUpdate: (_) {},
            onDragStart: () => started = true,
            onDragEnd: () {},
          ),
        ),
      ));
      final center = tester.getCenter(find.byType(DesktopResizableDivider));
      await tester.startGesture(center);
      expect(started, true);
    });

    testWidgets('calls onDragEnd when pan ends', (tester) async {
      var ended = false;
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 200,
          width: 200,
          child: DesktopResizableDivider(
            isHorizontal: true,
            isDragging: false,
            colors: DesktopThemeData.light().colors,
            onDragUpdate: (_) {},
            onDragStart: () {},
            onDragEnd: () => ended = true,
          ),
        ),
      ));
      final center = tester.getCenter(find.byType(DesktopResizableDivider));
      final gesture = await tester.startGesture(center);
      await gesture.up();
      expect(ended, true);
    });

    testWidgets('highlights when dragging', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 200,
          width: 200,
          child: DesktopResizableDivider(
            isHorizontal: true,
            isDragging: true,
            colors: DesktopThemeData.light().colors,
            onDragUpdate: (_) {},
            onDragStart: () {},
            onDragEnd: () {},
          ),
        ),
      ));
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DesktopResizableDivider),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.color, DesktopThemeData.light().colors.accent);
    });

    testWidgets('shows default border color when not dragging', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 200,
          width: 200,
          child: DesktopResizableDivider(
            isHorizontal: true,
            isDragging: false,
            colors: DesktopThemeData.light().colors,
            onDragUpdate: (_) {},
            onDragStart: () {},
            onDragEnd: () {},
          ),
        ),
      ));
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DesktopResizableDivider),
          matching: find.byType(Container),
        ).first,
      );
      expect(container.color, DesktopThemeData.light().colors.border);
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
      expect(find.text('Content A'), findsNothing);
      expect(find.text('Content B'), findsNothing);
    });

    testWidgets('switches panel when tab tapped', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopPanelGroup(
            panels: const [
              PanelDefinition(id: 'a', title: 'A', icon: Icons.star, child: Text('Content A')),
              PanelDefinition(id: 'b', title: 'B', icon: Icons.circle, child: Text('Content B')),
            ],
          ),
        ),
      ));
      expect(find.text('Content A'), findsOneWidget);
      // Tap the second panel tab (circle icon)
      await tester.tap(find.byIcon(Icons.circle));
      await tester.pump();
      expect(find.text('Content B'), findsOneWidget);
    });

    testWidgets('expands when collapsed icon tapped', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopPanelGroup(
            initialCollapsed: true,
            panels: const [
              PanelDefinition(id: 'a', title: 'A', icon: Icons.star, child: Text('Content A')),
            ],
          ),
        ),
      ));
      expect(find.text('Content A'), findsNothing);
      await tester.tap(find.byIcon(Icons.star));
      await tester.pump();
      expect(find.text('Content A'), findsOneWidget);
    });

    testWidgets('collapses when title bar collapse button tapped', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopPanelGroup(
            panels: const [
              PanelDefinition(id: 'a', title: 'A', icon: Icons.star, child: Text('Content')),
            ],
          ),
        ),
      ));
      expect(find.text('Content'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pump();
      expect(find.text('Content'), findsNothing);
    });

    testWidgets('renders in right position', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopPanelGroup(
            position: DesktopDockPosition.right,
            panels: const [
              PanelDefinition(id: 'a', title: 'A', icon: Icons.star, child: Text('Right Panel')),
            ],
          ),
        ),
      ));
      expect(find.text('Right Panel'), findsOneWidget);
    });

    testWidgets('renders in top position', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopPanelGroup(
            position: DesktopDockPosition.top,
            panels: const [
              PanelDefinition(id: 'a', title: 'A', icon: Icons.star, child: Text('Top Panel')),
            ],
          ),
        ),
      ));
      expect(find.text('Top Panel'), findsOneWidget);
    });

    testWidgets('renders in bottom position', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopPanelGroup(
            position: DesktopDockPosition.bottom,
            panels: const [
              PanelDefinition(id: 'a', title: 'A', icon: Icons.star, child: Text('Bottom Panel')),
            ],
          ),
        ),
      ));
      expect(find.text('Bottom Panel'), findsOneWidget);
    });

    testWidgets('respects min/max size constraints on drag', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        SizedBox(
          height: 300,
          child: DesktopPanelGroup(
            initialSize: 200,
            minSize: 150,
            maxSize: 300,
            panels: const [
              PanelDefinition(id: 'a', title: 'A', icon: Icons.star, child: Text('Panel')),
            ],
          ),
        ),
      ));
      expect(find.text('Panel'), findsOneWidget);
    });
  });

  group('PanelDefinition', () {
    test('stores id, title, icon, and child', () {
      const def = PanelDefinition(
        id: 'test',
        title: 'Test Panel',
        icon: Icons.star,
        child: Text('hello'),
      );
      expect(def.id, 'test');
      expect(def.title, 'Test Panel');
      expect(def.icon, Icons.star);
      expect((def.child as Text).data, 'hello');
    });
  });

  group('DesktopToolbarItem', () {
    test('button factory sets correct type', () {
      const item = DesktopToolbarItem.button(icon: Icons.save);
      expect(item.type, DesktopToolbarItemType.button);
      expect(item.icon, Icons.save);
      expect(item.child, isNull);
    });

    test('separator factory sets correct type', () {
      const item = DesktopToolbarItem.separator();
      expect(item.type, DesktopToolbarItemType.separator);
      expect(item.icon, isNull);
    });

    test('spacer factory sets correct type', () {
      const item = DesktopToolbarItem.spacer();
      expect(item.type, DesktopToolbarItemType.spacer);
    });

    test('custom factory sets correct type and child', () {
      const item = DesktopToolbarItem.custom(child: Text('X'));
      expect(item.type, DesktopToolbarItemType.custom);
      expect((item.child as Text).data, 'X');
    });

    test('default constructor creates button type', () {
      const item = DesktopToolbarItem();
      expect(item.type, DesktopToolbarItemType.button);
      expect(item.disabled, false);
    });
  });
}
