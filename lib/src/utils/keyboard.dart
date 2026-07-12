import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'platform.dart';

/// Defines a keyboard shortcut with an action.
///
/// Use with [DesktopShortcutManager] to handle global keyboard shortcuts.
class DesktopShortcut {
  /// The keyboard key that triggers the shortcut.
  final LogicalKeyboardKey key;

  /// Callback executed when the shortcut is activated.
  final VoidCallback action;

  /// Display label for the shortcut (e.g., "S" for Ctrl+S).
  final String label;

  /// Whether the Shift modifier is required.
  final bool shift;

  /// Whether the Alt/Option modifier is required.
  final bool alt;

  /// Creates a keyboard shortcut.
  const DesktopShortcut({
    required this.key,
    required this.action,
    required this.label,
    this.shift = false,
    this.alt = false,
  });
}

/// Manages global keyboard shortcuts with platform-adaptive modifiers.
///
/// Automatically uses Ctrl on Windows/Linux and Cmd on macOS.
///
/// Example:
/// ```dart
/// DesktopShortcutManager(
///   shortcuts: [
///     DesktopShortcut(
///       key: LogicalKeyboardKey.keyS,
///       action: () => save(),
///       label: 'S',
///     ),
///   ],
///   child: MyScreen(),
/// )
/// ```
class DesktopShortcutManager extends StatelessWidget {
  /// The shortcuts to manage.
  final List<DesktopShortcut> shortcuts;

  /// The child widget that receives focus.
  final Widget child;

  /// Creates a shortcut manager.
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
