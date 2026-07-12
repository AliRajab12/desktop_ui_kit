import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';
import 'input_decorator.dart';

/// A native-styled text input field for desktop applications.
///
/// Provides platform-adaptive styling with proper focus states,
/// validation support, and optional prefix/suffix icons.
///
/// Example:
/// ```dart
/// DesktopTextField(
///   label: 'Email',
///   hint: 'you@example.com',
///   prefixIcon: Icons.email,
///   onChanged: (value) => print(value),
/// )
/// ```
class DesktopTextField extends StatefulWidget {
  /// Label text displayed above the field.
  final String? label;

  /// Placeholder text when the field is empty.
  final String? hint;

  /// Error message to display. Set null to clear.
  final String? error;

  /// Helper text displayed below the field.
  final String? helper;

  /// Icon displayed before the text.
  final IconData? prefixIcon;

  /// Icon displayed after the text.
  final IconData? suffixIcon;

  /// Callback when the suffix icon is tapped.
  final VoidCallback? onSuffixTap;

  /// Current text value.
  final String? value;

  /// Callback when the text changes.
  final ValueChanged<String>? onChanged;

  /// Callback when the field is submitted.
  final ValueChanged<String>? onSubmitted;

  /// Whether the field is disabled.
  final bool disabled;

  /// Whether the field is read-only.
  final bool readOnly;

  /// Whether to obscure the text (for passwords).
  final bool obscureText;

  /// The maximum number of lines.
  final int maxLines;

  /// The minimum width of the field.
  final double? minWidth;

  /// Creates a text field.
  const DesktopTextField({
    super.key,
    this.label,
    this.hint,
    this.error,
    this.helper,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.value,
    this.onChanged,
    this.onSubmitted,
    this.disabled = false,
    this.readOnly = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minWidth,
  });

  @override
  State<DesktopTextField> createState() => _DesktopTextFieldState();
}

class _DesktopTextFieldState extends State<DesktopTextField> {
  late TextEditingController _controller;
  final _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void didUpdateWidget(DesktopTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;
    final hasError = widget.error != null;
    final borderColor = DesktopInputDecorator.resolveBorderColor(
      colors: colors, hasError: hasError, focused: _focused, disabled: widget.disabled,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DesktopInputDecorator.buildLabel(widget.label, widget.disabled, colors, typography),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: widget.minWidth ?? 0),
          child: Container(
            height: DesktopTokens.inputHeight * (widget.maxLines > 1 ? 2 : 1),
            decoration: BoxDecoration(
              color: widget.disabled ? colors.surfaceHover : colors.surface,
              borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
              border: Border.all(color: borderColor, width: _focused && !hasError ? 2 : 1),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: !widget.disabled,
              readOnly: widget.readOnly,
              obscureText: widget.obscureText,
              maxLines: widget.maxLines,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              style: typography.body.copyWith(color: widget.disabled ? colors.textDisabled : colors.textPrimary),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: typography.body.copyWith(color: colors.textTertiary),
                prefixIcon: widget.prefixIcon != null
                    ? Padding(padding: const EdgeInsets.only(left: DesktopTokens.spaceSm), child: Icon(widget.prefixIcon, size: DesktopTokens.iconMd, color: widget.disabled ? colors.textDisabled : colors.textSecondary))
                    : null,
                prefixIconConstraints: BoxConstraints(minWidth: widget.prefixIcon != null ? 36 : 0),
                suffixIcon: widget.suffixIcon != null
                    ? GestureDetector(onTap: widget.onSuffixTap, child: Padding(padding: const EdgeInsets.only(right: DesktopTokens.spaceSm), child: Icon(widget.suffixIcon, size: DesktopTokens.iconMd, color: widget.disabled ? colors.textDisabled : colors.textSecondary)))
                    : null,
                suffixIconConstraints: BoxConstraints(minWidth: widget.suffixIcon != null ? 36 : 0),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceMd, vertical: DesktopTokens.spaceSm),
              ),
            ),
          ),
        ),
        if (hasError)
          DesktopInputDecorator.buildErrorText(widget.error, typography, colors)
        else
          DesktopInputDecorator.buildHelperText(widget.helper, hasError, typography, colors),
      ].whereType<Widget>().toList(),
    );
  }
}
