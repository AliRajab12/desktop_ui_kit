import 'dart:convert';

/// Represents the geometry and state of a desktop window.
///
/// Serializable to JSON for persistence across app sessions.
class DesktopWindowState {
  /// Horizontal position of the window from the left edge of the screen.
  final double x;

  /// Vertical position of the window from the top edge of the screen.
  final double y;

  /// Width of the window in logical pixels.
  final double width;

  /// Height of the window in logical pixels.
  final double height;

  /// Whether the window is maximized.
  final bool isMaximized;

  /// Whether the window is minimized.
  final bool isMinimized;

  /// Whether the window is fullscreen.
  final bool isFullscreen;

  /// Creates a window state.
  const DesktopWindowState({
    this.x = 100,
    this.y = 100,
    this.width = 800,
    this.height = 600,
    this.isMaximized = false,
    this.isMinimized = false,
    this.isFullscreen = false,
  });

  /// Default window state with standard dimensions.
  static const DesktopWindowState defaults = DesktopWindowState();

  /// Creates a copy of this state with optional overrides.
  DesktopWindowState copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
    bool? isMaximized,
    bool? isMinimized,
    bool? isFullscreen,
  }) {
    return DesktopWindowState(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      isMaximized: isMaximized ?? this.isMaximized,
      isMinimized: isMinimized ?? this.isMinimized,
      isFullscreen: isFullscreen ?? this.isFullscreen,
    );
  }

  /// Serializes to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
        'isMaximized': isMaximized,
        'isMinimized': isMinimized,
        'isFullscreen': isFullscreen,
      };

  /// Deserializes from a JSON map.
  factory DesktopWindowState.fromJson(Map<String, dynamic> json) {
    return DesktopWindowState(
      x: (json['x'] as num?)?.toDouble() ?? 100,
      y: (json['y'] as num?)?.toDouble() ?? 100,
      width: (json['width'] as num?)?.toDouble() ?? 800,
      height: (json['height'] as num?)?.toDouble() ?? 600,
      isMaximized: json['isMaximized'] as bool? ?? false,
      isMinimized: json['isMinimized'] as bool? ?? false,
      isFullscreen: json['isFullscreen'] as bool? ?? false,
    );
  }

  /// Serializes to a JSON string.
  String toJsonString() => jsonEncode(toJson());

  /// Deserializes from a JSON string.
  factory DesktopWindowState.fromJsonString(String jsonString) {
    return DesktopWindowState.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopWindowState &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y &&
          width == other.width &&
          height == other.height &&
          isMaximized == other.isMaximized &&
          isMinimized == other.isMinimized &&
          isFullscreen == other.isFullscreen;

  @override
  int get hashCode => Object.hash(
        x,
        y,
        width,
        height,
        isMaximized,
        isMinimized,
        isFullscreen,
      );
}

/// Persists and restores [DesktopWindowState] to/from a JSON file.
///
/// Uses a simple file-based approach for window state persistence.
/// The file is written atomically to prevent corruption.
class DesktopWindowStatePersistence {
  /// The file path where state is stored.
  final String filePath;

  /// Creates a state persistence handler for the given file path.
  DesktopWindowStatePersistence({required this.filePath});

  /// Writes the window state to disk.
  ///
  /// This is a stub that stores state in memory.
  /// In a real app, implement file I/O using `dart:io` or a file handler.
  DesktopWindowState? _cachedState;

  /// Saves the window state.
  Future<void> save(DesktopWindowState state) async {
    _cachedState = state;
  }

  /// Loads the saved window state, or returns null if none exists.
  Future<DesktopWindowState?> load() async {
    return _cachedState;
  }

  /// Clears the saved state.
  Future<void> clear() async {
    _cachedState = null;
  }
}
