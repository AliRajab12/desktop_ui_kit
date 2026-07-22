import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';
import '../accessibility/reduce_motion.dart';

/// A progress indicator for desktop applications.
///
/// Supports both determinate (with a specific value) and indeterminate
/// (loading) modes. Also provides a horizontal bar variant.
///
/// Example:
/// ```dart
/// DesktopProgress(value: 0.6) // 60% complete
/// DesktopProgress() // indeterminate spinner
/// DesktopProgress.bar(value: 0.4) // linear bar at 40%
/// ```
class DesktopProgress extends StatefulWidget {
  /// Progress value from 0.0 to 1.0. Null for indeterminate mode.
  final double? value;

  /// Width of the progress indicator. Defaults to 32.
  final double size;

  /// Stroke width for the circular variant. Defaults to 3.
  final double strokeWidth;

  /// Height of the bar. Only used with [DesktopProgress.bar].
  final double height;

  /// Color override.
  final Color? color;

  /// Background color override.
  final Color? backgroundColor;

  /// Whether to show a label with the percentage.
  final bool showLabel;

  /// Creates a circular progress indicator.
  const DesktopProgress({
    super.key,
    this.value,
    this.size = 32,
    this.strokeWidth = 3,
    this.height = 6,
    this.color,
    this.backgroundColor,
    this.showLabel = false,
  });

  /// Creates a linear progress bar.
  const DesktopProgress.bar({
    super.key,
    this.value,
    this.height = 6,
    this.color,
    this.backgroundColor,
    this.showLabel = false,
  })  : size = 0,
        strokeWidth = 0;

  @override
  State<DesktopProgress> createState() => _DesktopProgressState();
}

class _DesktopProgressState extends State<DesktopProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(DesktopProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final resolvedColor = widget.color ?? colors.accent;
    final resolvedBg = widget.backgroundColor ?? colors.border;
    final reduceMotion = DesktopReduceMotion.of(context);
    final isBar = widget.size == 0;

    if (isBar) {
      return _buildBar(resolvedColor, resolvedBg, reduceMotion);
    }
    return _buildCircular(resolvedColor, resolvedBg, reduceMotion);
  }

  Widget _buildCircular(Color color, Color bg, bool reduceMotion) {
    final clampedValue = widget.value?.clamp(0.0, 1.0);

    Widget indicator;
    if (clampedValue != null) {
      indicator = SizedBox(
        width: widget.size,
        height: widget.size,
        child: CircularProgressIndicator(
          value: clampedValue,
          strokeWidth: widget.strokeWidth,
          color: color,
          backgroundColor: bg,
        ),
      );
    } else {
      indicator = SizedBox(
        width: widget.size,
        height: widget.size,
        child: reduceMotion
            ? CircularProgressIndicator(
                value: 0.5,
                strokeWidth: widget.strokeWidth,
                color: color,
                backgroundColor: bg,
              )
            : AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => CircularProgressIndicator(
                  value: null,
                  strokeWidth: widget.strokeWidth,
                  color: color,
                  backgroundColor: bg,
                ),
              ),
      );
    }

    if (widget.showLabel && clampedValue != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(width: 8),
          Text(
            '${(clampedValue * 100).round()}%',
            style: DesktopTheme.of(context).typography.caption.copyWith(
                  color: color,
                ),
          ),
        ],
      );
    }

    return indicator;
  }

  Widget _buildBar(Color color, Color bg, bool reduceMotion) {
    final clampedValue = widget.value?.clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel && clampedValue != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${(clampedValue * 100).round()}%',
              style: DesktopTheme.of(context).typography.caption.copyWith(
                    color: color,
                  ),
            ),
          ),
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(DesktopTokens.radiusFull),
          ),
          child: clampedValue != null
              ? FractionallySizedBox(
                  widthFactor: clampedValue,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(DesktopTokens.radiusFull),
                    ),
                  ),
                )
              : reduceMotion
                  ? FractionallySizedBox(
                      widthFactor: 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(DesktopTokens.radiusFull),
                        ),
                      ),
                    )
                  : _IndeterminateBar(
                      color: color,
                      controller: _controller,
                    ),
        ),
      ],
    );
  }
}

class _IndeterminateBar extends StatelessWidget {
  final Color color;
  final AnimationController controller;

  const _IndeterminateBar({
    required this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return FractionallySizedBox(
          widthFactor: 0.3 + (controller.value * 0.4),
          alignment: Alignment(controller.value * 2 - 1, 0),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(DesktopTokens.radiusFull),
            ),
          ),
        );
      },
    );
  }
}
