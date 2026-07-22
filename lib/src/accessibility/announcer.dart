import 'package:flutter/material.dart';

/// Announces messages to screen readers using live regions.
///
/// Wraps a child widget and can announce dynamic messages
/// (e.g., status updates, toasts, loading states) to assistive technologies.
///
/// Uses Flutter's [Semantics] with `liveRegion: true` to announce changes.
///
/// Example:
/// ```dart
/// DesktopAnnouncer(
///   announcement: _lastMessage,
///   child: MyWidget(),
/// )
/// ```
class DesktopAnnouncer extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// The current announcement text. When this changes, screen readers
  /// will be notified of the new message.
  final String? announcement;

  /// Creates an announcer widget.
  const DesktopAnnouncer({
    super.key,
    required this.child,
    this.announcement,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: announcement,
      child: child,
    );
  }
}

/// A widget that displays a temporary announcement overlay.
///
/// Shows a brief message at the bottom of the screen that disappears
/// after a configurable duration.
class DesktopAnnouncementBanner extends StatefulWidget {
  /// The message to display.
  final String message;

  /// How long the banner is visible. Defaults to 3 seconds.
  final Duration duration;

  /// Called when the banner is dismissed.
  final VoidCallback? onDismiss;

  /// Creates an announcement banner.
  const DesktopAnnouncementBanner({
    super.key,
    required this.message,
    this.duration = const Duration(seconds: 3),
    this.onDismiss,
  });

  /// Shows a [DesktopAnnouncementBanner] as an overlay.
  static OverlayEntry show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AnnouncementOverlay(
        message: message,
        duration: duration,
        onDismiss: () => entry.remove(),
      ),
    );
    Overlay.of(context).insert(entry);
    return entry;
  }

  @override
  State<DesktopAnnouncementBanner> createState() => _DesktopAnnouncementBannerState();
}

class _DesktopAnnouncementBannerState extends State<DesktopAnnouncementBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
    Future.delayed(widget.duration, _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _controller.reverse().then((_) {
      widget.onDismiss?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Semantics(
        liveRegion: true,
        label: widget.message,
        child: const SizedBox.shrink(),
      ),
    );
  }
}

class _AnnouncementOverlay extends StatelessWidget {
  final String message;
  final Duration duration;
  final VoidCallback? onDismiss;

  const _AnnouncementOverlay({
    required this.message,
    required this.duration,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      left: 0,
      right: 0,
      child: Center(
        child: DesktopAnnouncementBanner(
          message: message,
          duration: duration,
          onDismiss: onDismiss,
        ),
      ),
    );
  }
}
