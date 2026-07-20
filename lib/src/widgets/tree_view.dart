import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';

/// A node in a [DesktopTreeView].
///
/// Represents a single item in the tree hierarchy with support for
/// nested children, icons, and custom data.
class TreeNode {
  /// Unique identifier for this node.
  final String key;

  /// Display label for the node.
  final String label;

  /// Optional icon displayed before the label.
  final IconData? icon;

  /// Child nodes nested under this node.
  final List<TreeNode> children;

  /// Whether the node starts expanded.
  final bool initiallyExpanded;

  /// Optional custom data associated with this node.
  final dynamic data;

  /// Creates a tree node.
  const TreeNode({
    required this.key,
    required this.label,
    this.icon,
    this.children = const [],
    this.initiallyExpanded = false,
    this.data,
  });

  /// Whether this node has no children.
  bool get isLeaf => children.isEmpty;
}

/// A native-style tree view for hierarchical data.
///
/// Supports expandable nodes, selection, and custom icons.
/// Use [TreeNode] to define the tree structure.
///
/// Example:
/// ```dart
/// DesktopTreeView(
///   roots: [
///     TreeNode(
///       key: 'root',
///       label: 'Documents',
///       icon: Icons.folder,
///       children: [
///         TreeNode(key: 'doc1', label: 'readme.md'),
///         TreeNode(key: 'doc2', label: 'notes.txt'),
///       ],
///     ),
///   ],
///   onSelect: (key) => print('Selected: $key'),
/// )
/// ```
class DesktopTreeView extends StatefulWidget {
  /// The root-level nodes of the tree.
  final List<TreeNode> roots;

  /// The key of the currently selected node, or null if none selected.
  final String? selectedKey;

  /// Callback when a node is tapped.
  final ValueChanged<String>? onSelect;

  /// Creates a tree view.
  const DesktopTreeView({
    super.key,
    required this.roots,
    this.selectedKey,
    this.onSelect,
  });

  @override
  State<DesktopTreeView> createState() => _DesktopTreeViewState();
}

class _DesktopTreeViewState extends State<DesktopTreeView> {
  final Set<String> _expanded = {};

  @override
  void initState() {
    super.initState();
    for (final node in widget.roots) {
      _initExpand(node);
    }
  }

  void _initExpand(TreeNode node) {
    if (node.initiallyExpanded) _expanded.add(node.key);
    for (final child in node.children) {
      _initExpand(child);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Tree view',
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          for (final root in widget.roots) _buildNode(context, root, 0),
        ],
      ),
    );
  }

  Widget _buildNode(BuildContext context, TreeNode node, int depth) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final isSelected = node.key == widget.selectedKey;
    final isExpanded = _expanded.contains(node.key);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          hoverColor: colors.surfaceHover,
          onTap: () {
            widget.onSelect?.call(node.key);
            if (!node.isLeaf) {
              setState(() {
                if (isExpanded) {
                  _expanded.remove(node.key);
                } else {
                  _expanded.add(node.key);
                }
              });
            }
          },
          child: Container(
            height: DesktopTokens.buttonHeight,
            padding: EdgeInsets.only(
              left: DesktopTokens.spaceLg + depth * 20.0,
              right: DesktopTokens.spaceMd,
            ),
            decoration: BoxDecoration(
              color: isSelected ? colors.accent.withAlpha(38) : null,
            ),
            child: Row(
              children: [
                if (!node.isLeaf)
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.chevron_right,
                    size: DesktopTokens.iconMd,
                    color: colors.textSecondary,
                  )
                else
                  const SizedBox(width: DesktopTokens.iconMd),
                if (node.icon != null) ...[
                  const SizedBox(width: DesktopTokens.spaceXs),
                  Icon(node.icon, size: DesktopTokens.iconSm, color: colors.textSecondary),
                ],
                const SizedBox(width: DesktopTokens.spaceSm),
                Text(node.label, style: typography.bodySmall),
              ],
            ),
          ),
        ),
        if (isExpanded)
          for (final child in node.children) _buildNode(context, child, depth + 1),
      ],
    );
  }
}
