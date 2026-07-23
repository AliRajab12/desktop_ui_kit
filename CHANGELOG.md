# Changelog

## 0.6.0 — Navigation & Date Picker

- Added `DesktopSidebar` vertical navigation rail with compact/expanded modes, section dividers, and custom widget badges
- Added `DesktopDatePicker` with calendar popup, keyboard-first navigation, and month/year controls
- 26 new tests (12 sidebar, 14 date picker)

## 0.5.0 — Window Management, Tray & Updater

- Added `DesktopMultiWindow` for creating and managing secondary application windows with inter-window messaging
- Added `DesktopWindowController` for programmatic window state management
- Added `DesktopWindowState` for configuring window geometry (size, position, title)
- Added `DesktopSystemTray` for system tray icon management, context menus, and notifications
- Added `DesktopUpdater` for platform-native auto-updates (Squirrel on Windows, Sparkle on macOS, AppImage on Linux)
- Added `DesktopAnnouncer` widget for screen reader announcements with live regions
- Added `DesktopAnnouncementBanner` for temporary overlay announcements
- Added `DesktopShortcutLabel` for rendering keyboard shortcuts with platform-adaptive modifier badges (Ctrl/⌘)
- All new widgets include full accessibility support via `Semantics`

## 0.4.0 — Theming Overrides & Accessibility

- Added `copyWith()` to `DesktopThemeData` for selective field overrides
- Added `DesktopThemeOverride` InheritedWidget for overriding colors in any subtree
- `DesktopApp` now accepts `lightColors`/`darkColors` overrides
- Added `DesktopSemantics` wrapper widget with all properties (button, toggled, checked, header, link, selected, expanded, liveRegion, value)
- Added `DesktopFocusIndicator` for visible focus rings
- Added `DesktopReduceMotion` InheritedWidget for motion preference (auto-integrated into `DesktopApp`)
- All 17 existing widgets now include `Semantics` wrappers for screen reader support
- 33 new tests, 139 total passing

## 0.3.1

- Fixed DesktopSplitPanel divider overflow bug (divider thickness now subtracted from available space)
- Exported DesktopResizableDivider from barrel
- Added tests for all layout widgets, CommandPalette, SplitPanel, MenuBar, InputDecorator, FormControl
- 74 tests passing

## 0.3.0 — Layout Widgets

- Added DesktopTabBar with scrollable tabs, close buttons, drag reorder, keyboard navigation
- Added DesktopTabView with animated transitions and lazy loading
- Added DesktopToolbar with buttons, separators, spacers, and custom widgets
- Added DesktopDockPanel with collapse/expand, resizable divider, title bar actions
- Added DesktopPanelGroup for organizing multiple dockable panels
- All layout widgets follow desktop-native styling
- Refactored codebase: all files under 250 lines
- 30 tests passing

## 0.2.0 — Form Controls

- Added DesktopTextField with labels, hints, icons, and validation states
- Added DesktopDropdown with floating overlay and selection support
- Added DesktopCheckbox with indeterminate state
- Added DesktopRadio with group selection
- Added DesktopSwitch with animated toggle
- All form controls follow desktop-native styling
- 30 tests passing

## 0.1.1

- Shortened pubspec description for pub.dev compliance
- Fixed documentation URL to point to GitHub README
- Added dartdoc comments to all public API elements (25%+ coverage)

## 0.1.0 — Initial Release

- Design tokens (spacing, radii, shadows, durations)
- Color palettes for light, dark, and high-contrast modes
- Typography system with platform-adaptive fonts
- DesktopTheme with automatic platform detection
- Platform detection utilities
- Keyboard shortcut handling
- Primary widgets: Button, Dialog
