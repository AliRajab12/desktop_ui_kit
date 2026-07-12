import 'package:desktop_ui_kit/desktop_ui_kit.dart';
import 'package:flutter/material.dart';

/// An entry in the [DesktopCommandPalette].
///
/// Represents a searchable command that can be executed by the user.
class CommandPaletteEntry {
  /// Unique identifier for this command.
  final String id;

  /// Display title of the command.
  final String title;

  /// Optional subtitle or shortcut hint displayed on the right.
  final String? subtitle;

  /// Optional icon displayed before the title.
  final IconData? icon;

  /// Callback executed when the command is selected.
  final VoidCallback action;

  /// Creates a command palette entry.
  const CommandPaletteEntry({
    required this.id,
    required this.title,
    this.subtitle,
    this.icon,
    required this.action,
  });
}

/// A searchable command palette for executing actions.
///
/// Displays a modal dialog with a search field and filterable list of commands.
/// Use [show] to display the palette as a modal overlay.
///
/// Example:
/// ```dart
/// DesktopCommandPalette.show(context, [
///   CommandPaletteEntry(
///     id: 'save',
///     title: 'Save',
///     icon: Icons.save,
///     action: () => save(),
///   ),
/// ]);
/// ```
class DesktopCommandPalette extends StatefulWidget {
  /// The list of available commands to display.
  final List<CommandPaletteEntry> entries;

  /// Creates a command palette widget.
  const DesktopCommandPalette({super.key, required this.entries});

  /// Shows the command palette as a modal dialog.
  static Future<void> show(BuildContext context, List<CommandPaletteEntry> entries) {
    return showDialog(
      context: context,
      builder: (_) => DesktopCommandPalette(entries: entries),
    );
  }

  @override
  State<DesktopCommandPalette> createState() => _DesktopCommandPaletteState();
}

class _DesktopCommandPaletteState extends State<DesktopCommandPalette> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  int _highlightIndex = -1;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _controller.addListener(() => setState(() {
      _query = _controller.text;
      _highlightIndex = -1;
    }));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<CommandPaletteEntry> get _filtered {
    if (_query.isEmpty) return widget.entries;
    final q = _query.toLowerCase();
    return widget.entries.where((e) {
      return e.title.toLowerCase().contains(q) ||
          (e.subtitle?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;
    final results = _filtered;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: DesktopTokens.spaceXxxxl),
        child: Material(
          elevation: 12,
          borderRadius: BorderRadius.circular(DesktopTokens.radiusXl),
          color: colors.surfaceContainer,
          surfaceTintColor: Colors.transparent,
          child: Container(
            width: DesktopTokens.commandPaletteWidth,
            constraints: BoxConstraints(maxHeight: DesktopTokens.commandPaletteMaxHeight),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesktopTokens.radiusXl),
              border: Border.all(color: colors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(DesktopTokens.spaceMd),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: colors.border)),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'Search commands...',
                      prefixIcon: Icon(Icons.search, size: DesktopTokens.iconMd),
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (_) {
                      if (results.isNotEmpty && _highlightIndex >= 0) {
                        final idx = _highlightIndex.clamp(0, results.length - 1);
                        Navigator.of(context).pop();
                        results[idx].action();
                      } else if (results.isNotEmpty) {
                        Navigator.of(context).pop();
                        results[0].action();
                      }
                    },
                  ),
                ),
                Flexible(
                  child: results.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(DesktopTokens.spaceXxl),
                          child: Text('No results found', style: typography.bodySmall),
                        )
                      : _CommandList(results: results, highlightIndex: _highlightIndex, colors: colors, typography: typography),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CommandList extends StatelessWidget {
  final List<CommandPaletteEntry> results;
  final int highlightIndex;
  final DesktopColorScheme colors;
  final DesktopTextStyle typography;

  const _CommandList({required this.results, required this.highlightIndex, required this.colors, required this.typography});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: results.length,
      itemBuilder: (context, i) {
        final entry = results[i];
        final highlighted = i == highlightIndex;
        return InkWell(
          hoverColor: colors.surfaceHover,
          onTap: () {
            Navigator.of(context).pop();
            entry.action();
          },
          child: Container(
            height: DesktopTokens.inputHeight,
            padding: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceMd),
            decoration: BoxDecoration(
              color: highlighted ? colors.accent.withAlpha(25) : null,
            ),
            child: Row(
              children: [
                if (entry.icon != null) ...[
                  Icon(entry.icon, size: DesktopTokens.iconSm, color: colors.textSecondary),
                  const SizedBox(width: DesktopTokens.spaceSm),
                ],
                Expanded(child: Text(entry.title, style: typography.bodySmall)),
                if (entry.subtitle != null) Text(entry.subtitle!, style: typography.caption),
              ],
            ),
          ),
        );
      },
    );
  }
}
