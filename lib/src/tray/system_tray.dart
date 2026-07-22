import 'package:flutter/services.dart';

/// Manages the system tray icon and context menu.
///
/// Provides methods to create a tray icon, update it, show context menus,
/// and display notifications. Requires native platform handlers.
///
/// The channel name is `com.desktop_ui_kit/system_tray`.
///
/// ## Platform Setup
///
/// ### Windows
/// Use `Shell_NotifyIcon` from the Windows API.
///
/// ### macOS
/// Use `NSStatusItem` from AppKit.
///
/// ### Linux
/// Use `StatusNotifierItem` from D-Bus.
class DesktopSystemTray {
  static const _channel = MethodChannel('com.desktop_ui_kit/system_tray');
  static const _eventChannel = EventChannel('com.desktop_ui_kit/system_tray/events');

  /// The channel used for platform communication.
  MethodChannel get channel => _channel;

  /// Initializes the system tray with a tray icon.
  ///
  /// [iconPath] is the path to the tray icon image (PNG format recommended).
  /// [tooltip] is the tooltip shown when hovering over the tray icon.
  Future<bool> init({
    required String iconPath,
    String? tooltip,
  }) async {
    final result = await _channel.invokeMethod<bool>('init', {
      'iconPath': iconPath,
      if (tooltip != null) 'tooltip': tooltip,
    });
    return result ?? false;
  }

  /// Updates the tray icon image.
  Future<void> setIcon(String iconPath) async {
    await _channel.invokeMethod('setIcon', {'iconPath': iconPath});
  }

  /// Updates the tray tooltip.
  Future<void> setTooltip(String tooltip) async {
    await _channel.invokeMethod('setTooltip', {'tooltip': tooltip});
  }

  /// Shows a context menu at the tray icon position.
  ///
  /// [items] defines the menu items.
  Future<void> showContextMenu({
    required List<DesktopTrayMenuItem> items,
  }) async {
    await _channel.invokeMethod('showContextMenu', {
      'items': items.map((item) => item.toMap()).toList(),
    });
  }

  /// Shows a notification from the tray icon.
  Future<void> showNotification({
    required String title,
    required String message,
    DesktopTrayNotificationType type = DesktopTrayNotificationType.info,
  }) async {
    await _channel.invokeMethod('showNotification', {
      'title': title,
      'message': message,
      'type': type.name,
    });
  }

  /// Sets the context menu items that appear on right-click.
  Future<void> setContextMenu({
    required List<DesktopTrayMenuItem> items,
  }) async {
    await _channel.invokeMethod('setContextMenu', {
      'items': items.map((item) => item.toMap()).toList(),
    });
  }

  /// Removes the system tray icon.
  Future<void> destroy() async {
    await _channel.invokeMethod('destroy');
  }

  /// Listens for tray events (click, double-click, etc.).
  Stream<DesktopTrayEvent> onEvent() {
    return _eventChannel
        .receiveBroadcastStream()
        .where((event) => event is Map)
        .map((event) => DesktopTrayEvent.fromMap(
              Map<String, dynamic>.from(event as Map),
            ));
  }
}

/// A menu item for the system tray context menu.
class DesktopTrayMenuItem {
  /// The display text for this menu item.
  final String label;

  /// Whether this item is a separator.
  final bool isSeparator;

  /// Whether this item is disabled.
  final bool isDisabled;

  /// Creates a menu item.
  const DesktopTrayMenuItem({
    required this.label,
    this.isSeparator = false,
    this.isDisabled = false,
  });

  /// Creates a separator item.
  const DesktopTrayMenuItem.separator()
      : label = '',
        isSeparator = true,
        isDisabled = false;

  /// Converts to a platform map.
  Map<String, dynamic> toMap() => {
        'label': label,
        'isSeparator': isSeparator,
        'isDisabled': isDisabled,
      };
}

/// Type of system tray notification.
enum DesktopTrayNotificationType {
  info,
  warning,
  error,
}

/// An event from the system tray.
class DesktopTrayEvent {
  /// The event type (e.g., 'click', 'doubleClick', 'rightClick').
  final String type;

  /// The index of the selected menu item, if applicable.
  final int? itemIndex;

  /// Creates a tray event.
  const DesktopTrayEvent({
    required this.type,
    this.itemIndex,
  });

  /// Creates an event from a platform map.
  factory DesktopTrayEvent.fromMap(Map<String, dynamic> map) {
    return DesktopTrayEvent(
      type: map['type'] as String? ?? '',
      itemIndex: map['itemIndex'] as int?,
    );
  }
}
