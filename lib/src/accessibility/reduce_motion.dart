import 'package:flutter/material.dart';

/// A widget that provides access to the user's motion preferences.
///
/// Wraps [MediaQuery] to detect reduced motion settings and provides
/// the result to descendants via an [InheritedWidget].
///
/// Example:
/// ```dart
/// DesktopReduceMotion(
///   child: MyAnimatedWidget(),
/// )
///
/// // In child:
/// final reduceMotion = DesktopReduceMotion.of(context);
/// final duration = reduceMotion ? Duration.zero : Duration(milliseconds: 200);
/// ```
class DesktopReduceMotion extends InheritedWidget {
  /// Whether the user prefers reduced motion.
  final bool reduceMotion;

  /// Creates a reduce motion widget.
  const DesktopReduceMotion({
    super.key,
    required this.reduceMotion,
    required super.child,
  });

  /// Returns whether the user prefers reduced motion.
  static bool of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<DesktopReduceMotion>();
    return widget?.reduceMotion ?? false;
  }

  /// Returns an appropriate animation duration based on motion preferences.
  ///
  /// Returns [Duration.zero] if reduced motion is preferred,
  /// otherwise returns the given [duration].
  static Duration effectiveDuration(BuildContext context, Duration duration) {
    return of(context) ? Duration.zero : duration;
  }

  /// Returns an appropriate animation curve based on motion preferences.
  ///
  /// Returns [Curves.linear] if reduced motion is preferred,
  /// otherwise returns the given [curve].
  static Curve effectiveCurve(BuildContext context, Curve curve) {
    return of(context) ? Curves.linear : curve;
  }

  @override
  bool updateShouldNotify(DesktopReduceMotion oldWidget) =>
      reduceMotion != oldWidget.reduceMotion;
}
