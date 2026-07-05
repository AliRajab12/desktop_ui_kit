import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';

class CommandPaletteEntry {
  final String id;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback action;

  const CommandPaletteEntry({
    required this.id,
    required this.title,
    this.subtitle,
    this.icon,
    required this.action,
  });
}

class DesktopCommandPalette extends StatefulWidget {
  final List<CommandPaletteEntry> entries;

  const DesktopCommandPalette({super.key, required this.entries});

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

  List<CommandPaletteEntry> get _filtered {
    final q = _controller.text.toLowerCase();
    if (q.isEmpty) return widget.entries;
    return widget.entries.where((e) {
      return e.title.toLowerCase().contains(q) ||
          (e.subtitle?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _controller.addListener(() => setState(() => _highlightIndex = -1));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final results = _filtered;

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: Material(
          elevation: 12,
          borderRadius: BorderRadius.circular(DesktopTokens.radiusXl),
          color: colors.surfaceContainer,
          surfaceTintColor: Colors.transparent,
          child: Container(
            width: 520,
            constraints: const BoxConstraints(maxHeight: 400),
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
                    onChanged: (_) => setState(() {}),
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
                          child: Text(
                            'No results found',
                            style: typography.bodySmall,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: results.length,
                          itemBuilder: (context, i) {
                            final entry = results[i];
                            final highlighted = i == _highlightIndex;
                            return InkWell(
                              hoverColor: colors.surfaceHover,
                              onTap: () {
                                Navigator.of(context).pop();
                                entry.action();
                              },
                              onHover: (v) {
                                if (v) setState(() => _highlightIndex = i);
                              },
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: DesktopTokens.spaceMd,
                                ),
                                decoration: BoxDecoration(
                                  color: highlighted ? colors.accent.withAlpha(25) : null,
                                ),
                                child: Row(
                                  children: [
                                    if (entry.icon != null) ...[
                                      Icon(
                                        entry.icon,
                                        size: DesktopTokens.iconSm,
                                        color: colors.textSecondary,
                                      ),
                                      const SizedBox(width: DesktopTokens.spaceSm),
                                    ],
                                    Expanded(
                                      child: Text(entry.title, style: typography.bodySmall),
                                    ),
                                    if (entry.subtitle != null)
                                      Text(
                                        entry.subtitle!,
                                        style: typography.caption,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
