import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';
import '../utils/platform.dart';

/// Renders a keyboard shortcut in a visual format.
///
/// Displays modifier keys (Ctrl, Alt, Shift, ⌘) and key names
/// in platform-adaptive pill-shaped badges.
///
/// Example:
/// ```dart
/// DesktopShortcutLabel(
///   shortcut: LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS),
/// )
/// ```
class DesktopShortcutLabel extends StatelessWidget {
  /// The shortcut to display.
  final LogicalKeySet shortcut;

  /// Font size for the shortcut text. Defaults to [DesktopTokens.caption].
  final double? fontSize;

  /// Text color override.
  final Color? color;

  /// Background color override.
  final Color? backgroundColor;

  /// Creates a shortcut label.
  const DesktopShortcutLabel({
    super.key,
    required this.shortcut,
    this.fontSize,
    this.color,
    this.backgroundColor,
  });

  /// Creates a shortcut label from a list of keys.
  ///
  /// The first key is treated as the primary key, and any modifier keys
  /// (Control, Alt, Shift, Meta) are rendered as modifier badges.
  factory DesktopShortcutLabel.keys({
    Key? key,
    required List<LogicalKeyboardKey> keys,
    double? fontSize,
    Color? color,
    Color? backgroundColor,
  }) {
    return DesktopShortcutLabel(
      key: key,
      shortcut: LogicalKeySet.fromSet(keys.toSet()),
      fontSize: fontSize,
      color: color,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;
    final resolvedColor = color ?? colors.textSecondary;
    final resolvedBg = backgroundColor ?? colors.surfaceContainer;
    final resolvedFontSize = fontSize ?? typography.caption.fontSize ?? 12;
    final keys = _sortKeys(shortcut.keys);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < keys.length; i++) ...[
          if (i > 0) ...[
            SizedBox(width: resolvedFontSize * 0.4),
            Text(
              '+',
              style: TextStyle(
                fontSize: resolvedFontSize,
                color: resolvedColor.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(width: resolvedFontSize * 0.4),
          ],
          _KeyBadge(
            label: _keyLabel(keys[i]),
            fontSize: resolvedFontSize,
            color: resolvedColor,
            backgroundColor: resolvedBg,
          ),
        ],
      ],
    );
  }

  List<LogicalKeyboardKey> _sortKeys(Set<LogicalKeyboardKey> keys) {
    final modifiers = <LogicalKeyboardKey>[];
    final others = <LogicalKeyboardKey>[];
    for (final key in keys) {
      if (_isModifier(key)) {
        modifiers.add(key);
      } else {
        others.add(key);
      }
    }
    return [...modifiers, ...others];
  }

  bool _isModifier(LogicalKeyboardKey key) {
    return key == LogicalKeyboardKey.control ||
        key == LogicalKeyboardKey.shift ||
        key == LogicalKeyboardKey.alt ||
        key == LogicalKeyboardKey.meta ||
        key == LogicalKeyboardKey.controlLeft ||
        key == LogicalKeyboardKey.controlRight ||
        key == LogicalKeyboardKey.shiftLeft ||
        key == LogicalKeyboardKey.shiftRight ||
        key == LogicalKeyboardKey.altLeft ||
        key == LogicalKeyboardKey.altRight ||
        key == LogicalKeyboardKey.metaLeft ||
        key == LogicalKeyboardKey.metaRight;
  }

  String _keyLabel(LogicalKeyboardKey key) {
    final platform = DesktopPlatformUtils.current;
    final isMac = platform == DesktopPlatform.macos;

    if (key == LogicalKeyboardKey.control ||
        key == LogicalKeyboardKey.controlLeft ||
        key == LogicalKeyboardKey.controlRight) {
      return isMac ? '\u2303' : 'Ctrl';
    }
    if (key == LogicalKeyboardKey.alt ||
        key == LogicalKeyboardKey.altLeft ||
        key == LogicalKeyboardKey.altRight) {
      return isMac ? '\u2325' : 'Alt';
    }
    if (key == LogicalKeyboardKey.shift ||
        key == LogicalKeyboardKey.shiftLeft ||
        key == LogicalKeyboardKey.shiftRight) {
      return isMac ? '\u21E7' : 'Shift';
    }
    if (key == LogicalKeyboardKey.meta ||
        key == LogicalKeyboardKey.metaLeft ||
        key == LogicalKeyboardKey.metaRight) {
      return isMac ? '\u2318' : 'Win';
    }

    final keyId = key.keyId;
    if (keyId >= LogicalKeyboardKey.keyA.keyId &&
        keyId <= LogicalKeyboardKey.keyZ.keyId) {
      return String.fromCharCode(keyId - LogicalKeyboardKey.keyA.keyId + (isMac ? 0x24B6 : 0x41));
    }
    if (keyId >= LogicalKeyboardKey.digit0.keyId &&
        keyId <= LogicalKeyboardKey.digit9.keyId) {
      return String.fromCharCode(keyId - LogicalKeyboardKey.digit0.keyId + 0x30);
    }

    return switch (key) {
      LogicalKeyboardKey.enter => 'Enter',
      LogicalKeyboardKey.tab => 'Tab',
      LogicalKeyboardKey.escape => 'Esc',
      LogicalKeyboardKey.backspace => '\u232B',
      LogicalKeyboardKey.delete => 'Del',
      LogicalKeyboardKey.space => 'Space',
      LogicalKeyboardKey.arrowUp => '\u2191',
      LogicalKeyboardKey.arrowDown => '\u2193',
      LogicalKeyboardKey.arrowLeft => '\u2190',
      LogicalKeyboardKey.arrowRight => '\u2192',
      LogicalKeyboardKey.home => 'Home',
      LogicalKeyboardKey.end => 'End',
      LogicalKeyboardKey.pageUp => 'PgUp',
      LogicalKeyboardKey.pageDown => 'PgDn',
      _ => key.keyLabel.toUpperCase(),
    };
  }
}

class _KeyBadge extends StatelessWidget {
  final String label;
  final double fontSize;
  final Color color;
  final Color backgroundColor;

  const _KeyBadge({
    required this.label,
    required this.fontSize,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: fontSize * 0.5,
        vertical: fontSize * 0.2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(DesktopTokens.radiusSm),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: color,
          height: 1,
        ),
      ),
    );
  }
}
