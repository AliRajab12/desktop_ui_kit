import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';

/// A native-styled modal dialog for desktop applications.
///
/// Provides a title bar with close button, content area, and action buttons.
/// Use [show] to display the dialog as a modal overlay.
///
/// Example:
/// ```dart
/// DesktopDialog.show(context, DesktopDialog(
///   title: 'Confirm',
///   content: Text('Are you sure?'),
///   actions: [
///     DesktopButton(
///       label: 'Cancel',
///       variant: DesktopButtonVariant.secondary,
///       onPressed: () => Navigator.pop(context),
///     ),
///     DesktopButton(
///       label: 'OK',
///       onPressed: () => Navigator.pop(context, true),
///     ),
///   ],
/// ));
/// ```
class DesktopDialog extends StatelessWidget {
  /// The dialog title displayed in the header.
  final String title;

  /// The main content widget.
  final Widget content;

  /// Action buttons displayed in the footer.
  final List<Widget> actions;

  /// Optional fixed width. Defaults to 420.
  final double? width;

  /// Optional fixed height. If null, sizes to content.
  final double? height;

  /// Creates a desktop dialog.
  const DesktopDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.width = 420,
    this.height,
  });

  /// Shows the dialog as a modal overlay.
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
                    const DesktopCloseButton(),
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

/// A close button for dialogs and panels.
///
/// Displays an X icon that closes the current route when tapped.
class DesktopCloseButton extends StatelessWidget {
  /// Creates a close button.
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
