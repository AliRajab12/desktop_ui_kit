import 'package:flutter/material.dart';

/// A widget that adds semantic information to its child for screen readers.
///
/// Wraps the child with Flutter's [Semantics] widget, providing accessible
/// labels, hints, and roles for assistive technologies.
///
/// Example:
/// ```dart
/// DesktopSemantics(
///   label: 'Save document',
///   hint: 'Double tap to save',
///   button: true,
///   child: MySaveButton(),
/// )
/// ```
class DesktopSemantics extends StatelessWidget {
  /// Accessible label describing the widget.
  final String? label;

  /// Additional hint text for screen readers.
  final String? hint;

  /// Whether this widget is a button.
  final bool button;

  /// Whether this widget is toggled on/off.
  final bool? toggled;

  /// Whether this widget is checked (checkbox).
  final bool? checked;

  /// Whether this widget is selected.
  final bool? selected;

  /// Whether this widget is a link.
  final bool isLink;

  /// Whether this widget is a slider.
  final bool isSlider;

  /// Current slider value as a string.
  final String? value;

  /// Whether this widget is a header.
  final bool isHeader;

  /// Whether this widget is a text field.
  final bool isTextField;

  /// Whether this widget represents a tree node that is expanded.
  final bool? expanded;

  /// Whether to exclude this widget's semantics from the tree.
  final bool excludeSemantics;

  /// Whether this widget has a live region (announces changes).
  final bool liveRegion;

  /// The child widget to wrap.
  final Widget child;

  /// Creates a semantics wrapper widget.
  const DesktopSemantics({
    super.key,
    this.label,
    this.hint,
    this.button = false,
    this.toggled,
    this.checked,
    this.selected,
    this.isLink = false,
    this.isSlider = false,
    this.value,
    this.isHeader = false,
    this.isTextField = false,
    this.expanded,
    this.excludeSemantics = false,
    this.liveRegion = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: button,
      toggled: toggled,
      checked: checked,
      selected: selected,
      link: isLink,
      slider: isSlider,
      value: value,
      header: isHeader,
      textField: isTextField,
      expanded: expanded,
      excludeSemantics: excludeSemantics,
      liveRegion: liveRegion,
      child: child,
    );
  }
}
