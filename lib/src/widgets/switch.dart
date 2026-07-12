import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';
import 'form_control.dart';

/// A native-styled toggle switch for desktop applications.
///
/// Displays an on/off toggle with smooth animation.
/// Use for binary settings like enabling/disabling features.
///
/// Example:
/// ```dart
/// DesktopSwitch(
///   value: darkMode,
///   label: 'Dark mode',
///   onChanged: (value) => setState(() => darkMode = value),
/// )
/// ```
class DesktopSwitch extends StatelessWidget {
  /// Whether the switch is in the on position.
  final bool value;

  /// Callback when the switch is toggled.
  final ValueChanged<bool>? onChanged;

  /// Optional label displayed next to the switch.
  final String? label;

  /// Optional widget displayed next to the switch.
  final Widget? child;

  /// Whether the switch is disabled.
  final bool disabled;

  /// Creates a switch.
  const DesktopSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.child,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final effectiveOnTap = disabled ? null : () => onChanged?.call(!value);

    return DesktopFormControl(
      onTap: effectiveOnTap,
      disabled: disabled,
      label: label,
      control: _SwitchIndicator(value: value, disabled: disabled, colors: colors),
      child: child,
    );
  }
}

class _SwitchIndicator extends StatelessWidget {
  final bool value;
  final bool disabled;
  final DesktopColorScheme colors;

  const _SwitchIndicator({required this.value, required this.disabled, required this.colors});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: DesktopTokens.durationFast,
      width: DesktopTokens.switchWidth,
      height: DesktopTokens.switchHeight,
      decoration: BoxDecoration(
        color: value
            ? disabled ? colors.accent.withAlpha(100) : colors.accent
            : disabled ? colors.surfaceHover : colors.surface,
        borderRadius: BorderRadius.circular(DesktopTokens.radiusFull),
        border: Border.all(color: disabled ? colors.borderDisabled : value ? colors.accent : colors.border),
      ),
      child: Align(
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: DesktopTokens.switchThumbPadding),
          child: Container(
            width: DesktopTokens.switchThumbSize,
            height: DesktopTokens.switchThumbSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value
                  ? disabled ? colors.accentText.withAlpha(100) : colors.accentText
                  : disabled ? colors.textDisabled : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
