import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';

/// Defines a panel within a [DesktopPanelGroup].
class PanelDefinition {
  /// Unique identifier for this panel.
  final String id;

  /// Display title shown in the tab bar and title bar.
  final String title;

  /// Icon shown in collapsed state and tab bar.
  final IconData icon;

  /// The child widget to display as panel content.
  final Widget child;

  /// Creates a panel definition.
  const PanelDefinition({required this.id, required this.title, required this.icon, required this.child});
}

class PanelCollapsedIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final DesktopColorScheme colors;
  final VoidCallback? onTap;

  const PanelCollapsedIcon({super.key, required this.icon, required this.title, required this.isActive, required this.colors, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: title,
      waitDuration: DesktopTokens.tooltipDelay,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: DesktopTokens.collapsedPanelSize,
          height: DesktopTokens.collapsedPanelSize,
          color: isActive ? colors.surfaceHover : Colors.transparent,
          child: Icon(icon, size: DesktopTokens.actionButtonIconSize, color: isActive ? colors.accent : colors.textSecondary),
        ),
      ),
    );
  }
}

class PanelTabBar extends StatelessWidget {
  final List<PanelDefinition> panels;
  final String selectedId;
  final DesktopColorScheme colors;
  final ValueChanged<String> onSelect;

  const PanelTabBar({super.key, required this.panels, required this.selectedId, required this.colors, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: DesktopTokens.panelTabBarHeight,
      decoration: BoxDecoration(color: colors.surface, border: Border(bottom: BorderSide(color: colors.border, width: DesktopTokens.borderThin))),
      child: Row(children: [
        for (final p in panels)
          PanelTabItem(panel: p, isActive: p.id == selectedId, colors: colors, onTap: () => onSelect(p.id)),
      ]),
    );
  }
}

class PanelTabItem extends StatelessWidget {
  final PanelDefinition panel;
  final bool isActive;
  final DesktopColorScheme colors;
  final VoidCallback? onTap;

  const PanelTabItem({super.key, required this.panel, required this.isActive, required this.colors, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: panel.title,
      waitDuration: DesktopTokens.tooltipDelay,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceSm),
          decoration: BoxDecoration(
            color: isActive ? colors.surfaceElevated : Colors.transparent,
            border: Border(bottom: BorderSide(color: isActive ? colors.accent : Colors.transparent, width: DesktopTokens.borderThick)),
          ),
          child: Icon(panel.icon, size: DesktopTokens.actionButtonIconSize, color: isActive ? colors.accent : colors.textSecondary),
        ),
      ),
    );
  }
}
