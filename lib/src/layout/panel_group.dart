import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';
import 'dock_panel.dart';
import 'dock_panel_parts.dart';
import 'panel_group_parts.dart';
import 'resizable_divider.dart';

export 'panel_group_parts.dart' show PanelDefinition;

/// A multi-panel container with tabbed switching and collapsible state.
///
/// Displays multiple [PanelDefinition] panels with a tab bar when expanded,
/// or collapsed icon buttons when minimized. Supports drag-to-resize.
///
/// Example:
/// ```dart
/// DesktopPanelGroup(
///   panels: [
///     PanelDefinition(id: 'files', title: 'Files', icon: Icons.folder, child: FileTree()),
///     PanelDefinition(id: 'search', title: 'Search', icon: Icons.search, child: SearchPanel()),
///   ],
/// )
/// ```
class DesktopPanelGroup extends StatefulWidget {
  /// The panels available in this group.
  final List<PanelDefinition> panels;
  final DesktopDockPosition position;
  final double initialSize;
  final double minSize;
  final double maxSize;
  final bool initialCollapsed;

  const DesktopPanelGroup({
    super.key,
    required this.panels,
    this.position = DesktopDockPosition.left,
    this.initialSize = 250,
    this.minSize = 100,
    this.maxSize = 400,
    this.initialCollapsed = false,
  });

  @override
  State<DesktopPanelGroup> createState() => _DesktopPanelGroupState();
}

class _DesktopPanelGroupState extends State<DesktopPanelGroup> {
  late String _selectedId;
  late bool _collapsed;
  late double _size;
  bool _dragging = false;

  bool get _isHorizontal => widget.position == DesktopDockPosition.left || widget.position == DesktopDockPosition.right;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.panels.isNotEmpty ? widget.panels.first.id : '';
    _collapsed = widget.initialCollapsed;
    _size = widget.initialSize;
  }

  @override
  void didUpdateWidget(DesktopPanelGroup old) {
    super.didUpdateWidget(old);
    if (widget.panels != old.panels && !widget.panels.any((p) => p.id == _selectedId)) {
      _selectedId = widget.panels.isNotEmpty ? widget.panels.first.id : '';
    }
    if (widget.initialSize != old.initialSize) _size = widget.initialSize;
    if (widget.initialCollapsed != old.initialCollapsed) _collapsed = widget.initialCollapsed;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.panels.isEmpty) return const SizedBox.shrink();
    final colors = DesktopTheme.of(context).colors;
    return _collapsed ? _buildCollapsed(colors) : _buildExpanded(colors);
  }

  Widget _buildCollapsed(DesktopColorScheme colors) {
    return SizedBox(
      width: _isHorizontal ? DesktopTokens.collapsedPanelSize : null,
      height: _isHorizontal ? null : DesktopTokens.collapsedPanelSize,
      child: _isHorizontal
          ? Column(children: [for (final p in widget.panels) PanelCollapsedIcon(icon: p.icon, title: p.title, isActive: p.id == _selectedId, colors: colors, onTap: _expand(p.id))])
          : Row(children: [for (final p in widget.panels) PanelCollapsedIcon(icon: p.icon, title: p.title, isActive: p.id == _selectedId, colors: colors, onTap: _expand(p.id))]),
    );
  }

  VoidCallback _expand(String id) => () => setState(() { _selectedId = id; _collapsed = false; });

  Widget _buildExpanded(DesktopColorScheme colors) {
    final panel = widget.panels.firstWhere((p) => p.id == _selectedId);
    final isLeft = widget.position == DesktopDockPosition.left;
    final divider = DesktopResizableDivider(
      isHorizontal: _isHorizontal, isDragging: _dragging, colors: colors,
      onDragUpdate: _onDrag,
      onDragStart: () => setState(() => _dragging = true),
      onDragEnd: () => setState(() => _dragging = false),
    );

    Widget content = _isHorizontal
        ? Row(textDirection: isLeft ? TextDirection.ltr : TextDirection.rtl, children: [Expanded(child: _buildPanelBody(colors, panel)), divider])
        : Column(children: [Expanded(child: _buildPanelBody(colors, panel)), divider]);

    return SizedBox(
      width: _isHorizontal ? _size : null,
      height: _isHorizontal ? null : _size,
      child: content,
    );
  }

  Widget _buildPanelBody(DesktopColorScheme colors, PanelDefinition panel) {
    return Column(children: [
      if (widget.panels.length > 1)
        PanelTabBar(panels: widget.panels, selectedId: _selectedId, colors: colors, onSelect: (id) => setState(() => _selectedId = id)),
      DockTitleBar(title: panel.title, icon: panel.icon, colors: colors, onCollapse: () => setState(() => _collapsed = true)),
      Expanded(child: panel.child),
    ]);
  }

  void _onDrag(double delta) {
    setState(() {
      final add = (widget.position == DesktopDockPosition.left || widget.position == DesktopDockPosition.top) ? delta : -delta;
      _size = (_size + add).clamp(widget.minSize, widget.maxSize);
    });
  }
}
