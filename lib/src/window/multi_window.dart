import 'package:flutter/services.dart';
import 'window_state.dart';

/// Creates and manages additional application windows.
///
/// Provides methods to spawn secondary windows, each running its own
/// Flutter view. Requires native platform handlers to be set up.
///
/// The channel name is `com.desktop_ui_kit/multi_window`.
///
/// ## Platform Setup
///
/// Each platform needs to handle `createWindow` by creating a new
/// native window with a Flutter view. The route argument determines
/// which widget to display in the new window.
class DesktopMultiWindow {
  static const _channel = MethodChannel('com.desktop_ui_kit/multi_window');
  static const _messageChannel = EventChannel('com.desktop_ui_kit/multi_window/messages');

  /// Creates a new window with the given configuration.
  ///
  /// [route] is the initial route for the new window's Flutter widget tree.
  /// [state] configures the window geometry.
  /// [title] sets the window title.
  ///
  /// Returns the ID of the newly created window, or null if creation failed.
  static Future<int?> createWindow({
    required String route,
    DesktopWindowState? state,
    String? title,
  }) async {
    final result = await _channel.invokeMethod<int>('createWindow', {
      'route': route,
      if (state != null) 'state': state.toJson(),
      if (title != null) 'title': title,
    });
    return result;
  }

  /// Sends a message to a specific window.
  ///
  /// [windowId] is the target window's ID.
  /// [method] is the message method name.
  /// [arguments] are optional message arguments.
  static Future<dynamic> sendMessage(
    int windowId,
    String method, {
    dynamic arguments,
  }) async {
    return await _channel.invokeMethod('sendMessage', {
      'windowId': windowId,
      'method': method,
      'arguments': arguments,
    });
  }

  /// Closes a specific window by its ID.
  static Future<void> closeWindow(int windowId) async {
    await _channel.invokeMethod('closeWindow', {
      'windowId': windowId,
    });
  }

  /// Gets the list of currently open window IDs.
  static Future<List<int>> getWindowIds() async {
    final result = await _channel.invokeListMethod<int>('getWindowIds');
    return result ?? [];
  }

  /// Listens for messages from other windows.
  ///
  /// Returns a stream of [MultiWindowMessage] events.
  static Stream<MultiWindowMessage> onMessage() {
    return _messageChannel
        .receiveBroadcastStream()
        .where((event) => event is Map)
        .map((event) => MultiWindowMessage.fromMap(
              Map<String, dynamic>.from(event as Map),
            ));
  }
}

/// A message received from another window.
class MultiWindowMessage {
  /// The ID of the window that sent the message.
  final int sourceWindowId;

  /// The message method name.
  final String method;

  /// Optional message arguments.
  final dynamic arguments;

  /// Creates a multi-window message.
  const MultiWindowMessage({
    required this.sourceWindowId,
    required this.method,
    this.arguments,
  });

  /// Creates a message from a platform map.
  factory MultiWindowMessage.fromMap(Map<String, dynamic> map) {
    return MultiWindowMessage(
      sourceWindowId: map['sourceWindowId'] as int? ?? 0,
      method: map['method'] as String? ?? '',
      arguments: map['arguments'],
    );
  }
}
