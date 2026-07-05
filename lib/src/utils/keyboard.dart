import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'platform.dart';

class DesktopShortcut {
  final LogicalKeyboardKey key;
  final VoidCallback action;
  final String label;
  final bool shift;
  final bool alt;

  const DesktopShortcut({
    required this.key,
    required this.action,
    required this.label,
    this.shift = false,
    this.alt = false,
  });
}

class DesktopShortcutManager extends StatelessWidget {
  final List<DesktopShortcut> shortcuts;
  final Widget child;

  const DesktopShortcutManager({
    super.key,
    required this.shortcuts,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bindings = <ShortcutActivator, VoidCallback>{};
    for (final s in shortcuts) {
      final isMac = DesktopPlatformUtils.isMacOS;
      bindings[SingleActivator(
        s.key,
        control: !isMac,
        meta: isMac,
        shift: s.shift,
        alt: s.alt,
      )] = s.action;
    }
    return CallbackShortcuts(
      bindings: bindings,
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }
}
