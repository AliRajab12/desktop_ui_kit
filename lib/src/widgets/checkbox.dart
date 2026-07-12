import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';
import 'form_control.dart';

/// A native-styled checkbox for desktop applications.
///
/// Displays a checkbox with an optional label and supports
/// indeterminate state for partial selections.
///
/// Example:
/// ```dart
/// DesktopCheckbox(
///   value: true,
///   label: 'Enable notifications',
///   onChanged: (value) => setState(() => enabled = value),
/// )
/// ```
class DesktopCheckbox extends StatelessWidget {
  /// Whether the checkbox is checked.
  ///
  /// Null indicates indeterminate state.
  final bool? value;

  /// Callback when the checkbox state changes.
  final ValueChanged<bool?>? onChanged;

  /// Optional label displayed next to the checkbox.
  final String? label;

  /// Optional widget displayed next to the checkbox.
  final Widget? child;

  /// Whether the checkbox is disabled.
  final bool disabled;

  /// Creates a checkbox.
  const DesktopCheckbox({
    super.key,
    this.value,
    this.onChanged,
    this.label,
    this.child,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final effectiveOnTap = disabled ? null : () => onChanged?.call(!(value ?? false));
    final isIndeterminate = value == null;

    return DesktopFormControl(
      onTap: effectiveOnTap,
      disabled: disabled,
      label: label,
      control: _CheckboxIndicator(value: value, isIndeterminate: isIndeterminate, disabled: disabled, colors: colors),
      child: child,
    );
  }
}

class _CheckboxIndicator extends StatelessWidget {
  final bool? value;
  final bool isIndeterminate;
  final bool disabled;
  final DesktopColorScheme colors;

  const _CheckboxIndicator({required this.value, required this.isIndeterminate, required this.disabled, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DesktopTokens.checkboxSize,
      height: DesktopTokens.checkboxSize,
      decoration: BoxDecoration(
        color: value == true || isIndeterminate ? colors.accent : colors.surface,
        borderRadius: BorderRadius.circular(DesktopTokens.radiusSm),
        border: Border.all(color: disabled ? colors.borderDisabled : value == true || isIndeterminate ? colors.accent : colors.border),
      ),
      child: Center(child: _buildIndicator()),
    );
  }

  Widget? _buildIndicator() {
    if (isIndeterminate) return Container(width: DesktopTokens.checkboxIndeterminateWidth, height: DesktopTokens.checkboxIndeterminateHeight, color: disabled ? colors.borderDisabled : colors.accentText);
    if (value == true) return Icon(Icons.check, size: DesktopTokens.checkboxIconSize, color: colors.accentText);
    return null;
  }
}
