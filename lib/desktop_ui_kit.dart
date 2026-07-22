/// A platform-adaptive desktop widget library for Flutter.
///
/// Provides native OS conventions, keyboard-first navigation, full accessibility,
/// and design tokens for Windows (Fluent), macOS (HIG), and Linux (GNOME/GTK).
library;

export 'src/theme/app.dart';
export 'src/theme/colors.dart';
export 'src/theme/desktop_theme.dart';
export 'src/theme/theme_override.dart';
export 'src/theme/tokens.dart';
export 'src/theme/typography.dart';

export 'src/utils/keyboard.dart';
export 'src/utils/platform.dart';

export 'src/accessibility/semantics.dart';
export 'src/accessibility/focus_indicator.dart';
export 'src/accessibility/reduce_motion.dart';
export 'src/accessibility/announcer.dart';

export 'src/widgets/button.dart';
export 'src/widgets/checkbox.dart';
export 'src/widgets/command_palette.dart';
export 'src/widgets/data_table.dart';
export 'src/widgets/dialog.dart';
export 'src/widgets/dropdown.dart';
export 'src/widgets/form_control.dart';
export 'src/widgets/input_decorator.dart';
export 'src/widgets/menu_bar.dart';
export 'src/widgets/radio.dart';
export 'src/widgets/split_panel.dart';
export 'src/widgets/switch.dart';
export 'src/widgets/text_field.dart';
export 'src/widgets/tree_view.dart';
export 'src/widgets/shortcut_label.dart';

export 'src/layout/tab_bar.dart';
export 'src/layout/tab_view.dart';
export 'src/layout/toolbar.dart';
export 'src/layout/dock_panel.dart';
export 'src/layout/panel_group.dart';
export 'src/layout/resizable_divider.dart';

export 'src/window/window_state.dart';
export 'src/window/window_controller.dart';
export 'src/window/multi_window.dart';
export 'src/tray/system_tray.dart';
export 'src/updater/updater.dart';
