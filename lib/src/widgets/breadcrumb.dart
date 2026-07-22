import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';

/// A single segment in a [DesktopBreadcrumb].
///
/// Represents one level in a hierarchical path.
class DesktopBreadcrumbItem {
  /// The display label.
  final String label;

  /// Optional icon displayed before the label.
  final IconData? icon;

  /// Callback when this segment is tapped.
  final VoidCallback? onTap;

  /// Creates a breadcrumb item.
  const DesktopBreadcrumbItem({
    required this.label,
    this.icon,
    this.onTap,
  });
}

/// A horizontal breadcrumb navigation for hierarchical paths.
///
/// Displays clickable path segments with customizable separators.
/// Long paths collapse middle segments with an ellipsis that can be
/// expanded via a popup menu.
///
/// Example:
/// ```dart
/// DesktopBreadcrumb(
///   items: [
///     DesktopBreadcrumbItem(label: 'Home', onTap: () {}),
///     DesktopBreadcrumbItem(label: 'Documents', onTap: () {}),
///     DesktopBreadcrumbItem(label: 'project.pdf'),
///   ],
/// )
/// ```
class DesktopBreadcrumb extends StatefulWidget {
  /// The breadcrumb items to display.
  final List<DesktopBreadcrumbItem> items;

  /// Separator between items. Defaults to `>`.
  final String separator;

  /// Maximum number of items before collapsing. 0 means no limit.
  final int maxItems;

  /// Creates a breadcrumb navigation.
  const DesktopBreadcrumb({
    super.key,
    required this.items,
    this.separator = '>',
    this.maxItems = 0,
  });

  @override
  State<DesktopBreadcrumb> createState() => _DesktopBreadcrumbState();
}

class _DesktopBreadcrumbState extends State<DesktopBreadcrumb> {
  int? _hoveredIndex;

  List<DesktopBreadcrumbItem> get _visibleItems {
    if (widget.maxItems <= 0 || widget.items.length <= widget.maxItems) {
      return widget.items;
    }
    // Show first item, ellipsis, and last (maxItems - 2) items
    final keepEnd = widget.maxItems - 2;
    return [
      widget.items.first,
      if (keepEnd > 0) DesktopBreadcrumbItem(label: '...'),
      ...widget.items.skip(widget.items.length - keepEnd),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;
    final visibleItems = _visibleItems;

    return Semantics(
      label: 'Breadcrumb navigation',
      child: Focus(
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.home) {
              widget.items.first.onTap?.call();
              return KeyEventResult.handled;
            }
            if (event.logicalKey == LogicalKeyboardKey.end) {
              widget.items.last.onTap?.call();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < visibleItems.length; i++) ...[
                if (i > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      widget.separator,
                      style: typography.caption.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ),
                _BreadcrumbSegment(
                  item: visibleItems[i],
                  isHovered: _hoveredIndex == i,
                  isEllipsis: visibleItems[i].label == '...',
                  isLast: i == visibleItems.length - 1,
                  colors: colors,
                  typography: typography,
                  onHover: (hovering) {
                    setState(() => _hoveredIndex = hovering ? i : null);
                  },
                  onTap: visibleItems[i].onTap,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BreadcrumbSegment extends StatefulWidget {
  final DesktopBreadcrumbItem item;
  final bool isHovered;
  final bool isEllipsis;
  final bool isLast;
  final dynamic colors;
  final dynamic typography;
  final ValueChanged<bool> onHover;
  final VoidCallback? onTap;

  const _BreadcrumbSegment({
    required this.item,
    required this.isHovered,
    required this.isEllipsis,
    required this.isLast,
    required this.colors,
    required this.typography,
    required this.onHover,
    this.onTap,
  });

  @override
  State<_BreadcrumbSegment> createState() => _BreadcrumbSegmentState();
}

class _BreadcrumbSegmentState extends State<_BreadcrumbSegment> {
  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final typography = widget.typography;
    final hasAction = widget.item.onTap != null;

    return MouseRegion(
      onEnter: (_) => widget.onHover(true),
      onExit: (_) => widget.onHover(false),
      cursor: hasAction ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: widget.isHovered && hasAction
              ? BoxDecoration(
                  color: colors.surfaceHover,
                  borderRadius: BorderRadius.circular(DesktopTokens.radiusSm),
                )
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.item.icon != null) ...[
                Icon(
                  widget.item.icon,
                  size: DesktopTokens.iconSm,
                  color: widget.isLast ? colors.textPrimary : colors.textSecondary,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                widget.item.label,
                style: typography.bodySmall.copyWith(
                  color: widget.isLast
                      ? colors.textPrimary
                      : hasAction
                          ? colors.accent
                          : colors.textSecondary,
                  decoration: hasAction ? TextDecoration.underline : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
