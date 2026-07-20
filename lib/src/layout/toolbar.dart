import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';

/// A single item in a [DesktopToolbar].
///
/// Can be a button, separator, or spacer.
class DesktopToolbarItem {
  /// The item type.
  final DesktopToolbarItemType type;

  /// Icon for button items.
  final IconData? icon;

  /// Tooltip text for button items.
  final String? tooltip;

  /// Callback for button items.
  final VoidCallback? onPressed;

  /// Whether the button is disabled.
  final bool disabled;

  /// Custom widget to render instead of default button.
  final Widget? child;

  /// Creates a toolbar item.
  const DesktopToolbarItem({
    this.type = DesktopToolbarItemType.button,
    this.icon,
    this.tooltip,
    this.onPressed,
    this.disabled = false,
    this.child,
  });

  /// Creates a button item.
  const DesktopToolbarItem.button({
    required IconData this.icon,
    this.tooltip,
    this.onPressed,
    this.disabled = false,
  }) : type = DesktopToolbarItemType.button, child = null;

  /// Creates a separator line.
  const DesktopToolbarItem.separator()
      : type = DesktopToolbarItemType.separator,
        icon = null,
        tooltip = null,
        onPressed = null,
        disabled = false,
        child = null;

  /// Creates a flexible spacer.
  const DesktopToolbarItem.spacer()
      : type = DesktopToolbarItemType.spacer,
        icon = null,
        tooltip = null,
        onPressed = null,
        disabled = false,
        child = null;

  /// Creates a custom widget item.
  const DesktopToolbarItem.custom({required Widget this.child})
      : type = DesktopToolbarItemType.custom,
        icon = null,
        tooltip = null,
        onPressed = null,
        disabled = false;
}

/// The type of toolbar item.
enum DesktopToolbarItemType {
  /// A clickable icon button.
  button,

  /// A vertical separator line.
  separator,

  /// A flexible spacer that fills available space.
  spacer,

  /// A custom widget.
  custom,
}

/// A horizontal action bar for grouping related controls.
///
/// Commonly used for action buttons, tool selections, or filter controls.
/// Supports buttons, separators, spacers, and custom widgets.
///
/// Example:
/// ```dart
/// DesktopToolbar(
///   items: [
///     DesktopToolbarItem.button(icon: Icons.save, tooltip: 'Save', onPressed: () {}),
///     DesktopToolbarItem.button(icon: Icons.undo, tooltip: 'Undo', onPressed: () {}),
///     DesktopToolbarItem.separator(),
///     DesktopToolbarItem.spacer(),
///     DesktopToolbarItem.button(icon: Icons.settings, tooltip: 'Settings'),
///   ],
/// )
/// ```
class DesktopToolbar extends StatefulWidget {
  /// The items to display in the toolbar.
  final List<DesktopToolbarItem> items;

  /// Height of the toolbar. Defaults to [DesktopTokens.toolbarHeight].
  final double height;

  /// Background color override.
  final Color? backgroundColor;

  /// Padding around the toolbar content.
  final EdgeInsetsGeometry? padding;

  /// Creates a desktop toolbar.
  const DesktopToolbar({
    super.key,
    required this.items,
    this.height = DesktopTokens.toolbarHeight,
    this.backgroundColor,
    this.padding,
  });

  @override
  State<DesktopToolbar> createState() => _DesktopToolbarState();
}

class _DesktopToolbarState extends State<DesktopToolbar> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;

    return Semantics(
      label: 'Toolbar',
      child: Container(
        height: widget.height,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceSm),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colors.surface,
        border: Border(
          bottom: BorderSide(color: colors.border, width: DesktopTokens.borderNormal),
        ),
      ),
      child: Row(
        children: List.generate(widget.items.length, (index) {
          final item = widget.items[index];
          return _buildItem(item, index, colors);
        }),
      ),
    ),
    );
  }

  Widget _buildItem(DesktopToolbarItem item, int index, DesktopColorScheme colors) {
    return switch (item.type) {
      DesktopToolbarItemType.button => _ToolbarButton(
          item: item,
          isHovered: index == _hoveredIndex,
          colors: colors,
          onHoverChanged: (hovering) {
            setState(() => _hoveredIndex = hovering ? index : null);
          },
        ),
      DesktopToolbarItemType.separator => _ToolbarSeparator(colors: colors),
      DesktopToolbarItemType.spacer => const Spacer(),
      DesktopToolbarItemType.custom => item.child ?? const SizedBox.shrink(),
    };
  }
}

class _ToolbarButton extends StatelessWidget {
  final DesktopToolbarItem item;
  final bool isHovered;
  final DesktopColorScheme colors;
  final ValueChanged<bool> onHoverChanged;

  const _ToolbarButton({
    required this.item,
    required this.isHovered,
    required this.colors,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = item.disabled || item.onPressed == null;
    final iconColor = disabled ? colors.textDisabled : colors.textPrimary;

    return Tooltip(
      message: item.tooltip ?? '',
      waitDuration: DesktopTokens.tooltipDelay,
      child: MouseRegion(
        onEnter: (_) => onHoverChanged(true),
        onExit: (_) => onHoverChanged(false),
        cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: disabled ? null : item.onPressed,
          child: Container(
            width: DesktopTokens.toolbarHeight - DesktopTokens.toolbarButtonPadding,
            height: DesktopTokens.toolbarHeight - DesktopTokens.toolbarButtonPadding,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: isHovered && !disabled
                  ? colors.surfaceHover
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(DesktopTokens.radiusSm),
            ),
            child: Icon(
              item.icon,
              size: DesktopTokens.iconMd,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolbarSeparator extends StatelessWidget {
  final DesktopColorScheme colors;

  const _ToolbarSeparator({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: DesktopTokens.toolbarSeparatorHeight,
      margin: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceXs),
      color: colors.border,
    );
  }
}
