import 'package:flutter/material.dart';
import 'desktop_theme.dart';

/// A complete desktop-styled application widget.
///
/// Wraps [MaterialApp] with desktop theming and provides access to
/// [DesktopTheme] throughout the widget tree.
///
/// Example:
/// ```dart
/// DesktopApp(
///   home: MyDesktopScreen(),
/// )
/// ```
class DesktopApp extends StatefulWidget {
  /// The home screen widget.
  final Widget home;

  /// The theme mode (light, dark, or system).
  final ThemeMode themeMode;

  /// Creates a desktop app.
  const DesktopApp({
    super.key,
    required this.home,
    this.themeMode = ThemeMode.system,
  });

  @override
  State<DesktopApp> createState() => _DesktopAppState();
}

class _DesktopAppState extends State<DesktopApp> {
  @override
  Widget build(BuildContext context) {
    final lightData = DesktopThemeData.light();
    final darkData = DesktopThemeData.dark();
    final activeData = widget.themeMode == ThemeMode.dark ? darkData : lightData;

    return DesktopTheme(
      data: activeData,
      child: MaterialApp(
        theme: lightData.toMaterialTheme(),
        darkTheme: darkData.toMaterialTheme(),
        themeMode: widget.themeMode,
        home: widget.home,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// Provides access to the desktop theme throughout the widget tree.
///
/// Use [DesktopTheme.of] to retrieve the current [DesktopThemeData].
class DesktopTheme extends InheritedWidget {
  /// The theme data for this widget subtree.
  final DesktopThemeData data;

  /// Creates a desktop theme widget.
  const DesktopTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Returns the [DesktopThemeData] from the nearest [DesktopTheme] ancestor.
  static DesktopThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<DesktopTheme>();
    assert(widget != null, 'No DesktopTheme found in context');
    return widget!.data;
  }

  @override
  bool updateShouldNotify(DesktopTheme oldWidget) => oldWidget.data != data;
}
