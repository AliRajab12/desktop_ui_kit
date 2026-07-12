import 'package:flutter/material.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  String _selectedTab = 'tab1';
  final List<DesktopTab> _tabs = [
    const DesktopTab(id: 'tab1', label: 'main.dart', icon: Icons.code),
    const DesktopTab(id: 'tab2', label: 'styles.css', icon: Icons.palette),
    const DesktopTab(id: 'tab3', label: 'README.md', icon: Icons.description),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;

    return Column(
      children: [
        _buildToolbar(),
        Expanded(
          child: DesktopSplitPanel(
            first: _buildPanelGroup(),
            second: _buildEditorArea(colors),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return DesktopToolbar(
      items: const [
        DesktopToolbarItem.button(icon: Icons.add, tooltip: 'New File'),
        DesktopToolbarItem.button(icon: Icons.folder_open, tooltip: 'Open'),
        DesktopToolbarItem.button(icon: Icons.save, tooltip: 'Save'),
        DesktopToolbarItem.separator(),
        DesktopToolbarItem.button(icon: Icons.undo, tooltip: 'Undo'),
        DesktopToolbarItem.button(icon: Icons.redo, tooltip: 'Redo'),
        DesktopToolbarItem.spacer(),
        DesktopToolbarItem.button(icon: Icons.search, tooltip: 'Search'),
        DesktopToolbarItem.button(icon: Icons.settings, tooltip: 'Settings'),
      ],
    );
  }

  Widget _buildPanelGroup() {
    return DesktopPanelGroup(
      panels: [
        PanelDefinition(id: 'explorer', title: 'Explorer', icon: Icons.folder, child: const _FileTree()),
        PanelDefinition(id: 'search', title: 'Search', icon: Icons.search, child: const _SearchPanel()),
      ],
      position: DesktopDockPosition.left,
      initialSize: 220,
    );
  }

  Widget _buildEditorArea(DesktopColorScheme colors) {
    return Column(
      children: [
        DesktopTabBar(
          tabs: _tabs,
          selectedId: _selectedTab,
          onSelect: (id) => setState(() => _selectedTab = id),
          onClose: _closeTab,
          onReorder: _reorderTab,
        ),
        Expanded(
          child: DesktopTabView(
            selectedId: _selectedTab,
            tabs: {for (final t in _tabs) t.id: DesktopTabContent(child: _CodeView(fileName: t.label))},
          ),
        ),
      ],
    );
  }

  void _closeTab(String id) {
    setState(() {
      _tabs.removeWhere((t) => t.id == id);
      if (_selectedTab == id && _tabs.isNotEmpty) _selectedTab = _tabs.first.id;
    });
  }

  void _reorderTab(int oldIndex, int newIndex) {
    setState(() {
      final tab = _tabs.removeAt(oldIndex);
      _tabs.insert(newIndex, tab);
    });
  }
}

class _FileTree extends StatelessWidget {
  const _FileTree();

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;

    return ListView(
      padding: const EdgeInsets.all(DesktopTokens.spaceXs),
      children: [
        _treeItem(Icons.folder, 'lib', colors, typography, 0),
        _treeItem(Icons.folder, 'src', colors, typography, 1),
        _treeItem(Icons.code, 'main.dart', colors, typography, 2),
        _treeItem(Icons.code, 'app.dart', colors, typography, 2),
        _treeItem(Icons.folder, 'widgets', colors, typography, 2),
        _treeItem(Icons.code, 'button.dart', colors, typography, 3),
        _treeItem(Icons.code, 'dialog.dart', colors, typography, 3),
        _treeItem(Icons.folder, 'test', colors, typography, 1),
        _treeItem(Icons.code, 'main_test.dart', colors, typography, 2),
        _treeItem(Icons.description, 'pubspec.yaml', colors, typography, 0),
        _treeItem(Icons.description, 'README.md', colors, typography, 0),
      ],
    );
  }

  Widget _treeItem(IconData icon, String name, DesktopColorScheme c, DesktopTextStyle t, int depth) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(left: DesktopTokens.spaceXs + (depth * 16.0), top: DesktopTokens.spaceXxs, bottom: DesktopTokens.spaceXxs),
        child: Row(children: [
          Icon(icon, size: 14, color: name.endsWith('.dart') ? c.accent : c.textSecondary),
          const SizedBox(width: DesktopTokens.spaceXs),
          Text(name, style: t.caption.copyWith(color: c.textPrimary)),
        ]),
      ),
    );
  }
}

class _SearchPanel extends StatelessWidget {
  const _SearchPanel();

  @override
  Widget build(BuildContext context) {
    final typography = DesktopTheme.of(context).typography;
    final colors = DesktopTheme.of(context).colors;

    return Padding(
      padding: const EdgeInsets.all(DesktopTokens.spaceSm),
      child: Column(
        children: [
          const DesktopTextField(label: 'Search', hint: 'Search files...', prefixIcon: Icons.search),
          const SizedBox(height: DesktopTokens.spaceSm),
          Expanded(
            child: Center(child: Text('No results', style: typography.caption.copyWith(color: colors.textDisabled))),
          ),
        ],
      ),
    );
  }
}

class _CodeView extends StatelessWidget {
  final String fileName;
  const _CodeView({required this.fileName});

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;

    return Container(
      padding: const EdgeInsets.all(DesktopTokens.spaceLg),
      color: colors.surfaceContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.code, size: 14, color: colors.accent),
            const SizedBox(width: DesktopTokens.spaceXs),
            Text(fileName, style: typography.label.copyWith(color: colors.textPrimary)),
          ]),
          const SizedBox(height: DesktopTokens.spaceMd),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(DesktopTokens.spaceMd),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
                border: Border.all(color: colors.border),
              ),
              child: Text(
                "import 'package:flutter/material.dart';\n\nvoid main() {\n  runApp(MyApp());\n}",
                style: typography.code.copyWith(color: colors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
