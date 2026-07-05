import 'package:flutter/foundation.dart';

enum DesktopPlatform { windows, macos, linux }

class DesktopPlatformUtils {
  static DesktopPlatform get current {
    return switch (defaultTargetPlatform) {
      TargetPlatform.windows => DesktopPlatform.windows,
      TargetPlatform.macOS => DesktopPlatform.macos,
      TargetPlatform.linux => DesktopPlatform.linux,
      _ => DesktopPlatform.windows,
    };
  }

  static bool get isWindows => current == DesktopPlatform.windows;
  static bool get isMacOS => current == DesktopPlatform.macos;
  static bool get isLinux => current == DesktopPlatform.linux;

  static String get modifierKey {
    return switch (current) {
      DesktopPlatform.macos => '\u2318',
      _ => 'Ctrl',
    };
  }

  static String shortcutLabel(String label) {
    return '$modifierKey + $label';
  }
}
