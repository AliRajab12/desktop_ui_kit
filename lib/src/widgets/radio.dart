import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';
import 'form_control.dart';

/// A native-styled radio button for desktop applications.
///
/// Displays a radio button with an optional label. Use within a group
/// to allow single selection from multiple options.
///
/// Example:
/// ```dart
/// DesktopRadio<bool>(
///   value: true,
///   groupValue: selectedValue,
///   label: 'Option A',
///   onChanged: (value) => setState(() => selectedValue = value),
/// )
/// ```
class DesktopRadio<T> extends StatelessWidget {
  /// The value of this radio button.
  final T value;

  /// The currently selected value in the group.
  final T? groupValue;

  /// Callback when this radio button is selected.
  final ValueChanged<T?>? onChanged;

  /// Optional label displayed next to the radio button.
  final String? label;

  /// Optional widget displayed next to the radio button.
  final Widget? child;

  /// Whether the radio button is disabled.
  final bool disabled;

  /// Creates a radio button.
  const DesktopRadio({
    super.key,
    required this.value,
    this.groupValue,
    this.onChanged,
    this.label,
    this.child,
    this.disabled = false,
  });

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final effectiveOnTap = disabled ? null : () => onChanged?.call(value);

    return Semantics(
      checked: _selected,
      enabled: !disabled,
      label: label,
      child: DesktopFormControl(
        onTap: effectiveOnTap,
        disabled: disabled,
        label: label,
        control: _RadioIndicator(selected: _selected, disabled: disabled, colors: colors),
        child: child,
      ),
    );
  }
}

class _RadioIndicator extends StatelessWidget {
  final bool selected;
  final bool disabled;
  final DesktopColorScheme colors;

  const _RadioIndicator({required this.selected, required this.disabled, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DesktopTokens.radioSize,
      height: DesktopTokens.radioSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surface,
        border: Border.all(
          color: disabled ? colors.borderDisabled : selected ? colors.accent : colors.border,
          width: selected ? DesktopTokens.radioSelectedBorderWidth : 1,
        ),
      ),
    );
  }
}
