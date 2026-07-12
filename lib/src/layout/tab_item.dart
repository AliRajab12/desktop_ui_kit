import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';

class DesktopTabItem extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? tooltip;
  final bool isSelected;
  final bool isHovered;
  final bool showCloseButton;
  final DesktopColorScheme colors;
  final VoidCallback? onTap;
  final VoidCallback? onClose;
  final ValueChanged<bool>? onHoverChanged;

  const DesktopTabItem({
    super.key,
    required this.label,
    this.icon,
    this.tooltip,
    required this.isSelected,
    required this.isHovered,
    required this.showCloseButton,
    required this.colors,
    this.onTap,
    this.onClose,
    this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    final typography = DesktopTheme.of(context).typography;
    final bgColor = isSelected
        ? colors.surfaceElevated
        : isHovered
            ? colors.surfaceHover
            : colors.surface;
    final textColor = isSelected ? colors.textPrimary : colors.textSecondary;
    final borderColor = isSelected ? colors.accent : Colors.transparent;

    return Semantics(
      label: label,
      selected: isSelected,
      button: true,
      child: MouseRegion(
        onEnter: (_) => onHoverChanged?.call(true),
        onExit: (_) => onHoverChanged?.call(false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: DesktopTokens.durationFast,
            constraints: const BoxConstraints(minWidth: 80, maxWidth: 200),
            padding: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceSm),
            decoration: _decoration(bgColor, borderColor),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: DesktopTokens.iconSm, color: textColor),
                  const SizedBox(width: DesktopTokens.spaceXs),
                ],
                _Label(label: label, tooltip: tooltip, style: typography.label.copyWith(color: textColor)),
                if (showCloseButton) ...[
                  const SizedBox(width: DesktopTokens.spaceXs),
                  TabCloseButton(onTap: onClose ?? () {}, isVisible: isSelected || isHovered),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration(Color bgColor, Color borderColor) {
    return BoxDecoration(
      color: bgColor,
      border: Border(
        bottom: BorderSide(color: borderColor, width: DesktopTokens.borderThick),
        right: BorderSide(color: colors.border, width: DesktopTokens.borderThin),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String label;
  final String? tooltip;
  final TextStyle style;

  const _Label({required this.label, this.tooltip, required this.style});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? label,
      waitDuration: const Duration(milliseconds: 500),
      child: Text(label, style: style, overflow: TextOverflow.ellipsis, maxLines: 1),
    );
  }
}

class TabCloseButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isVisible;

  const TabCloseButton({super.key, required this.onTap, required this.isVisible});

  @override
  State<TabCloseButton> createState() => _TabCloseButtonState();
}

class _TabCloseButtonState extends State<TabCloseButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedOpacity(
          opacity: widget.isVisible ? 1.0 : 0.0,
          duration: DesktopTokens.durationFast,
          child: Container(
            width: DesktopTokens.iconMd,
            height: DesktopTokens.iconMd,
            decoration: BoxDecoration(
              color: _hovered ? colors.border : Colors.transparent,
              borderRadius: BorderRadius.circular(DesktopTokens.radiusSm),
            ),
            child: Icon(Icons.close, size: 12, color: _hovered ? colors.textPrimary : colors.textSecondary),
          ),
        ),
      ),
    );
  }
}
