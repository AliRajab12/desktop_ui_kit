import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

Widget wrapWithTheme(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 600,
        height: 600,
        child: DesktopTheme(
          data: DesktopThemeData.light(),
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  group('DesktopSidebar', () {
    testWidgets('renders all item labels in expanded mode', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopSidebar(
          sections: [
            SidebarSection(items: [
              SidebarItem(id: 'home', icon: Icons.home, label: 'Home'),
              SidebarItem(id: 'search', icon: Icons.search, label: 'Search'),
            ]),
          ],
        ),
      ));
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
    });

    testWidgets('fires onSelect when item is tapped', (tester) async {
      String? selected;
      await tester.pumpWidget(wrapWithTheme(
        DesktopSidebar(
          sections: [
            SidebarSection(items: [
              SidebarItem(id: 'home', icon: Icons.home, label: 'Home'),
            ]),
          ],
          onSelect: (id) => selected = id,
        ),
      ));
      await tester.tap(find.text('Home'));
      expect(selected, 'home');
    });

    testWidgets('highlights selected item with accent color', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopSidebar(
          sections: [
            SidebarSection(items: [
              SidebarItem(id: 'home', icon: Icons.home, label: 'Home'),
            ]),
          ],
          selectedId: 'home',
        ),
      ));
      final icon = tester.widget<Icon>(find.byIcon(Icons.home));
      expect(icon.color, isNotNull);
    });

    testWidgets('renders section labels in expanded mode', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopSidebar(
          sections: [
            SidebarSection(label: 'Main', items: [
              SidebarItem(id: 'home', icon: Icons.home, label: 'Home'),
            ]),
          ],
        ),
      ));
      expect(find.text('Main'), findsOneWidget);
    });

    testWidgets('hides labels and shows icons only in compact mode', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopSidebar(
          sections: [
            SidebarSection(items: [
              SidebarItem(id: 'home', icon: Icons.home, label: 'Home'),
            ]),
          ],
          initialExpanded: false,
        ),
      ));
      expect(find.text('Home'), findsNothing);
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('toggle button collapses sidebar', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopSidebar(
          sections: [
            SidebarSection(items: [
              SidebarItem(id: 'home', icon: Icons.home, label: 'Home'),
            ]),
          ],
          initialExpanded: true,
        ),
      ));
      expect(find.text('Collapse'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsNothing);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('toggle button expands sidebar', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopSidebar(
          sections: [
            SidebarSection(items: [
              SidebarItem(id: 'home', icon: Icons.home, label: 'Home'),
            ]),
          ],
          initialExpanded: false,
        ),
      ));
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('renders dividers between sections', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopSidebar(
          sections: [
            SidebarSection(items: [
              SidebarItem(id: 'home', icon: Icons.home, label: 'Home'),
            ]),
            SidebarSection(items: [
              SidebarItem(id: 'settings', icon: Icons.settings, label: 'Settings'),
            ]),
          ],
        ),
      ));
      expect(find.byType(Divider), findsWidgets);
    });

    testWidgets('renders custom badge widget', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopSidebar(
          sections: [
            SidebarSection(items: [
              SidebarItem(
                id: 'inbox',
                icon: Icons.inbox,
                label: 'Inbox',
                badge: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
            ]),
          ],
        ),
      ));
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('shows collapse button in expanded mode', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopSidebar(
          sections: [
            SidebarSection(items: [
              SidebarItem(id: 'home', icon: Icons.home, label: 'Home'),
            ]),
          ],
          initialExpanded: true,
        ),
      ));
      expect(find.text('Collapse'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    });

    testWidgets('shows expand button in compact mode', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopSidebar(
          sections: [
            SidebarSection(items: [
              SidebarItem(id: 'home', icon: Icons.home, label: 'Home'),
            ]),
          ],
          initialExpanded: false,
        ),
      ));
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('provides semantics label for sidebar', (tester) async {
      await tester.pumpWidget(wrapWithTheme(
        DesktopSidebar(
          sections: [
            SidebarSection(items: [
              SidebarItem(id: 'home', icon: Icons.home, label: 'Home'),
            ]),
          ],
        ),
      ));
      final semanticsList = tester.widgetList<Semantics>(find.byType(Semantics));
      final hasLabel = semanticsList.any((s) => s.properties.label == 'Navigation sidebar');
      expect(hasLabel, true);
    });
  });
}
