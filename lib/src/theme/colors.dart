import 'dart:ui';

/// A complete color scheme for desktop UI styling.
///
/// Contains all colors needed for widgets including surface, text, border,
/// accent, and semantic colors (danger, warning, success, info).
/// Use [light] or [dark] for built-in schemes.
class DesktopColorScheme {
  /// Primary accent color.
  final Color accent;

  /// Accent color on hover.
  final Color accentHover;

  /// Accent color when pressed.
  final Color accentPressed;

  /// Text color on accent backgrounds.
  final Color accentText;

  /// Default surface background color.
  final Color surface;

  /// Surface color on hover.
  final Color surfaceHover;

  /// Surface color when pressed.
  final Color surfacePressed;

  /// Container background for elevated surfaces.
  final Color surfaceContainer;

  /// Elevated surface background color.
  final Color surfaceElevated;

  /// Primary text color.
  final Color textPrimary;

  /// Secondary/muted text color.
  final Color textSecondary;

  /// Tertiary/placeholder text color.
  final Color textTertiary;

  /// Disabled text color.
  final Color textDisabled;

  /// Default border color.
  final Color border;

  /// Border color when focused.
  final Color borderFocused;

  /// Disabled border color.
  final Color borderDisabled;

  /// Danger/error color for destructive actions.
  final Color danger;

  /// Danger color on hover.
  final Color dangerHover;

  /// Danger color when pressed.
  final Color dangerPressed;

  /// Text color on danger backgrounds.
  final Color dangerText;

  /// Warning color for caution states.
  final Color warning;

  /// Text color on warning backgrounds.
  final Color warningText;

  /// Success color for positive states.
  final Color success;

  /// Text color on success backgrounds.
  final Color successText;

  /// Info color for informational states.
  final Color info;

  /// Text color on info backgrounds.
  final Color infoText;

  /// Backdrop/overlay color.
  final Color backdrop;

  /// Whether this is a dark theme.
  final bool isDark;

  /// Creates a color scheme with the given colors.
  const DesktopColorScheme({
    required this.accent,
    required this.accentHover,
    required this.accentPressed,
    required this.accentText,
    required this.surface,
    required this.surfaceHover,
    required this.surfacePressed,
    required this.surfaceContainer,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.border,
    required this.borderFocused,
    required this.borderDisabled,
    required this.danger,
    required this.dangerHover,
    required this.dangerPressed,
    required this.dangerText,
    required this.warning,
    required this.warningText,
    required this.success,
    required this.successText,
    required this.info,
    required this.infoText,
    required this.backdrop,
    required this.isDark,
  });

  static const _accent = Color(0xFF0066CC);
  static const _accentDark = Color(0xFF4CA3FF);
  static const _danger = Color(0xFFD32F2F);
  static const _dangerDark = Color(0xFFFF6B6B);
  static const _warning = Color(0xFFF59E0B);
  static const _success = Color(0xFF10B981);
  static const _info = Color(0xFF3B82F6);

