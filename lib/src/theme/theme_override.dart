import 'package:flutter/material.dart';
import 'app.dart';
import 'colors.dart';
import 'desktop_theme.dart';
import 'typography.dart';

/// A widget that overrides the current [DesktopThemeData] for its subtree.
///
/// Merges the provided overrides with the nearest ancestor [DesktopTheme].
/// Allows per-subtree theming without replacing the entire theme.
///
/// Example:
/// ```dart
/// DesktopThemeOverride(
///   colors: DesktopColorScheme.light.copyWith(accent: Colors.red),
///   child: MyWidget(),
/// )
/// ```
class DesktopThemeOverride extends StatelessWidget {
  /// Optional color scheme override. Merged with parent theme colors.
  final DesktopColorScheme? colors;

  /// Optional typography override. Replaces parent typography entirely.
  final DesktopTextStyle? typography;

  /// The child widget tree that receives the overridden theme.
  final Widget child;

  /// Creates a theme override widget.
  const DesktopThemeOverride({
    super.key,
    this.colors,
    this.typography,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final parent = DesktopTheme.of(context);

    final overrideData = parent.copyWith(
      colors: colors ?? parent.colors,
      typography: typography ?? parent.typography,
    );

    return DesktopTheme(
      data: overrideData,
      child: child,
    );
  }
}
