import 'package:flutter/services.dart';

/// Manages application updates via platform-native update mechanisms.
///
/// Provides methods to check for updates, download them, and trigger
/// installation. Delegates to platform-native updaters:
/// - **Windows**: Squirrel/WinSparkle
/// - **macOS**: Sparkle
/// - **Linux**: AppImage/PackageKit
///
/// The channel name is `com.desktop_ui_kit/updater`.
///
/// ## Platform Setup
///
/// Each platform must integrate its native update framework and
/// handle the method channel calls. The Dart side provides the API;
/// the native side connects to the actual update infrastructure.
class DesktopUpdater {
  static const _channel = MethodChannel('com.desktop_ui_kit/updater');
  static const _downloadChannel = EventChannel('com.desktop_ui_kit/updater/download');
  static const _statusChannel = EventChannel('com.desktop_ui_kit/updater/status');

  /// The channel used for platform communication.
  MethodChannel get channel => _channel;

  /// Configures the updater with the update feed URL.
  ///
  /// [feedUrl] is the URL to the update manifest (e.g., appcast.xml for Sparkle).
  /// [currentVersion] is the current app version for comparison.
  Future<void> configure({
    required String feedUrl,
    required String currentVersion,
  }) async {
    await _channel.invokeMethod('configure', {
      'feedUrl': feedUrl,
      'currentVersion': currentVersion,
    });
  }

  /// Checks if an update is available.
  ///
  /// Returns an [DesktopUpdateInfo] if an update is available, or null
  /// if the app is already up to date.
  Future<DesktopUpdateInfo?> checkForUpdate() async {
    final result = await _channel.invokeMapMethod<String, dynamic>('checkForUpdate');
    if (result == null) return null;
    return DesktopUpdateInfo.fromMap(result);
  }

  /// Downloads the available update in the background.
  ///
  /// Returns a [Stream] of download progress (0.0 to 1.0).
  Stream<double> downloadUpdate() {
    return _downloadChannel
        .receiveBroadcastStream()
        .where((event) => event is num)
        .map((event) => (event as num).toDouble().clamp(0.0, 1.0));
  }

  /// Installs the downloaded update and restarts the app.
  ///
  /// This will close the current application and launch the installer.
  Future<void> installUpdate() async {
    await _channel.invokeMethod('installUpdate');
  }

  /// Silently checks for updates and shows a native dialog if one is found.
  Future<void> checkForUpdateWithUI() async {
    await _channel.invokeMethod('checkForUpdateWithUI');
  }

  /// Enables or disables automatic update checks.
  Future<void> setAutoCheck(bool enabled) async {
    await _channel.invokeMethod('setAutoCheck', {'enabled': enabled});
  }

  /// Enables or disables automatic download of updates.
  Future<void> setAutoDownload(bool enabled) async {
    await _channel.invokeMethod('setAutoDownload', {'enabled': enabled});
  }

  /// Gets the current update status.
  Future<DesktopUpdateStatus> getStatus() async {
    final result = await _channel.invokeMethod<String>('getStatus');
    return DesktopUpdateStatus.values.firstWhere(
      (s) => s.name == result,
      orElse: () => DesktopUpdateStatus.idle,
    );
  }

  /// Listens for update status changes.
  Stream<DesktopUpdateStatus> onStatusChanged() {
    return _statusChannel
        .receiveBroadcastStream()
        .where((event) => event is String)
        .map((event) => DesktopUpdateStatus.values.firstWhere(
              (s) => s.name == event,
              orElse: () => DesktopUpdateStatus.idle,
            ));
  }
}

/// Information about an available update.
class DesktopUpdateInfo {
  /// The new version string.
  final String version;

  /// The release notes for this update.
  final String? releaseNotes;

  /// The size of the download in bytes.
  final int? downloadSize;

  /// The URL to the release page.
  final String? releaseUrl;

  /// The date this update was released.
  final DateTime? releaseDate;

  /// Creates update info.
  const DesktopUpdateInfo({
    required this.version,
    this.releaseNotes,
    this.downloadSize,
    this.releaseUrl,
    this.releaseDate,
  });

  /// Creates update info from a platform map.
  factory DesktopUpdateInfo.fromMap(Map<String, dynamic> map) {
    return DesktopUpdateInfo(
      version: map['version'] as String? ?? '',
      releaseNotes: map['releaseNotes'] as String?,
      downloadSize: map['downloadSize'] as int?,
      releaseUrl: map['releaseUrl'] as String?,
      releaseDate: map['releaseDate'] != null
          ? DateTime.tryParse(map['releaseDate'] as String)
          : null,
    );
  }
}

/// The current status of the update process.
enum DesktopUpdateStatus {
  /// No update activity.
  idle,

  /// Checking for updates.
  checking,

  /// An update is available.
  available,

  /// Downloading the update.
  downloading,

  /// The update has been downloaded and is ready to install.
  downloaded,

  /// Installing the update.
  installing,

  /// An error occurred during the update process.
  error,

  /// The app is up to date.
  upToDate,
}
