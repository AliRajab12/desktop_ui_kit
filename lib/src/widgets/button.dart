import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';

enum DesktopButtonVariant {
  primary,
  secondary,
  ghost,
  danger,
}

class DesktopButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final DesktopButtonVariant variant;
  final bool loading;
  final bool expanded;

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
  State<DesktopButton> createState() => _DesktopButtonState();
}

class _DesktopButtonState extends State<DesktopButton> {
  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final disabled = widget.onPressed == null || widget.loading;

    final bgColor = _resolveBg(colors, disabled);
    final textColor = _resolveText(colors, disabled);
    final borderColor = _resolveBorder(colors, disabled);

    return SizedBox(
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
          onTap: disabled ? null : widget.onPressed,
          child: AnimatedContainer(
            duration: DesktopTokens.durationFast,
            padding: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceLg),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.loading)
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textColor,
                    ),
                  )
                else if (widget.icon != null) ...[
                  Icon(widget.icon, size: DesktopTokens.iconSm, color: textColor),
                  const SizedBox(width: DesktopTokens.spaceXs),
                ],
                Text(widget.label, style: typography.label.copyWith(color: textColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _resolveBg(DesktopColorScheme c, bool disabled) {
    if (disabled) return c.surfaceHover;
    return switch (widget.variant) {
      DesktopButtonVariant.primary => c.accent,
      DesktopButtonVariant.secondary => c.surface,
      DesktopButtonVariant.ghost => Colors.transparent,
      DesktopButtonVariant.danger => c.danger,
    };
  }

  Color _resolveText(DesktopColorScheme c, bool disabled) {
    if (disabled) return c.textDisabled;
    return switch (widget.variant) {
      DesktopButtonVariant.primary => c.accentText,
      DesktopButtonVariant.secondary => c.textPrimary,
      DesktopButtonVariant.ghost => c.textPrimary,
      DesktopButtonVariant.danger => c.dangerText,
    };
  }

  Color _resolveBorder(DesktopColorScheme c, bool disabled) {
    if (disabled) return c.borderDisabled;
    return switch (widget.variant) {
      DesktopButtonVariant.primary => c.accent,
      DesktopButtonVariant.secondary => c.border,
      DesktopButtonVariant.ghost => Colors.transparent,
      DesktopButtonVariant.danger => c.danger,
    };
  }
}
