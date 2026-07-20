import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';

/// Defines the orientation of a [DesktopSplitPanel] divider.
enum SplitDirection {
  /// Left-right split with a vertical divider.
  horizontal,

  /// Top-bottom split with a horizontal divider.
  vertical,
}

/// A resizable split panel for displaying two child widgets side by side.
///
/// Supports horizontal and vertical orientations with a draggable divider.
/// The divider highlights when active and respects minimum size constraints.
///
/// Example:
/// ```dart
/// DesktopSplitPanel(
///   first: Text('Left pane'),
///   second: Text('Right pane'),
///   initialRatio: 0.3,
/// )
/// ```
class DesktopSplitPanel extends StatefulWidget {
  /// The first (left or top) child widget.
  final Widget first;

  /// The second (right or bottom) child widget.
  final Widget second;

  /// The split orientation. Defaults to [SplitDirection.horizontal].
  final SplitDirection direction;

  /// Initial ratio of the first pane. Defaults to 0.5 (50/50).
  final double initialRatio;

  /// Minimum size of the first pane in logical pixels.
  final double minFirstSize;

  /// Minimum size of the second pane in logical pixels.
  final double minSecondSize;

  /// Thickness of the draggable divider.
  final double dividerThickness;

  /// Creates a split panel.
  const DesktopSplitPanel({
    super.key,
    required this.first,
    required this.second,
    this.direction = SplitDirection.horizontal,
    this.initialRatio = 0.5,
    this.minFirstSize = 100,
    this.minSecondSize = 100,
    this.dividerThickness = 4,
  });

  @override
  State<DesktopSplitPanel> createState() => _DesktopSplitPanelState();
}

class _DesktopSplitPanelState extends State<DesktopSplitPanel> {
  late double _ratio;
  bool _dragging = false;

  @override
  void initState() {
    super.initState();
    _ratio = widget.initialRatio;
  }

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;

    final isHorizontal = widget.direction == SplitDirection.horizontal;

    return Semantics(
      label: 'Split panel',
      child: LayoutBuilder(
      builder: (context, constraints) {
        final total = isHorizontal ? constraints.maxWidth : constraints.maxHeight;
        final available = total - widget.dividerThickness;
        final firstSize = (available * _ratio).clamp(widget.minFirstSize, available - widget.minSecondSize);
        final secondSize = available - firstSize;

        return MouseRegion(
          cursor: _dragging
              ? (isHorizontal ? SystemMouseCursors.resizeColumn : SystemMouseCursors.resizeRow)
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onPanStart: (_) => setState(() => _dragging = true),
            onPanUpdate: (details) {
              setState(() {
                final delta = isHorizontal ? details.delta.dx : details.delta.dy;
                _ratio = (firstSize + delta) / available;
                _ratio = _ratio.clamp(
                  widget.minFirstSize / total,
                  1.0 - widget.minSecondSize / total,
                );
              });
            },
            onPanEnd: (_) => setState(() => _dragging = false),
            child: isHorizontal ? _buildHorizontal(colors, firstSize, secondSize) : _buildVertical(colors, firstSize, secondSize),
          ),
        );
      },
      ),
    );
  }

  Widget _buildHorizontal(DesktopColorScheme colors, double firstW, double secondW) {
    return Row(
      children: [
        SizedBox(width: firstW, child: widget.first),
        _divider(colors, isHorizontal: true),
        SizedBox(width: secondW, child: widget.second),
      ],
    );
  }

  Widget _buildVertical(DesktopColorScheme colors, double firstH, double secondH) {
    return Column(
      children: [
        SizedBox(height: firstH, child: widget.first),
        _divider(colors, isHorizontal: false),
        SizedBox(height: secondH, child: widget.second),
      ],
    );
  }

  Widget _divider(DesktopColorScheme colors, {required bool isHorizontal}) {
    return Container(
      width: isHorizontal ? widget.dividerThickness : null,
      height: isHorizontal ? null : widget.dividerThickness,
      color: _dragging ? colors.accent : colors.border,
    );
  }
}
