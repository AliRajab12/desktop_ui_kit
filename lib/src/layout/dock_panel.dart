import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';
import 'dock_panel_parts.dart';
import 'resizable_divider.dart';

export 'dock_panel_parts.dart' show DockAction;

enum DesktopDockPosition { left, right, top, bottom }

class DesktopDockPanel extends StatefulWidget {
  final String title;
  final IconData? icon;
  final DesktopDockPosition position;
  final double initialSize;
  final double minSize;
  final double maxSize;
  final Widget child;
  final List<DockAction>? actions;
  final bool initialCollapsed;

  const DesktopDockPanel({
    super.key,
    required this.title,
    this.icon,
    this.position = DesktopDockPosition.left,
    this.initialSize = 250,
    this.minSize = 100,
    this.maxSize = 400,
    required this.child,
    this.actions,
    this.initialCollapsed = false,
  });

  @override
  State<DesktopDockPanel> createState() => _DesktopDockPanelState();
}

class _DesktopDockPanelState extends State<DesktopDockPanel> {
  late double _size;
  late bool _collapsed;
  bool _dragging = false;

  bool get _isHorizontal => widget.position == DesktopDockPosition.left || widget.position == DesktopDockPosition.right;

  @override
  void initState() {
    super.initState();
    _size = widget.initialSize;
    _collapsed = widget.initialCollapsed;
  }

  @override
  void didUpdateWidget(DesktopDockPanel old) {
    super.didUpdateWidget(old);
    if (widget.initialSize != old.initialSize) _size = widget.initialSize;
    if (widget.initialCollapsed != old.initialCollapsed) _collapsed = widget.initialCollapsed;
  }

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    return _collapsed ? _buildCollapsed(colors) : _buildExpanded(colors);
  }

  Widget _buildCollapsed(DesktopColorScheme colors) {
    return SizedBox(
      width: _isHorizontal ? DesktopTokens.collapsedPanelSize : null,
      height: _isHorizontal ? null : DesktopTokens.collapsedPanelSize,
      child: DockToggle(
        icon: widget.icon, tooltip: widget.title,
        isHorizontal: _isHorizontal, isCollapsed: true, colors: colors,
        onTap: () => setState(() => _collapsed = false),
      ),
    );
  }

  Widget _buildExpanded(DesktopColorScheme colors) {
    final isLeft = widget.position == DesktopDockPosition.left;
    final divider = DesktopResizableDivider(
      isHorizontal: _isHorizontal, isDragging: _dragging, colors: colors,
      onDragUpdate: _onDrag,
      onDragStart: () => setState(() => _dragging = true),
      onDragEnd: () => setState(() => _dragging = false),
    );

    return SizedBox(
      width: _isHorizontal ? _size : null,
      height: _isHorizontal ? null : _size,
      child: _isHorizontal
          ? Row(textDirection: isLeft ? TextDirection.ltr : TextDirection.rtl, children: [Expanded(child: _buildContent(colors)), divider])
          : Column(children: [Expanded(child: _buildContent(colors)), divider]),
    );
  }

  Widget _buildContent(DesktopColorScheme colors) {
    return Column(children: [
      DockTitleBar(title: widget.title, icon: widget.icon, colors: colors, onCollapse: () => setState(() => _collapsed = true)),
      Expanded(child: widget.child),
    ]);
  }

  void _onDrag(double delta) {
    setState(() {
      final add = (widget.position == DesktopDockPosition.left || widget.position == DesktopDockPosition.top) ? delta : -delta;
      _size = (_size + add).clamp(widget.minSize, widget.maxSize);
    });
  }
}
