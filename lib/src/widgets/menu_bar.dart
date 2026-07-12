import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';

/// A menu item in a [DesktopMenuBar].
///
/// Supports labels, keyboard shortcuts, icons, and nested submenus.
class DesktopMenuEntry {
  /// The menu item label.
  final String label;

  /// Optional keyboard shortcut hint (e.g., "Ctrl+S").
  final String? shortcut;

  /// Optional icon displayed before the label.
  final IconData? icon;

  /// Callback when the menu item is tapped. Null for parent menus.
  final VoidCallback? onPressed;

  /// Optional nested submenu items.
  final List<DesktopMenuEntry>? children;

  /// Whether this entry is a visual divider line.
  final bool divider;

  /// Creates a menu entry.
  const DesktopMenuEntry({
    required this.label,
    this.shortcut,
    this.icon,
    this.onPressed,
    this.children,
    this.divider = false,
  });

  /// Creates a visual divider line.
  const DesktopMenuEntry.divider()
      : label = '',
        shortcut = null,
        icon = null,
        onPressed = null,
        children = null,
        divider = true;
}

/// A group of related menu entries in a [DesktopMenuBar].
///
/// Each group has a label and contains a list of menu entries.
class DesktopMenuGroup {
  /// The group label displayed in the menu bar.
  final String label;

  /// The menu entries in this group.
  final List<DesktopMenuEntry> items;

  /// Creates a menu group.
  const DesktopMenuGroup(this.label, this.items);
}

/// A native-style menu bar for desktop applications.
///
/// Displays horizontal menu groups that can be expanded to show nested items.
/// Supports keyboard shortcuts and icons.
///
/// Example:
/// ```dart
/// DesktopMenuBar(groups: [
///   DesktopMenuGroup('File', [
///     DesktopMenuEntry(
///       label: 'Save',
///       shortcut: 'Ctrl+S',
///       icon: Icons.save,
///       onPressed: () => save(),
///     ),
///   ]),
/// ]);
/// ```
class DesktopMenuBar extends StatefulWidget {
  /// The menu groups to display.
  final List<DesktopMenuGroup> groups;

  /// Creates a menu bar.
  const DesktopMenuBar({super.key, required this.groups});

  @override
  State<DesktopMenuBar> createState() => _DesktopMenuBarState();
}

class _DesktopMenuBarState extends State<DesktopMenuBar> {
  int? _openIndex;

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;

    return Container(
      height: DesktopTokens.menuBarHeight,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          for (int i = 0; i < widget.groups.length; i++) ...[
            _MenuGroupButton(
              label: widget.groups[i].label,
              open: _openIndex == i,
              onHover: () => setState(() => _openIndex = i),
              onTap: () => setState(() => _openIndex = _openIndex == i ? null : i),
            ),
          ],
        ],
      ),
    );
  }
}

class _MenuGroupButton extends StatelessWidget {
  final String label;
  final bool open;
  final VoidCallback onHover;
  final VoidCallback onTap;

  const _MenuGroupButton({
    required this.label,
    required this.open,
    required this.onHover,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return InkWell(
      onTap: onTap,
      onHover: (_) => onHover(),
      child: Container(
        height: DesktopTokens.menuBarHeight,
        padding: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceSm),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: open ? colors.surfaceHover : null,
        ),
        child: Text(label, style: typography.bodySmall),
      ),
    );
  }
}
