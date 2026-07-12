import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';

class DockActionButton extends StatelessWidget {
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onTap;
  final DesktopColorScheme colors;

  const DockActionButton({super.key, required this.icon, this.tooltip, this.onTap, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      waitDuration: DesktopTokens.tooltipDelay,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: DesktopTokens.actionButtonSize,
          height: DesktopTokens.actionButtonSize,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(DesktopTokens.radiusSm)),
          child: Icon(icon, size: DesktopTokens.actionButtonIconSize, color: colors.textSecondary),
        ),
      ),
    );
  }
}

class DockTitleBar extends StatelessWidget {
  final String title;
  final IconData? icon;
  final List<Widget>? trailing;
  final DesktopColorScheme colors;
  final VoidCallback? onCollapse;

  const DockTitleBar({super.key, required this.title, this.icon, this.trailing, required this.colors, this.onCollapse});

  @override
  Widget build(BuildContext context) {
    final typography = DesktopTheme.of(context).typography;
    return Container(
      height: DesktopTokens.panelHeaderHeight,
      padding: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceSm),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.border, width: DesktopTokens.borderThin)),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: DesktopTokens.iconSm, color: colors.textSecondary),
            const SizedBox(width: DesktopTokens.spaceXs),
          ],
          Expanded(child: Text(title, style: typography.label.copyWith(color: colors.textPrimary), overflow: TextOverflow.ellipsis)),
          if (trailing != null) ...trailing!,
          DockActionButton(icon: Icons.chevron_left, tooltip: 'Collapse', onTap: onCollapse, colors: colors),
        ],
      ),
    );
  }
}

class DockToggle extends StatelessWidget {
  final IconData? icon;
  final String tooltip;
  final bool isHorizontal;
  final bool isCollapsed;
  final DesktopColorScheme colors;
  final VoidCallback? onTap;

  const DockToggle({super.key, this.icon, required this.tooltip, required this.isHorizontal, required this.isCollapsed, required this.colors, this.onTap});

  @override
  Widget build(BuildContext context) {
    final chevron = isCollapsed
        ? (isHorizontal ? Icons.chevron_right : Icons.keyboard_arrow_down)
        : (isHorizontal ? Icons.chevron_left : Icons.keyboard_arrow_up);

    return Tooltip(
      message: tooltip,
      waitDuration: DesktopTokens.tooltipDelay,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: isHorizontal ? DesktopTokens.collapsedPanelSize : null,
          height: isHorizontal ? null : DesktopTokens.collapsedPanelSize,
          color: colors.surfaceHover,
          child: Icon(chevron, size: DesktopTokens.actionButtonIconSize, color: colors.textSecondary),
        ),
      ),
    );
  }
}

class DockAction {
  final IconData icon;
  final String? tooltip;
  final VoidCallback? onTap;

  const DockAction({required this.icon, this.tooltip, this.onTap});
}
