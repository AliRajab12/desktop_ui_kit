import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';

class DesktopDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final double? width;
  final double? height;

  const DesktopDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.width = 420,
    this.height,
  });

  static Future<T?> show<T>(BuildContext context, DesktopDialog dialog) {
    return showDialog<T>(
      context: context,
      builder: (_) => dialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(DesktopTokens.radiusXl),
          border: Border.all(color: colors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(DesktopTokens.spaceLg),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: colors.border),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: typography.heading6,
                      ),
                    ),
                    DesktopCloseButton(),
                  ],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(DesktopTokens.spaceLg),
                  child: content,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(DesktopTokens.spaceMd),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: colors.border),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (int i = 0; i < actions.length; i++) ...[
                      if (i > 0) const SizedBox(width: DesktopTokens.spaceSm),
                      actions[i],
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DesktopCloseButton extends StatelessWidget {
  const DesktopCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(DesktopTokens.radiusSm),
        hoverColor: colors.surfaceHover,
        onTap: () => Navigator.of(context).maybePop(),
        child: Padding(
          padding: const EdgeInsets.all(DesktopTokens.spaceXs),
          child: Icon(
            Icons.close,
            size: DesktopTokens.iconMd,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
