import 'package:flutter/material.dart';
import 'colors.dart';
import 'tokens.dart';
import 'typography.dart';

/// Complete theme data for desktop styling.
///
/// Contains color scheme, typography, and theme mode.
/// Use [DesktopThemeData.light] or [DesktopThemeData.dark] for built-in themes.
class DesktopThemeData {
  /// The color scheme for the theme.
  final DesktopColorScheme colors;

  /// The text styles for the theme.
  final DesktopTextStyle typography;

  /// Whether this is a dark theme.
  final bool isDark;

  /// Creates theme data with the given colors and typography.
  const DesktopThemeData({
    required this.colors,
    required this.typography,
    required this.isDark,
  });

  /// Creates a light theme with platform-adaptive typography.
  factory DesktopThemeData.light() => DesktopThemeData(
        colors: DesktopColorScheme.light,
        typography:
            DesktopTextStyle.platformAdaptive(colorScheme: _lightColorScheme),
        isDark: false,
      );

  /// Creates a dark theme with platform-adaptive typography.
  factory DesktopThemeData.dark() => DesktopThemeData(
        colors: DesktopColorScheme.dark,
        typography:
            DesktopTextStyle.platformAdaptive(colorScheme: _darkColorScheme),
        isDark: true,
      );

  /// Creates a copy of this theme data with optional overrides.
  DesktopThemeData copyWith({
    DesktopColorScheme? colors,
    DesktopTextStyle? typography,
    bool? isDark,
  }) {
    return DesktopThemeData(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      isDark: isDark ?? this.isDark,
    );
  }

  /// Converts to a Material [ThemeData] for use with [MaterialApp].
  ThemeData toMaterialTheme() {
    final base = isDark ? ThemeData.dark() : ThemeData.light();
    return base.copyWith(
      colorScheme: isDark ? _darkColorScheme : _lightColorScheme,
      textTheme: _buildTextTheme(),
      inputDecorationTheme: _buildInputTheme(),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: DesktopTokens.borderNormal,
        space: DesktopTokens.spaceMd,
      ),
      chipTheme: _buildChipTheme(),
      tooltipTheme: _buildTooltipTheme(),
      snackBarTheme: _buildSnackbarTheme(),
    );
  }

  TextTheme _buildTextTheme() {
    final t = typography;
    return TextTheme(
      displayLarge: t.heading1,
      displayMedium: t.heading2,
      displaySmall: t.heading3,
      headlineLarge: t.heading3,
      headlineMedium: t.heading4,
      headlineSmall: t.heading5,
      titleLarge: t.heading6,
      titleMedium: t.label,
      titleSmall: t.caption,
      bodyLarge: t.bodyLarge,
      bodyMedium: t.body,
      bodySmall: t.bodySmall,
      labelLarge: t.label,
      labelMedium: t.caption,
      labelSmall: t.overline,
    );
  }

  InputDecorationTheme _buildInputTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesktopTokens.spaceMd,
        vertical: DesktopTokens.spaceSm,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
        borderSide: BorderSide(color: colors.borderFocused, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
        borderSide: BorderSide(color: colors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
        borderSide: BorderSide(color: colors.danger, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
        borderSide: BorderSide(color: colors.borderDisabled),
      ),
      labelStyle: typography.label,
      hintStyle: typography.body.copyWith(color: colors.textTertiary),
      errorStyle: typography.caption.copyWith(color: colors.danger),
    );
  }

  ChipThemeData _buildChipTheme() {
    return ChipThemeData(
      backgroundColor: colors.surfaceContainer,
      labelStyle: typography.bodySmall,
      side: BorderSide(color: colors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesktopTokens.radiusSm),
      ),
    );
  }

  TooltipThemeData _buildTooltipTheme() {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2E33) : const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
      ),
      textStyle: typography.caption.copyWith(color: const Color(0xFFFFFFFF)),
      padding: const EdgeInsets.symmetric(
        horizontal: DesktopTokens.spaceSm,
        vertical: DesktopTokens.spaceXs,
      ),
    );
  }

  SnackBarThemeData _buildSnackbarTheme() {
    return SnackBarThemeData(
      backgroundColor: isDark ? const Color(0xFF2C2E33) : const Color(0xFF1F2937),
      contentTextStyle: typography.body.copyWith(color: const Color(0xFFFFFFFF)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
      ),
      behavior: SnackBarBehavior.floating,
    );
  }
}

const _lightColorScheme = ColorScheme.light(
  primary: Color(0xFF0066CC),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD6E8FF),
  secondary: Color(0xFF535C68),
  onSecondary: Color(0xFFFFFFFF),
  surface: Color(0xFFF9FAFB),
  onSurface: Color(0xFF111827),
  onSurfaceVariant: Color(0xFF9CA3AF),
  outline: Color(0xFFD1D5DB),
  error: Color(0xFFD32F2F),
  onError: Color(0xFFFFFFFF),
);

const _darkColorScheme = ColorScheme.dark(
  primary: Color(0xFF4CA3FF),
  onPrimary: Color(0xFF000000),
  primaryContainer: Color(0xFF003D7A),
  secondary: Color(0xFFA0A5B0),
  onSecondary: Color(0xFF000000),
  surface: Color(0xFF1A1B1E),
  onSurface: Color(0xFFF3F4F6),
  onSurfaceVariant: Color(0xFF6B7280),
  outline: Color(0xFF3F3F46),
  error: Color(0xFFFF6B6B),
  onError: Color(0xFF000000),
);
