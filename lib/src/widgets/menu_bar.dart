import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';

class DesktopMenuEntry {
  final String label;
  final String? shortcut;
  final IconData? icon;
  final VoidCallback? onPressed;
  final List<DesktopMenuEntry>? children;
  final bool divider;

  const DesktopMenuEntry({
    required this.label,
    this.shortcut,
    this.icon,
    this.onPressed,
    this.children,
    this.divider = false,
  });

  const DesktopMenuEntry.divider()
      : label = '',
        shortcut = null,
        icon = null,
        onPressed = null,
        children = null,
        divider = true;
}

class DesktopMenuGroup {
  final String label;
  final List<DesktopMenuEntry> items;
  const DesktopMenuGroup(this.label, this.items);
}

class DesktopMenuBar extends StatefulWidget {
  final List<DesktopMenuGroup> groups;

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