  /// Built-in light color scheme.
  static const DesktopColorScheme light = DesktopColorScheme(
    accent: _accent,
    accentHover: Color(0xFF0052A3),
    accentPressed: Color(0xFF003D7A),
    accentText: Color(0xFFFFFFFF),
    surface: Color(0xFFF9FAFB),
    surfaceHover: Color(0xFFF3F4F6),
    surfacePressed: Color(0xFFE5E7EB),
    surfaceContainer: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF4B5563),
    textTertiary: Color(0xFF9CA3AF),
    textDisabled: Color(0xFFD1D5DB),
    border: Color(0xFFD1D5DB),
    borderFocused: _accent,
    borderDisabled: Color(0xFFE5E7EB),
    danger: _danger,
    dangerHover: Color(0xFFC62828),
    dangerPressed: Color(0xFFB71C1C),
    dangerText: Color(0xFFFFFFFF),
    warning: _warning,
    warningText: Color(0xFF1C1917),
    success: _success,
    successText: Color(0xFFFFFFFF),
    info: _info,
    infoText: Color(0xFFFFFFFF),
    backdrop: Color(0x33000000),
    isDark: false,
  );

  /// Built-in dark color scheme.
  static const DesktopColorScheme dark = DesktopColorScheme(
    accent: _accentDark,
    accentHover: Color(0xFF66B5FF),
    accentPressed: Color(0xFF80C2FF),
    accentText: Color(0xFF000000),
    surface: Color(0xFF1A1B1E),
    surfaceHover: Color(0xFF25262B),
    surfacePressed: Color(0xFF2C2E33),
    surfaceContainer: Color(0xFF25262B),
    surfaceElevated: Color(0xFF2C2E33),
    textPrimary: Color(0xFFF3F4F6),
    textSecondary: Color(0xFF9CA3AF),
    textTertiary: Color(0xFF6B7280),
    textDisabled: Color(0xFF4B5563),
    border: Color(0xFF3F3F46),
    borderFocused: _accentDark,
    borderDisabled: Color(0xFF27272A),
    danger: _dangerDark,
    dangerHover: Color(0xFFFF8A8A),
    dangerPressed: Color(0xFFFFA8A8),
    dangerText: Color(0xFF000000),
    warning: _warning,
    warningText: Color(0xFF1C1917),
    success: _success,
    successText: Color(0xFFFFFFFF),
    info: _info,
    infoText: Color(0xFFFFFFFF),
    backdrop: Color(0x66000000),
    isDark: true,
  );

  /// High-contrast light color scheme meeting WCAG AAA (7:1) contrast ratios.
  static const DesktopColorScheme highContrastLight = DesktopColorScheme(
    accent: Color(0xFF0000CC),
    accentHover: Color(0xFF000099),
    accentPressed: Color(0xFF000066),
    accentText: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceHover: Color(0xFFF0F0F0),
    surfacePressed: Color(0xFFE0E0E0),
    surfaceContainer: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF000000),
    textSecondary: Color(0xFF1A1A1A),
    textTertiary: Color(0xFF333333),
    textDisabled: Color(0xFF767676),
    border: Color(0xFF000000),
    borderFocused: Color(0xFF0000CC),
    borderDisabled: Color(0xFF767676),
    danger: Color(0xFFCC0000),
    dangerHover: Color(0xFF990000),
    dangerPressed: Color(0xFF660000),
    dangerText: Color(0xFFFFFFFF),
    warning: Color(0xFF996600),
    warningText: Color(0xFF000000),
    success: Color(0xFF006600),
    successText: Color(0xFFFFFFFF),
    info: Color(0xFF0000CC),
    infoText: Color(0xFFFFFFFF),
    backdrop: Color(0x66000000),
    isDark: false,
  );

  /// High-contrast dark color scheme meeting WCAG AAA (7:1) contrast ratios.
  static const DesktopColorScheme highContrastDark = DesktopColorScheme(
    accent: Color(0xFF6699FF),
    accentHover: Color(0xFF80AAFF),
    accentPressed: Color(0xFF99BBFF),
    accentText: Color(0xFF000000),
    surface: Color(0xFF000000),
    surfaceHover: Color(0xFF1A1A1A),
    surfacePressed: Color(0xFF333333),
    surfaceContainer: Color(0xFF0D0D0D),
    surfaceElevated: Color(0xFF1A1A1A),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFE0E0E0),
    textTertiary: Color(0xFFBDBDBD),
    textDisabled: Color(0xFF767676),
    border: Color(0xFFFFFFFF),
    borderFocused: Color(0xFF6699FF),
    borderDisabled: Color(0xFF767676),
    danger: Color(0xFFFF6666),
    dangerHover: Color(0xFFFF9999),
    dangerPressed: Color(0xFFFFBBBB),
    dangerText: Color(0xFF000000),
    warning: Color(0xFFFFCC00),
    warningText: Color(0xFF000000),
    success: Color(0xFF66CC66),
    successText: Color(0xFF000000),
    info: Color(0xFF6699FF),
    infoText: Color(0xFF000000),
    backdrop: Color(0x99000000),
    isDark: true,
  );

  /// Creates a copy of this color scheme with optional overrides.
  DesktopColorScheme copyWith({
    Color? accent,
    Color? accentHover,
    Color? accentPressed,
    Color? accentText,
    Color? surface,
    Color? surfaceHover,
    Color? surfacePressed,
    Color? surfaceContainer,
    Color? surfaceElevated,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? border,
    Color? borderFocused,
    Color? borderDisabled,
    Color? danger,
    Color? dangerHover,
    Color? dangerPressed,
    Color? dangerText,
    Color? warning,
    Color? warningText,
    Color? success,
    Color? successText,
    Color? info,
    Color? infoText,
    Color? backdrop,
    bool? isDark,
  }) {
    return DesktopColorScheme(
      accent: accent ?? this.accent,
      accentHover: accentHover ?? this.accentHover,
      accentPressed: accentPressed ?? this.accentPressed,
      accentText: accentText ?? this.accentText,
      surface: surface ?? this.surface,
      surfaceHover: surfaceHover ?? this.surfaceHover,
      surfacePressed: surfacePressed ?? this.surfacePressed,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      border: border ?? this.border,
      borderFocused: borderFocused ?? this.borderFocused,
      borderDisabled: borderDisabled ?? this.borderDisabled,
      danger: danger ?? this.danger,
      dangerHover: dangerHover ?? this.dangerHover,
      dangerPressed: dangerPressed ?? this.dangerPressed,
      dangerText: dangerText ?? this.dangerText,
      warning: warning ?? this.warning,
      warningText: warningText ?? this.warningText,
      success: success ?? this.success,
      successText: successText ?? this.successText,
      info: info ?? this.info,
      infoText: infoText ?? this.infoText,
      backdrop: backdrop ?? this.backdrop,
      isDark: isDark ?? this.isDark,
    );
  }
}
