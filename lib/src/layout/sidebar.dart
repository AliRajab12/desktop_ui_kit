import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';

/// A navigation item in a [DesktopSidebar].
///
/// Represents a single selectable item with an icon, label, and optional badge.
class SidebarItem {
  /// Unique identifier for this item.
  final String id;

  /// Icon displayed for the item.
  final IconData icon;

  /// Label text displayed next to the icon.
  final String label;

  /// Optional custom badge widget displayed next to the label.
  ///
  /// Commonly used for notification counts or dot indicators.
  /// When null, no badge is shown.
  final Widget? badge;

  /// Creates a sidebar navigation item.
  const SidebarItem({
    required this.id,
    required this.icon,
    required this.label,
    this.badge,
  });
}

/// A group of [SidebarItem]s with an optional section label.
///
/// Items within a section are rendered together. A divider is placed
/// between consecutive sections.
class SidebarSection {
  /// Optional label displayed above the section items.
  final String? label;

  /// The navigation items in this section.
  final List<SidebarItem> items;

  /// Creates a sidebar section.
  const SidebarSection({
    this.label,
    required this.items,
  });
}

/// A vertical navigation rail for desktop applications.
///
/// Supports compact (icon-only) and expanded (icon + label) modes with a
/// toggle button. Navigation items are organized into [SidebarSection]s
/// with optional group labels and dividers between sections.
///
/// Example:
/// ```dart
/// DesktopSidebar(
///   sections: [
///     SidebarSection(items: [
///       SidebarItem(id: 'home', icon: Icons.home, label: 'Home'),
///       SidebarItem(id: 'search', icon: Icons.search, label: 'Search'),
///     ]),
///     SidebarSection(label: 'Tools', items: [
///       SidebarItem(id: 'settings', icon: Icons.settings, label: 'Settings'),
///     ]),
///   ],
///   selectedId: 'home',
///   onSelect: (id) => print('Selected: $id'),
/// )
/// ```
class DesktopSidebar extends StatefulWidget {
  /// Navigation sections containing items.
  final List<SidebarSection> sections;

  /// The ID of the currently selected item, or null if none selected.
  final String? selectedId;

  /// Callback when an item is tapped.
  final ValueChanged<String>? onSelect;

  /// Whether the sidebar starts in expanded mode.
  ///
  /// Defaults to true. When false, starts in compact (icon-only) mode.
  final bool initialExpanded;

  /// Creates a vertical navigation sidebar.
  const DesktopSidebar({
    super.key,
    required this.sections,
    this.selectedId,
    this.onSelect,
    this.initialExpanded = true,
  });

  @override
  State<DesktopSidebar> createState() => _DesktopSidebarState();
}

class _DesktopSidebarState extends State<DesktopSidebar> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initialExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;
    final width = _expanded
        ? DesktopTokens.sidebarExpandedWidth
        : DesktopTokens.sidebarCompactWidth;

    return Semantics(
      label: 'Navigation sidebar',
      child: AnimatedContainer(
        duration: DesktopTokens.durationNormal,
        width: width,
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            right: BorderSide(color: colors.border),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: _buildSections(colors, typography),
              ),
            ),
            _buildToggleButton(colors, typography),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSections(DesktopColorScheme colors, DesktopTextStyle typography) {
    final widgets = <Widget>[];
    for (int s = 0; s < widget.sections.length; s++) {
      final section = widget.sections[s];
      if (s > 0) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesktopTokens.spaceSm,
              vertical: DesktopTokens.spaceXxs,
            ),
            child: Divider(height: 1, color: colors.border),
          ),
        );
      }
      if (section.label != null && _expanded) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesktopTokens.spaceMd,
              vertical: DesktopTokens.spaceXxs,
            ),
            child: SizedBox(
              height: DesktopTokens.sidebarSectionHeight,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  section.label!,
                  style: typography.overline.copyWith(color: colors.textTertiary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      }
      for (final item in section.items) {
        widgets.add(_buildItem(item, colors, typography));
      }
    }
    return widgets;
  }

  Widget _buildItem(SidebarItem item, DesktopColorScheme colors, DesktopTextStyle typography) {
    final isSelected = item.id == widget.selectedId;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: SizedBox(
        height: DesktopTokens.sidebarItemHeight,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            hoverColor: colors.surfaceHover,
            onTap: () => widget.onSelect?.call(item.id),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _expanded ? DesktopTokens.spaceMd : DesktopTokens.spaceSm,
              ),
              child: Row(
                mainAxisAlignment: _expanded ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    size: DesktopTokens.sidebarIconSize,
                    color: isSelected ? colors.accent : colors.textSecondary,
                  ),
                  if (_expanded) ...[
                    const SizedBox(width: DesktopTokens.spaceSm),
                    Expanded(
                      child: Text(
                        item.label,
                        style: typography.bodySmall.copyWith(
                          color: isSelected ? colors.textPrimary : colors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.badge != null) ...[
                      const SizedBox(width: DesktopTokens.spaceXs),
                      item.badge!,
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(DesktopColorScheme colors, DesktopTextStyle typography) {
    return Semantics(
      button: true,
      label: _expanded ? 'Collapse sidebar' : 'Expand sidebar',
      child: SizedBox(
        height: DesktopTokens.sidebarItemHeight,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            hoverColor: colors.surfaceHover,
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _expanded ? DesktopTokens.spaceMd : DesktopTokens.spaceSm,
              ),
              child: Row(
                mainAxisAlignment: _expanded ? MainAxisAlignment.start : MainAxisAlignment.center,
                children: [
                  Icon(
                    _expanded ? Icons.chevron_left : Icons.chevron_right,
                    size: DesktopTokens.sidebarIconSize,
                    color: colors.textSecondary,
                  ),
                  if (_expanded) ...[
                    const SizedBox(width: DesktopTokens.spaceSm),
                    Text(
                      'Collapse',
                      style: typography.bodySmall.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
