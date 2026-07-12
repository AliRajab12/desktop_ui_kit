import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';
import 'tab_item.dart';

class DesktopTab {
  final String id;
  final String label;
  final IconData? icon;
  final bool closable;
  final String? tooltip;

  const DesktopTab({
    required this.id,
    required this.label,
    this.icon,
    this.closable = true,
    this.tooltip,
  });
}

typedef DesktopTabSelectedCallback = void Function(String tabId);
typedef DesktopTabCloseCallback = void Function(String tabId);
typedef DesktopTabReorderCallback = void Function(int oldIndex, int newIndex);

class DesktopTabBar extends StatefulWidget {
  final List<DesktopTab> tabs;
  final String? selectedId;
  final DesktopTabSelectedCallback? onSelect;
  final DesktopTabCloseCallback? onClose;
  final DesktopTabReorderCallback? onReorder;
  final double height;
  final bool showCloseButtons;
  final bool allowReorder;

  const DesktopTabBar({
    super.key,
    required this.tabs,
    this.selectedId,
    this.onSelect,
    this.onClose,
    this.onReorder,
    this.height = DesktopTokens.tabHeight,
    this.showCloseButtons = true,
    this.allowReorder = true,
  });

  @override
  State<DesktopTabBar> createState() => _DesktopTabBarState();
}

class _DesktopTabBarState extends State<DesktopTabBar> {
  final ScrollController _scrollController = ScrollController();
  int? _hoveredIndex;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;

    return Focus(
      onKeyEvent: _handleKeyEvent,
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(bottom: BorderSide(color: colors.border)),
        ),
        child: widget.allowReorder
            ? _buildReorderable(colors)
            : _buildScrollable(colors),
      ),
    );
  }

  Widget _buildReorderable(DesktopColorScheme colors) {
    return ReorderableListView.builder(
      scrollController: _scrollController,
      scrollDirection: Axis.horizontal,
      buildDefaultDragHandles: false,
      itemCount: widget.tabs.length,
      onReorder: (old, new_) {
        if (old < new_) new_--;
        widget.onReorder?.call(old, new_);
      },
      itemBuilder: (context, index) => _buildTab(index, colors),
    );
  }

  Widget _buildScrollable(DesktopColorScheme colors) {
    return ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: widget.tabs.length,
      itemBuilder: (context, index) => _buildTab(index, colors),
    );
  }

  Widget _buildTab(int index, DesktopColorScheme colors) {
    final tab = widget.tabs[index];
    final isSelected = tab.id == widget.selectedId;
    final isHovered = index == _hoveredIndex;

    return ReorderableDragStartListener(
      key: ValueKey(tab.id),
      index: index,
      child: DesktopTabItem(
        label: tab.label,
        icon: tab.icon,
        tooltip: tab.tooltip,
        isSelected: isSelected,
        isHovered: isHovered,
        showCloseButton: widget.showCloseButtons && tab.closable,
        colors: colors,
        onTap: () => widget.onSelect?.call(tab.id),
        onClose: () => widget.onClose?.call(tab.id),
        onHoverChanged: (h) => setState(() => _hoveredIndex = h ? index : null),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final i = widget.tabs.indexWhere((t) => t.id == widget.selectedId);
    if (i == -1) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft && i > 0) {
      widget.onSelect?.call(widget.tabs[i - 1].id);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight && i < widget.tabs.length - 1) {
      widget.onSelect?.call(widget.tabs[i + 1].id);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.keyW && HardwareKeyboard.instance.isControlPressed) {
      if (widget.tabs[i].closable) widget.onClose?.call(widget.tabs[i].id);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}
