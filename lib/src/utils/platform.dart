import 'package:flutter/foundation.dart';

/// Supported desktop platforms.
enum DesktopPlatform {
  /// Windows platform.
  windows,

  /// macOS platform.
  macos,

  /// Linux platform.
  linux,
}

/// Utility class for detecting and adapting to the current desktop platform.
///
/// Provides platform detection, modifier key identification, and
/// platform-specific formatting.
class DesktopPlatformUtils {
  /// Returns the current desktop platform.
  static DesktopPlatform get current {
    return switch (defaultTargetPlatform) {
      TargetPlatform.windows => DesktopPlatform.windows,
      TargetPlatform.macOS => DesktopPlatform.macos,
      TargetPlatform.linux => DesktopPlatform.linux,
      _ => DesktopPlatform.windows,
    };
  }

  /// Whether the current platform is Windows.
  static bool get isWindows => current == DesktopPlatform.windows;

  /// Whether the current platform is macOS.
  static bool get isMacOS => current == DesktopPlatform.macos;

  /// Whether the current platform is Linux.
  static bool get isLinux => current == DesktopPlatform.linux;

  /// Returns the platform-specific modifier key symbol.
  ///
  /// Returns "⌘" on macOS and "Ctrl" on Windows/Linux.
  static String get modifierKey {
    return switch (current) {
      DesktopPlatform.macos => '\u2318',
      _ => 'Ctrl',
    };
  }

  /// Formats a shortcut label with the platform modifier key.
  ///
  /// Example: `shortcutLabel('S')` returns "⌘ + S" on macOS or "Ctrl + S" elsewhere.
  static String shortcutLabel(String label) {
    return '$modifierKey + $label';
  }
}
