import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';

enum SplitDirection { horizontal, vertical }

class DesktopSplitPanel extends StatefulWidget {
  final Widget first;
  final Widget second;
  final SplitDirection direction;
  final double initialRatio;
  final double minFirstSize;
  final double minSecondSize;
  final double dividerThickness;

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final total = isHorizontal ? constraints.maxWidth : constraints.maxHeight;
        final firstSize = (total * _ratio).clamp(widget.minFirstSize, total - widget.minSecondSize);
        final secondSize = total - firstSize;

        return MouseRegion(
          cursor: _dragging
              ? (isHorizontal ? SystemMouseCursors.resizeColumn : SystemMouseCursors.resizeRow)
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onPanStart: (_) => setState(() => _dragging = true),
            onPanUpdate: (details) {
              setState(() {
                final delta = isHorizontal ? details.delta.dx : details.delta.dy;
                _ratio = (firstSize + delta) / total;
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
