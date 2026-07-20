import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';

/// A widget that displays a visible focus ring around its child when focused.
///
/// Provides a consistent, visible focus indicator across all desktop widgets
/// for keyboard navigation accessibility.
///
/// Example:
/// ```dart
/// DesktopFocusIndicator(
///   child: MyButton(),
/// )
/// ```
class DesktopFocusIndicator extends StatefulWidget {
  /// The child widget to wrap.
  final Widget child;

  /// Color of the focus ring. Defaults to theme accent color.
  final Color? focusColor;

  /// Width of the focus ring. Defaults to 2px.
  final double focusWidth;

  /// Border radius of the focus ring. Defaults to [DesktopTokens.radiusMd].
  final double focusRadius;

  /// Padding between the child and the focus ring.
  final double focusPadding;

  /// Whether the focus indicator is enabled.
  final bool enabled;

  /// Creates a focus indicator widget.
  const DesktopFocusIndicator({
    super.key,
    required this.child,
    this.focusColor,
    this.focusWidth = 2,
    this.focusRadius = DesktopTokens.radiusMd,
    this.focusPadding = 2,
    this.enabled = true,
  });

  @override
  State<DesktopFocusIndicator> createState() => _DesktopFocusIndicatorState();
}

class _DesktopFocusIndicatorState extends State<DesktopFocusIndicator> {
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final ringColor = widget.focusColor ?? colors.borderFocused;

    return Focus(
      focusNode: _focusNode,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.focusRadius),
          border: _focused && widget.enabled
              ? Border.all(
                  color: ringColor,
                  width: widget.focusWidth,
                )
              : null,
        ),
        padding: _focused && widget.enabled
            ? EdgeInsets.all(widget.focusPadding)
            : null,
        child: widget.child,
      ),
    );
  }
}
