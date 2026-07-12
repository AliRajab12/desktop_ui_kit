import 'package:flutter/material.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';
import 'widgets_page.dart';
import 'forms_page.dart';
import 'layout_page.dart';

void main() {
  runApp(const MyDesktopApp());
}

class MyDesktopApp extends StatelessWidget {
  const MyDesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DesktopApp(
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;

    return Scaffold(
      body: Column(
        children: [
          _buildMenuBar(),
          Expanded(child: _buildCurrentPage()),
          _buildStatusBar(theme, colors),
        ],
      ),
    );
  }

  Widget _buildMenuBar() {
    return DesktopMenuBar(groups: [
      DesktopMenuGroup('File', [
        DesktopMenuEntry(label: 'New Project', shortcut: 'Ctrl+N', onPressed: () {}),
        DesktopMenuEntry(label: 'Open...', shortcut: 'Ctrl+O', onPressed: () {}),
        DesktopMenuEntry(label: 'Save', shortcut: 'Ctrl+S', onPressed: () {}),
        DesktopMenuEntry.divider(),
        DesktopMenuEntry(label: 'Exit', shortcut: 'Alt+F4', onPressed: () {}),
      ]),
      DesktopMenuGroup('Edit', [
        DesktopMenuEntry(label: 'Undo', shortcut: 'Ctrl+Z', onPressed: () {}),
        DesktopMenuEntry(label: 'Redo', shortcut: 'Ctrl+Shift+Z', onPressed: () {}),
      ]),
      DesktopMenuGroup('View', [
        DesktopMenuEntry(label: 'Widgets', shortcut: 'Ctrl+1', onPressed: () => setState(() => _tabIndex = 0)),
        DesktopMenuEntry(label: 'Forms', shortcut: 'Ctrl+2', onPressed: () => setState(() => _tabIndex = 1)),
        DesktopMenuEntry(label: 'Layout', shortcut: 'Ctrl+3', onPressed: () => setState(() => _tabIndex = 2)),
      ]),
      DesktopMenuGroup('Help', [
        DesktopMenuEntry(label: 'About', onPressed: () {}),
      ]),
    ]);
  }

  Widget _buildCurrentPage() {
    return switch (_tabIndex) {
      0 => const WidgetsPage(),
      1 => const FormsPage(),
      _ => const LayoutPage(),
    };
  }

  Widget _buildStatusBar(DesktopThemeData theme, DesktopColorScheme colors) {
    final labels = ['Widgets', 'Forms', 'Layout'];
    return Container(
      height: DesktopTokens.statusBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 14, color: colors.textTertiary),
          const SizedBox(width: 6),
          Text('Ready', style: theme.typography.caption),
          const Spacer(),
          Text(labels[_tabIndex], style: theme.typography.caption),
          const SizedBox(width: 16),
          Text('desktop_ui_kit v0.3.0', style: theme.typography.caption),
        ],
      ),
    );
  }
}
