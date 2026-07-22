import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';

/// A single item in a [DesktopStatusBar].
///
/// Can be a text label, icon, or custom widget.
class DesktopStatusItem {
  /// The item type.
  final DesktopStatusItemType type;

  /// Text for label items.
  final String? label;

  /// Icon for icon items.
  final IconData? icon;

  /// Custom widget to render.
  final Widget? child;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  /// Tooltip text.
  final String? tooltip;

  /// Creates a status item.
  const DesktopStatusItem({
    this.type = DesktopStatusItemType.label,
    this.label,
    this.icon,
    this.child,
    this.onTap,
    this.tooltip,
  });

  /// Creates a text label item.
  const DesktopStatusItem.label({
    required String this.label,
    this.onTap,
    this.tooltip,
  })  : type = DesktopStatusItemType.label,
        icon = null,
        child = null;

  /// Creates an icon item.
  const DesktopStatusItem.icon({
    required IconData this.icon,
    this.onTap,
    this.tooltip,
  })  : type = DesktopStatusItemType.icon,
        label = null,
        child = null;

  /// Creates a custom widget item.
  const DesktopStatusItem.custom({required Widget this.child, this.tooltip})
      : type = DesktopStatusItemType.custom,
        label = null,
        icon = null,
        onTap = null;

  /// Creates a separator.
  const DesktopStatusItem.separator()
      : type = DesktopStatusItemType.separator,
        label = null,
        icon = null,
        child = null,
        onTap = null,
        tooltip = null;
}

/// The type of status bar item.
enum DesktopStatusItemType {
  /// A text label.
  label,

  /// An icon.
  icon,

  /// A custom widget.
  custom,

  /// A vertical separator.
  separator,
}

/// A horizontal status bar for displaying application state.
///
/// Displays items in left and right sections with separators between them.
/// Commonly used at the bottom of desktop applications.
///
/// Example:
/// ```dart
/// DesktopStatusBar(
///   leftItems: [
///     DesktopStatusItem.label(label: 'Ready'),
///     DesktopStatusItem.separator(),
///     DesktopStatusItem.label(label: '3 files open'),
///   ],
///   rightItems: [
///     DesktopStatusItem.icon(icon: Icons.wifi),
///     DesktopStatusItem.label(label: 'UTF-8'),
///   ],
/// )
/// ```
class DesktopStatusBar extends StatefulWidget {
  /// Items aligned to the left.
  final List<DesktopStatusItem> leftItems;

  /// Items aligned to the right.
  final List<DesktopStatusItem> rightItems;

  /// Height of the status bar. Defaults to [DesktopTokens.statusBarHeight].
  final double height;

  /// Background color override.
  final Color? backgroundColor;

  /// Creates a status bar.
  const DesktopStatusBar({
    super.key,
    this.leftItems = const [],
    this.rightItems = const [],
    this.height = DesktopTokens.statusBarHeight,
    this.backgroundColor,
  });

  @override
  State<DesktopStatusBar> createState() => _DesktopStatusBarState();
}

class _DesktopStatusBarState extends State<DesktopStatusBar> {
  int? _hoveredLeftIndex;
  int? _hoveredRightIndex;

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;

    return Semantics(
      label: 'Status bar',
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceSm),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? colors.surfaceContainer,
          border: Border(top: BorderSide(color: colors.border)),
        ),
        child: Row(
          children: [
            ..._buildItems(widget.leftItems, colors, isLeft: true),
            const Spacer(),
            ..._buildItems(widget.rightItems, colors, isLeft: false),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildItems(
    List<DesktopStatusItem> items,
    DesktopColorScheme colors, {
    required bool isLeft,
  }) {
    final widgets = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.type == DesktopStatusItemType.separator) {
        widgets.add(_StatusSeparator(colors: colors));
      } else {
        widgets.add(_StatusItemWidget(
          item: item,
          colors: colors,
          isHovered: isLeft
              ? _hoveredLeftIndex == i
              : _hoveredRightIndex == i,
          onHoverChanged: (hovering) {
            setState(() {
              if (isLeft) {
                _hoveredLeftIndex = hovering ? i : null;
              } else {
                _hoveredRightIndex = hovering ? i : null;
              }
            });
          },
        ));
      }
    }
    return widgets;
  }
}

class _StatusSeparator extends StatelessWidget {
  final DesktopColorScheme colors;

  const _StatusSeparator({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceSm),
      color: colors.border,
    );
  }
}

class _StatusItemWidget extends StatelessWidget {
  final DesktopStatusItem item;
  final DesktopColorScheme colors;
  final bool isHovered;
  final ValueChanged<bool> onHoverChanged;

  const _StatusItemWidget({
    required this.item,
    required this.colors,
    required this.isHovered,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final typography = DesktopTheme.of(context).typography;
    final disabled = item.onTap == null;

    Widget content = switch (item.type) {
      DesktopStatusItemType.label => Text(
          item.label ?? '',
          style: typography.caption.copyWith(
            color: disabled ? colors.textDisabled : colors.textSecondary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      DesktopStatusItemType.icon => Icon(
          item.icon,
          size: DesktopTokens.iconSm,
          color: disabled ? colors.textDisabled : colors.textSecondary,
        ),
      DesktopStatusItemType.custom => item.child ?? const SizedBox.shrink(),
      DesktopStatusItemType.separator => const SizedBox.shrink(),
    };

    if (item.tooltip != null) {
      content = Tooltip(message: item.tooltip!, child: content);
    }

    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      cursor: disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DesktopTokens.spaceXs,
            vertical: DesktopTokens.spaceXxs,
          ),
          color: isHovered ? colors.surfaceHover : Colors.transparent,
          child: content,
        ),
      ),
    );
  }
}
