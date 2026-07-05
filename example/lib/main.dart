import 'package:flutter/material.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

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

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Scaffold(
      body: Column(
        children: [
          DesktopMenuBar(groups: [
            DesktopMenuGroup('File', [
              DesktopMenuEntry(label: 'New Project', shortcut: 'Ctrl+N', onPressed: () {}),
              DesktopMenuEntry(label: 'Open...', shortcut: 'Ctrl+O', onPressed: () {}),
              DesktopMenuEntry(label: 'Save', shortcut: 'Ctrl+S', onPressed: () {}),
              DesktopMenuEntry(label: 'Save As...', shortcut: 'Ctrl+Shift+S', onPressed: () {}),
              DesktopMenuEntry.divider(),
              DesktopMenuEntry(label: 'Exit', shortcut: 'Alt+F4', onPressed: () => showDialog(
                context: context,
                builder: (_) => DesktopDialog(
                  title: 'Exit',
                  content: const Text('Are you sure you want to exit?'),
                  actions: [
                    DesktopButton(
                      label: 'Cancel',
                      variant: DesktopButtonVariant.secondary,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    DesktopButton(
                      label: 'Exit',
                      variant: DesktopButtonVariant.danger,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              )),
            ]),
            DesktopMenuGroup('Edit', [
              DesktopMenuEntry(label: 'Undo', shortcut: 'Ctrl+Z', onPressed: () {}),
              DesktopMenuEntry(label: 'Redo', shortcut: 'Ctrl+Shift+Z', onPressed: () {}),
              DesktopMenuEntry.divider(),
              DesktopMenuEntry(label: 'Cut', shortcut: 'Ctrl+X', onPressed: () {}),
              DesktopMenuEntry(label: 'Copy', shortcut: 'Ctrl+C', onPressed: () {}),
              DesktopMenuEntry(label: 'Paste', shortcut: 'Ctrl+V', onPressed: () {}),
            ]),
            DesktopMenuGroup('View', [
              DesktopMenuEntry(label: 'Command Palette', shortcut: 'Ctrl+P', onPressed: () {
                DesktopCommandPalette.show(context, [
                  CommandPaletteEntry(
                    id: 'new',
                    title: 'New Project',
                    subtitle: 'Ctrl+N',
                    icon: Icons.add,
                    action: () {},
                  ),
                  CommandPaletteEntry(
                    id: 'open',
                    title: 'Open File',
                    subtitle: 'Ctrl+O',
                    icon: Icons.folder_open,
                    action: () {},
                  ),
                  CommandPaletteEntry(
                    id: 'save',
                    title: 'Save',
                    subtitle: 'Ctrl+S',
                    icon: Icons.save,
                    action: () {},
                  ),
                ]);
              }),
            ]),
            DesktopMenuGroup('Help', [
              DesktopMenuEntry(label: 'About', onPressed: () {}),
              DesktopMenuEntry(label: 'Documentation', onPressed: () {}),
            ]),
          ]),
          Expanded(
            child: DesktopSplitPanel(
              direction: SplitDirection.horizontal,
              initialRatio: 0.25,
              first: Container(
                color: colors.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Text('Explorer', style: typography.label),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: DesktopTreeView(
                        roots: [
                          TreeNode(
                            key: 'src',
                            label: 'src',
                            icon: Icons.folder,
                            initiallyExpanded: true,
                            children: [
                              TreeNode(key: 'main.dart', label: 'main.dart', icon: Icons.description),
                              TreeNode(key: 'app.dart', label: 'app.dart', icon: Icons.description),
                              TreeNode(
                                key: 'widgets',
                                label: 'widgets',
                                icon: Icons.folder,
                                children: [
                                  TreeNode(key: 'button.dart', label: 'button.dart', icon: Icons.description),
                                  TreeNode(key: 'dialog.dart', label: 'dialog.dart', icon: Icons.description),
                                ],
                              ),
                            ],
                          ),
                          TreeNode(
                            key: 'test',
                            label: 'test',
                            icon: Icons.folder,
                            children: [
                              TreeNode(key: 'widget_test.dart', label: 'widget_test.dart', icon: Icons.description),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              second: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: colors.surface,
                    child: Row(
                      children: [
                        Text('File Editor', style: typography.label),
                        const Spacer(),
                        DesktopButton(
                          label: 'Run',
                          icon: Icons.play_arrow,
                          variant: DesktopButtonVariant.primary,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        DesktopButton(
                          label: 'Build',
                          variant: DesktopButtonVariant.secondary,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.code, size: 48, color: colors.textTertiary),
                          const SizedBox(height: 16),
                          Text(
                            'desktop_ui_kit',
                            style: typography.heading3,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'A Flutter desktop UI kit for Windows, macOS & Linux',
                            style: typography.body,
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              DesktopButton(
                                label: 'Primary',
                                icon: Icons.star,
                                onPressed: () {},
                              ),
                              const SizedBox(width: 12),
                              DesktopButton(
                                label: 'Secondary',
                                variant: DesktopButtonVariant.secondary,
                                onPressed: () {},
                              ),
                              const SizedBox(width: 12),
                              DesktopButton(
                                label: 'Ghost',
                                variant: DesktopButtonVariant.ghost,
                                onPressed: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          DesktopButton(
                            label: 'Open Dialog',
                            variant: DesktopButtonVariant.secondary,
                            onPressed: () {
                              DesktopDialog.show(
                                context,
                                DesktopDialog(
                                  title: 'Example Dialog',
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const Text('This is an example dialog'),
                                      const SizedBox(height: 16),
                                      DesktopDataTable(
                                        columns: [
                                          DesktopColumn(
                                            header: 'Name',
                                            width: 120,
                                            sortable: true,
                                            cellBuilder: (v) => Text('$v'),
                                          ),
                                          DesktopColumn(
                                            header: 'Value',
                                            width: 80,
                                            sortable: true,
                                            cellBuilder: (v) => Text('$v'),
                                          ),
                                        ],
                                        rows: [
                                          {'Name': 'Alpha', 'Value': 100},
                                          {'Name': 'Beta', 'Value': 200},
                                          {'Name': 'Gamma', 'Value': 300},
                                        ],
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    DesktopButton(
                                      label: 'Cancel',
                                      variant: DesktopButtonVariant.secondary,
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                    DesktopButton(
                                      label: 'Confirm',
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
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
                Text('Ready', style: typography.caption),
                const Spacer(),
                Text('Ln 1, Col 1', style: typography.caption),
                const SizedBox(width: 16),
                Text('UTF-8', style: typography.caption),
                const SizedBox(width: 16),
                Text('Dart', style: typography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
