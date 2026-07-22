import 'package:flutter/services.dart';
import 'window_state.dart';

/// Controls a desktop window via platform channels.
///
/// Provides methods to resize, move, minimize, maximize, and close
/// the application window. Requires native platform handlers to be set up
/// in the app's runner code.
///
/// The channel name is `com.desktop_ui_kit/window`.
///
/// ## Platform Setup
///
/// ### Windows (C++)
/// Handle the method channel in `flutter_window.cpp`:
/// ```cpp
/// if (method.channel() == "com.desktop_ui_kit/window") {
///   // Handle: resize, move, minimize, maximize, close, getState, setTitle
/// }
/// ```
///
/// ### macOS (Swift)
/// Handle in `MainFlutterWindow.swift`:
/// ```swift
/// let channel = FlutterMethodChannel(name: "com.desktop_ui_kit/window", binaryMessenger: controller.engine.binaryMessenger)
/// channel.setMethodCallHandler { call, result in ... }
/// ```
///
/// ### Linux (C)
/// Handle in `my_application.cc`:
/// ```c
/// // Use FlMethodChannel to handle window operations
/// ```
class DesktopWindowController {
  static const _channel = MethodChannel('com.desktop_ui_kit/window');
  static const _stateChannel = EventChannel('com.desktop_ui_kit/window/state');

  /// The method channel used for window operations.
  MethodChannel get channel => _channel;

  /// Resizes the window to the given dimensions.
  Future<void> resize(double width, double height) async {
    await _channel.invokeMethod('resize', {
      'width': width,
      'height': height,
    });
  }

  /// Moves the window to the given position.
  Future<void> move(double x, double y) async {
    await _channel.invokeMethod('move', {
      'x': x,
      'y': y,
    });
  }

  /// Resizes and moves the window in a single call.
  Future<void> setBounds(double x, double y, double width, double height) async {
    await _channel.invokeMethod('setBounds', {
      'x': x,
      'y': y,
      'width': width,
      'height': height,
    });
  }

  /// Gets the current window state.
  Future<DesktopWindowState> getState() async {
    final result = await _channel.invokeMapMethod<String, dynamic>('getState');
    return DesktopWindowState.fromJson(result ?? {});
  }

  /// Sets the window title.
  Future<void> setTitle(String title) async {
    await _channel.invokeMethod('setTitle', {'title': title});
  }

  /// Minimizes the window.
  Future<void> minimize() async {
    await _channel.invokeMethod('minimize');
  }

  /// Maximizes the window.
  Future<void> maximize() async {
    await _channel.invokeMethod('maximize');
  }

  /// Restores the window from minimized or maximized state.
  Future<void> restore() async {
    await _channel.invokeMethod('restore');
  }

  /// Closes the window and exits the application.
  Future<void> close() async {
    await _channel.invokeMethod('close');
  }

  /// Enters fullscreen mode.
  Future<void> fullscreen() async {
    await _channel.invokeMethod('fullscreen');
  }

  /// Exits fullscreen mode.
  Future<void> exitFullscreen() async {
    await _channel.invokeMethod('exitFullscreen');
  }

  /// Starts listening for window state change events from the platform.
  ///
  /// Returns a [Stream] of [DesktopWindowState] updates.
  Stream<DesktopWindowState> onStateChanged() {
    return _stateChannel
        .receiveBroadcastStream()
        .where((event) => event is Map)
        .map((event) => DesktopWindowState.fromJson(
              Map<String, dynamic>.from(event as Map),
            ));
  }
}
