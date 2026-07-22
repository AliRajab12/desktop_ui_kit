import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';

/// A context menu item.
///
/// Supports labels, icons, shortcuts, dividers, and nested submenus.
class DesktopContextMenuItem {
  /// The display text.
  final String label;

  /// Optional keyboard shortcut hint.
  final String? shortcut;

  /// Optional icon.
  final IconData? icon;

  /// Callback when tapped. Null for parent menus with children.
  final VoidCallback? onPressed;

  /// Nested submenu items.
  final List<DesktopContextMenuItem>? children;

  /// Whether this is a divider.
  final bool divider;

  /// Whether this item is disabled.
  final bool disabled;

  /// Creates a context menu item.
  const DesktopContextMenuItem({
    required this.label,
    this.shortcut,
    this.icon,
    this.onPressed,
    this.children,
    this.disabled = false,
  }) : divider = false;

  /// Creates a divider.
  const DesktopContextMenuItem.divider()
      : label = '',
        shortcut = null,
        icon = null,
        onPressed = null,
        children = null,
        divider = true,
        disabled = false;

  /// Whether this item has a submenu.
  bool get hasChildren => children != null && children!.isNotEmpty;
}

/// A right-click context menu overlay.
///
/// Shows a floating menu at the tap position with nested submenu support,
/// keyboard navigation, and desktop-native styling.
///
/// Example:
/// ```dart
/// GestureDetector(
///   onSecondaryTapDown: (details) {
///     DesktopContextMenu.show(
///       context,
///       position: details.globalPosition,
///       items: [
///         DesktopContextMenuItem(label: 'Copy', icon: Icons.copy, onPressed: () {}),
///         DesktopContextMenuItem.divider(),
///         DesktopContextMenuItem(label: 'Delete', icon: Icons.delete, onPressed: () {}),
///       ],
///     );
///   },
///   child: MyWidget(),
/// )
/// ```
class DesktopContextMenu {
  /// Shows a context menu at [position] with [items].
  static OverlayEntry show(
    BuildContext context, {
    required Offset position,
    required List<DesktopContextMenuItem> items,
  }) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ContextMenuOverlay(
        position: position,
        items: items,
        colors: colors,
        typography: typography,
        onClose: () => entry.remove(),
      ),
    );
    Overlay.of(context).insert(entry);
    return entry;
  }
}

class _ContextMenuOverlay extends StatefulWidget {
  final Offset position;
  final List<DesktopContextMenuItem> items;
  final VoidCallback onClose;
  final dynamic colors;
  final dynamic typography;

  const _ContextMenuOverlay({
    required this.position,
    required this.items,
    required this.onClose,
    required this.colors,
    required this.typography,
  });

  @override
  State<_ContextMenuOverlay> createState() => _ContextMenuOverlayState();
}

class _ContextMenuOverlayState extends State<_ContextMenuOverlay> {
  OverlayEntry? _submenuEntry;

  @override
  void dispose() {
    _submenuEntry?.remove();
    super.dispose();
  }

  void _closeAll() {
    _submenuEntry?.remove();
    _submenuEntry = null;
    widget.onClose();
  }

  void _showSubmenu(DesktopContextMenuItem item, int index, Rect itemRect) {
    _submenuEntry?.remove();
    if (!item.hasChildren) return;

    final isRight = MediaQuery.of(context).size.width - itemRect.right > 200;
    final offsetX = isRight ? itemRect.right + 2 : itemRect.left - 202;

    _submenuEntry = OverlayEntry(
      builder: (_) => Positioned(
        left: offsetX,
        top: itemRect.top,
        child: _ContextMenuPanel(
          items: item.children!,
          onClose: _closeAll,
          onItemHover: (i) {},
          colors: widget.colors,
          typography: widget.typography,
          isSubmenu: true,
        ),
      ),
    );
    Overlay.of(context).insert(_submenuEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _closeAll,
          behavior: HitTestBehavior.translucent,
          child: const SizedBox.expand(),
        ),
        Positioned(
          left: widget.position.dx,
          top: widget.position.dy,
          child: _ContextMenuPanel(
            items: widget.items,
            onClose: _closeAll,
            onItemHover: (index) {
              if (index != null && widget.items[index].hasChildren) {
                final itemRect = Rect.fromLTWH(
                  widget.position.dx,
                  widget.position.dy + index * 32,
                  200,
                  32,
                );
                _showSubmenu(widget.items[index], index, itemRect);
              } else {
                _submenuEntry?.remove();
                _submenuEntry = null;
              }
            },
            colors: widget.colors,
            typography: widget.typography,
          ),
        ),
      ],
    );
  }
}

class _ContextMenuPanel extends StatelessWidget {
  final List<DesktopContextMenuItem> items;
  final VoidCallback onClose;
  final ValueChanged<int?> onItemHover;
  final bool isSubmenu;
  final dynamic colors;
  final dynamic typography;

  const _ContextMenuPanel({
    required this.items,
    required this.onClose,
    required this.onItemHover,
    required this.colors,
    required this.typography,
    this.isSubmenu = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.escape) {
              onClose();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Container(
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
            border: Border.all(color: colors.border),
            boxShadow: DesktopTokens.elevation(3).map((s) => BoxShadow(
              blurRadius: s.blurRadius,
              offset: s.offset,
              color: s.color,
            )).toList(),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < items.length; i++) ...[
                if (items[i].divider)
                  Container(
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: colors.border,
                  )
                else
                  _ContextMenuItemWidget(
                    item: items[i],
                    onClose: onClose,
                    onHover: () => onItemHover(i),
                    colors: colors,
                    typography: typography,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ContextMenuItemWidget extends StatefulWidget {
  final DesktopContextMenuItem item;
  final VoidCallback onClose;
  final VoidCallback onHover;
  final dynamic colors;
  final dynamic typography;

  const _ContextMenuItemWidget({
    required this.item,
    required this.onClose,
    required this.onHover,
    required this.colors,
    required this.typography,
  });

  @override
  State<_ContextMenuItemWidget> createState() => _ContextMenuItemWidgetState();
}

class _ContextMenuItemWidgetState extends State<_ContextMenuItemWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final typography = widget.typography;
    final disabled = widget.item.disabled || widget.item.onPressed == null;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        widget.onHover();
      },
      onExit: (_) => setState(() => _hovered = false),
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: disabled
            ? null
            : () {
                widget.onClose();
                widget.item.onPressed?.call();
              },
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: _hovered ? colors.surfaceHover : Colors.transparent,
          child: Row(
            children: [
              if (widget.item.icon != null) ...[
                Icon(
                  widget.item.icon,
                  size: DesktopTokens.iconSm,
                  color: disabled ? colors.textDisabled : colors.textSecondary,
                ),
                const SizedBox(width: 8),
              ] else
                const SizedBox(width: 24),
              Expanded(
                child: Text(
                  widget.item.label,
                  style: typography.bodySmall.copyWith(
                    color: disabled ? colors.textDisabled : colors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.item.shortcut != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    widget.item.shortcut!,
                    style: typography.caption.copyWith(
                      color: colors.textTertiary,
                    ),
                  ),
                ),
              if (widget.item.hasChildren)
                Icon(
                  Icons.chevron_right,
                  size: DesktopTokens.iconSm,
                  color: colors.textTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
