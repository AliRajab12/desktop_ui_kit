import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';

/// A draggable divider for resizing panels.
///
/// Used by [DesktopDockPanel] and [DesktopPanelGroup] to separate
/// resizable content areas. Highlights when active.
class DesktopResizableDivider extends StatelessWidget {
  final bool isHorizontal;
  final bool isDragging;
  final DesktopColorScheme colors;
  final ValueChanged<double> onDragUpdate;
  final VoidCallback onDragStart;
  final VoidCallback onDragEnd;

  const DesktopResizableDivider({
    super.key,
    required this.isHorizontal,
    required this.isDragging,
    required this.colors,
    required this.onDragUpdate,
    required this.onDragStart,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: isHorizontal ? SystemMouseCursors.resizeColumn : SystemMouseCursors.resizeRow,
      child: GestureDetector(
        onPanStart: (_) => onDragStart(),
        onPanUpdate: (d) => onDragUpdate(isHorizontal ? d.delta.dx : d.delta.dy),
        onPanEnd: (_) => onDragEnd(),
        child: Container(
          width: isHorizontal ? DesktopTokens.dividerThickness : null,
          height: isHorizontal ? null : DesktopTokens.dividerThickness,
          color: isDragging ? colors.accent : colors.border,
        ),
      ),
    );
  }
}
