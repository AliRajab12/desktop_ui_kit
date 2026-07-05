import 'package:flutter/material.dart';
import 'desktop_theme.dart';

class DesktopApp extends StatefulWidget {
  final Widget home;
  final ThemeMode themeMode;

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
    final data = DesktopThemeData.light();
    return DesktopTheme(
      data: data,
      child: MaterialApp(
        theme: data.toMaterialTheme(),
        darkTheme: DesktopThemeData.dark().toMaterialTheme(),
        themeMode: widget.themeMode,
        home: widget.home,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class DesktopTheme extends InheritedWidget {
  final DesktopThemeData data;

  const DesktopTheme({
    super.key,
    required this.data,
    required super.child,
  });

  static DesktopThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<DesktopTheme>();
    assert(widget != null, 'No DesktopTheme found in context');
    return widget!.data;
  }

  @override
  bool updateShouldNotify(DesktopTheme oldWidget) => oldWidget.data != data;
}
