import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';

/// Defines the visual variant of a [DesktopButton].
///
/// Controls the button's background color, text color, and border styling.
enum DesktopButtonVariant {
  /// Primary action button with accent background.
  primary,

  /// Secondary button with surface background and border.
  secondary,

  /// Ghost button with transparent background.
  ghost,

  /// Danger button for destructive actions with danger styling.
  danger,
}

/// A native-styled button for desktop applications.
///
/// Supports multiple variants, icons, loading states, and full-width mode.
/// Uses platform-adaptive styling that matches native OS conventions.
///
/// Example:
/// ```dart
/// DesktopButton(
///   label: 'Save',
///   icon: Icons.save,
///   onPressed: () => save(),
/// )
/// ```
class DesktopButton extends StatelessWidget {
  /// The button label text.
  final String label;

  /// Optional icon displayed before the label.
  final IconData? icon;

  /// Callback when the button is pressed. Set to null to disable.
  final VoidCallback? onPressed;

  /// The visual variant of the button.
  final DesktopButtonVariant variant;

  /// Whether to show a loading indicator instead of the label.
  final bool loading;

  /// Whether the button should expand to fill available width.
  final bool expanded;

  /// Creates a desktop-styled button.
  const DesktopButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.variant = DesktopButtonVariant.primary,
    this.loading = false,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;
    final disabled = onPressed == null || loading;

    final bgColor = _resolveBg(colors, disabled);
    final textColor = _resolveText(colors, disabled);
    final borderColor = _resolveBorder(colors, disabled);

    return Semantics(
      button: true,
      enabled: !disabled,
      label: label,
      child: SizedBox(
        height: DesktopTokens.buttonHeight,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
            hoverColor: colors.surfaceHover.withAlpha(
              disabled ? 0 : (DesktopTokens.opacityHover * 255).round(),
            ),
            splashColor: colors.surfacePressed.withAlpha(
              disabled ? 0 : (DesktopTokens.opacityPressed * 255).round(),
            ),
            onTap: disabled ? null : onPressed,
            child: AnimatedContainer(
              duration: DesktopTokens.durationFast,
              padding: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceLg),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (loading)
                    SizedBox(
                      width: DesktopTokens.actionButtonIconSize,
                      height: DesktopTokens.actionButtonIconSize,
                      child: CircularProgressIndicator(strokeWidth: DesktopTokens.borderThick, color: textColor),
                    )
                  else if (icon != null) ...[
                    Icon(icon, size: DesktopTokens.iconSm, color: textColor),
                    const SizedBox(width: DesktopTokens.spaceXs),
                  ],
                  Text(label, style: typography.label.copyWith(color: textColor)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveBg(DesktopColorScheme c, bool disabled) {
    if (disabled) return c.surfaceHover;
    return switch (variant) {
      DesktopButtonVariant.primary => c.accent,
      DesktopButtonVariant.secondary => c.surface,
      DesktopButtonVariant.ghost => Colors.transparent,
      DesktopButtonVariant.danger => c.danger,
    };
  }

  Color _resolveText(DesktopColorScheme c, bool disabled) {
    if (disabled) return c.textDisabled;
    return switch (variant) {
      DesktopButtonVariant.primary => c.accentText,
      DesktopButtonVariant.secondary => c.textPrimary,
      DesktopButtonVariant.ghost => c.textPrimary,
      DesktopButtonVariant.danger => c.dangerText,
    };
  }

  Color _resolveBorder(DesktopColorScheme c, bool disabled) {
    if (disabled) return c.borderDisabled;
    return switch (variant) {
      DesktopButtonVariant.primary => c.accent,
      DesktopButtonVariant.secondary => c.border,
      DesktopButtonVariant.ghost => Colors.transparent,
      DesktopButtonVariant.danger => c.danger,
    };
  }
}
