# desktop_ui_kit

[![pub package](https://img.shields.io/pub/v/desktop_ui_kit.svg)](https://pub.dev/packages/desktop_ui_kit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub](https://img.shields.io/badge/GitHub-AliRajab12-blue?logo=github)](https://github.com/AliRajab12/desktop_ui_kit)

A comprehensive, platform-adaptive desktop widget library for Flutter.

**Native OS conventions. Keyboard-first. Fully accessible.**

Targets Windows (Fluent Design), macOS (Human Interface Guidelines), and Linux (GNOME/GTK) from a single codebase.

---

## Features

- **Platform-Adaptive Theming** — Design tokens, light/dark/high-contrast, auto-detects platform fonts (Segoe UI, SF Pro, Cantarell)
- **Desktop Widgets** — 17 widgets across form controls, layout, and core categories
- **Keyboard-First** — Shortcuts, focus management, accessible by design
- **Desktop-Convenient** — Status bar, toolbars, panel layouts, window management primitives
- **Accessible** — Full Semantics tree on every widget, high-contrast mode support
- **Zero Dependencies** — Flutter SDK only, no third-party packages

---

## Installation

```yaml
dependencies:
  desktop_ui_kit: ^0.3.0
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

### Form Controls

| Widget | Description |
|---|---|
| `DesktopTextField` | Labels, hints, prefix/suffix icons, validation states, obscure text |
| `DesktopDropdown` | Floating overlay, keyboard navigation, search, custom option builders |
| `DesktopCheckbox` | Tri-state with indeterminate support, check icon |
| `DesktopRadio` | Group selection with native styling |
| `DesktopSwitch` | Animated on/off toggle with smooth transitions |

### Layout

| Widget | Description |
|---|---|
| `DesktopTabBar` | Scrollable tabs with close buttons, drag reorder, keyboard nav (arrows, Ctrl+W) |
| `DesktopTabView` | Animated tab transitions, lazy loading, custom empty states |
| `DesktopToolbar` | Horizontal action bar with buttons, separators, spacers, custom widgets |
| `DesktopDockPanel` | Collapsible side panel with drag-to-resize and title bar actions |
| `DesktopPanelGroup` | Multi-panel container with tabbed switching and collapsed icons |

### Core

| Widget | Description |
|---|---|
| `DesktopButton` | Primary, secondary, ghost, danger variants with loading state |
| `DesktopDialog` | Modal dialog with title bar, content, and action bar |
| `DesktopDataTable` | Sortable columns, selectable rows, resizable headers |
| `DesktopTreeView` | Expandable tree with icons, selection, custom depth |
| `DesktopSplitPanel` | Horizontal or vertical draggable splitter |
| `DesktopMenuBar` | Native-style top menu bar with groups and keyboard shortcuts |
| `DesktopCommandPalette` | VS Code-style fuzzy-search command palette |

---

## Theming

### Design Tokens

```dart
DesktopTokens.spaceMd        // 12px
DesktopTokens.radiusLg       // 6px
DesktopTokens.iconSm         // 16px
DesktopTokens.inputHeight    // 32px
DesktopTokens.tooltipDelay   // 500ms
DesktopTokens.elevation(2)   // Shadow list
```

### Color Schemes

```dart
DesktopColorScheme.light
DesktopColorScheme.dark

// Custom:
final custom = DesktopColorScheme.light.copyWith(accent: Colors.red);
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
| Windows | Supported |
| macOS | Supported |
| Linux | Supported |
| Android | Not in scope |
| iOS | Not in scope |
| Web | Limited |

---

## Contact

Created by **Ali Rajab** — [alirajab.dev@gmail.com](mailto:alirajab.dev@gmail.com)

## License

MIT
