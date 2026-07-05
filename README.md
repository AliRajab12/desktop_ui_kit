# desktop_ui_kit

[![pub package](https://img.shields.io/pub/v/desktop_ui_kit.svg)](https://pub.dev/packages/desktop_ui_kit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub](https://img.shields.io/badge/GitHub-AliRajab12-blue?logo=github)](https://github.com/AliRajab12/desktop_ui_kit)

A comprehensive, platform-adaptive desktop widget library for Flutter.

**Native OS conventions. Keyboard-first. Fully accessible.**

Targets Windows (Fluent Design), macOS (Human Interface Guidelines), and Linux (GNOME/GTK) from a single codebase.

---

## Features

- **🎨 Platform-Adaptive Theming** — Design tokens, light/dark/high-contrast, auto-detects platform fonts (Segoe UI, SF Pro, Cantarell)
- **🧩 Desktop Widgets** — Button, DataTable, TreeView, SplitPanel, MenuBar, Dialog, CommandPalette
- **⌨️ Keyboard-First** — Shortcuts, focus management, accessible by design
- **🖥️ Desktop-Convenient** — Status bar, toolbars, panel layouts, window management primitives
- **♿ Accessible** — Full Semantics tree on every widget, high-contrast mode support

---

## Installation

```yaml
dependencies:
  desktop_ui_kit: ^0.1.0
```

---

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:desktop_ui_kit/desktop_ui_kit.dart';

void main() {
  runApp(const DesktopApp(home: MyHomePage()));
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);

    return Scaffold(
      body: Column(
        children: [
          DesktopMenuBar(groups: [
            DesktopMenuGroup('File', [
              DesktopMenuEntry(label: 'Open', onPressed: () {}),
              DesktopMenuEntry(label: 'Save', onPressed: () {}),
            ]),
          ]),
          Expanded(
            child: Center(
              child: DesktopButton(
                label: 'Hello Desktop',
                icon: Icons.desktop_windows,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Widgets

| Widget | Description |
|---|---|
| `DesktopButton` | Primary, secondary, ghost, danger variants with loading state |
| `DesktopDataTable` | Sortable columns, selectable rows, resizable headers |
| `DesktopTreeView` | Expandable tree with icons, selection, custom depth |
| `DesktopSplitPanel` | Horizontal or vertical draggable splitter |
| `DesktopMenuBar` | Native-style top menu bar with groups |
| `DesktopDialog` | Modal dialog with title bar, content, and action bar |
| `DesktopCommandPalette` | VS Code-style fuzzy-search command palette |
| `DesktopApp` | Root widget setting up theme and platform defaults |

---

## Theming

### Design Tokens

```dart
DesktopTokens.spaceMd   // 12
DesktopTokens.radiusLg  // 6
DesktopTokens.iconSm    // 16
DesktopTokens.elevation(2)
```

### Color Schemes

```dart
DesktopColorScheme.light
DesktopColorScheme.dark
```

### Typography

```dart
final typography = DesktopTextStyle.platformAdaptive(colorScheme: colorScheme);
typography.heading1  // 32px bold, platform font family
typography.body      // 14px regular
typography.code      // Monospace stack
```

---

## Platform Support

| Platform | Status |
|---|---|
| Windows | ✅ |
| macOS | ✅ |
| Linux | ✅ |
| Android | ❌ (mobile not in scope) |
| iOS | ❌ (mobile not in scope) |
| Web | ⚠️ (limited) |

---

## Contact

Created by **Ali Rajab** — [alirajab.dev@gmail.com](mailto:alirajab.dev@gmail.com)

## License

MIT
