import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';

/// Shared input decoration utilities for text fields and dropdowns.
///
/// Extracts duplicated border color resolution, label rendering,
/// and error text rendering used by DesktopTextField and DesktopDropdown.
class DesktopInputDecorator {
  DesktopInputDecorator._();

  /// Resolves the border color based on input state.
  static Color resolveBorderColor({
    required DesktopColorScheme colors,
    required bool hasError,
    required bool focused,
    required bool disabled,
  }) {
    if (hasError) return colors.danger;
    if (focused) return colors.borderFocused;
    if (disabled) return colors.borderDisabled;
    return colors.border;
  }

  /// Builds the label widget displayed above the input.
  static Widget? buildLabel(String? label, bool disabled, DesktopColorScheme colors, DesktopTextStyle typography) {
    if (label == null) return null;
    return Padding(
      padding: const EdgeInsets.only(bottom: DesktopTokens.spaceXs),
      child: Text(label, style: typography.label.copyWith(color: disabled ? colors.textDisabled : colors.textPrimary)),
    );
  }

  /// Builds the error message widget displayed below the input.
  static Widget? buildErrorText(String? error, DesktopTextStyle typography, DesktopColorScheme colors) {
    if (error == null) return null;
    return Padding(
      padding: const EdgeInsets.only(top: DesktopTokens.spaceXs),
      child: Text(error, style: typography.caption.copyWith(color: colors.danger)),
    );
  }

  /// Builds the helper text widget displayed below the input.
  static Widget? buildHelperText(String? helper, bool hasError, DesktopTextStyle typography, DesktopColorScheme colors) {
    if (helper == null || hasError) return null;
    return Padding(
      padding: const EdgeInsets.only(top: DesktopTokens.spaceXs),
      child: Text(helper, style: typography.caption.copyWith(color: colors.textTertiary)),
    );
  }
}
