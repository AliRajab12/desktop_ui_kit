import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';

/// Type of toast notification.
enum DesktopToastType {
  /// Informational message.
  info,

  /// Success message.
  success,

  /// Warning message.
  warning,

  /// Error message.
  error,
}

/// A toast notification shown as an overlay.
///
/// Displays temporary messages with auto-dismiss, optional action buttons,
/// and support for stacking multiple toasts.
///
/// Example:
/// ```dart
/// DesktopToast.show(
///   context,
///   message: 'File saved',
///   type: DesktopToastType.success,
///   actionLabel: 'Undo',
///   onAction: () => undo(),
/// );
/// ```
class DesktopToast {
  static final Queue<_ToastEntry> _queue = Queue<_ToastEntry>();
  static final int _maxVisible = 3;

  /// Shows a toast notification.
  ///
  /// [message] is the notification text.
  /// [type] controls the icon and color.
  /// [duration] defaults to 3 seconds.
  /// [actionLabel] and [onAction] add an optional action button.
  static OverlayEntry show(
    BuildContext context, {
    required String message,
    DesktopToastType type = DesktopToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;

    final entry = _ToastEntry(
      message: message,
      type: type,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      colors: colors,
      typography: typography,
    );

    _queue.add(entry);
    _trimQueue();

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (_) => _ToastWidget(
        entry: entry,
        index: _queue.toList().indexOf(entry),
        total: _queue.length,
        onDismiss: () {
          _queue.remove(entry);
          overlayEntry.remove();
        },
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    return overlayEntry;
  }

  static void _trimQueue() {
    while (_queue.length > _maxVisible) {
      _queue.removeFirst();
    }
  }

  /// Clears all visible toasts.
  static void clearAll() {
    _queue.clear();
  }
}

class _ToastEntry {
  final String message;
  final DesktopToastType type;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;
  final dynamic colors;
  final dynamic typography;

  _ToastEntry({
    required this.message,
    required this.type,
    required this.duration,
    this.actionLabel,
    this.onAction,
    required this.colors,
    required this.typography,
  });
}

class _ToastWidget extends StatefulWidget {
  final _ToastEntry entry;
  final int index;
  final int total;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.entry,
    required this.index,
    required this.total,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
    _dismissTimer = Timer(widget.entry.duration, _dismiss);
  }

  void _dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (!mounted) return;
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.entry.colors;
    final typography = widget.entry.typography;
    final offset = 16.0 + widget.index * 64.0;

    return Positioned(
      top: offset,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Semantics(
            liveRegion: true,
            label: '${widget.entry.type.name} notification: ${widget.entry.message}',
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 320,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
                  border: Border.all(color: colors.border),
                  boxShadow: DesktopTokens.elevation(3).map((s) => BoxShadow(
                    blurRadius: s.blurRadius,
                    offset: s.offset,
                    color: s.color,
                  )).toList(),
                ),
                child: Row(
                  children: [
                    Icon(
                      _iconForType(widget.entry.type),
                      size: DesktopTokens.iconSm,
                      color: _colorForType(widget.entry.type),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.entry.message,
                        style: typography.bodySmall.copyWith(
                          color: colors.textPrimary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.entry.actionLabel != null) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: widget.entry.onAction,
                        child: Text(
                          widget.entry.actionLabel!,
                          style: typography.bodySmall.copyWith(
                            color: colors.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: _dismiss,
                      child: Icon(
                        Icons.close,
                        size: DesktopTokens.iconXs,
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconForType(DesktopToastType type) => switch (type) {
        DesktopToastType.info => Icons.info_outline,
        DesktopToastType.success => Icons.check_circle_outline,
        DesktopToastType.warning => Icons.warning_amber_outlined,
        DesktopToastType.error => Icons.error_outline,
      };

  Color _colorForType(DesktopToastType type) => switch (type) {
        DesktopToastType.info => widget.entry.colors.info,
        DesktopToastType.success => widget.entry.colors.success,
        DesktopToastType.warning => widget.entry.colors.warning,
        DesktopToastType.error => widget.entry.colors.danger,
      };
}
