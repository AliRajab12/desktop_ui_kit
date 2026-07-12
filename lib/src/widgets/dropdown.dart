import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';
import 'dropdown_overlay.dart';
import 'input_decorator.dart';

/// A dropdown option for [DesktopDropdown].
///
/// Represents a single selectable item with a value, label, and optional icon.
class DropdownOption<T> {
  /// The underlying value of this option.
  final T value;

  /// Display text for this option.
  final String label;

  /// Optional icon displayed before the label.
  final IconData? icon;

  /// Whether this option is disabled.
  final bool disabled;

  /// Creates a dropdown option.
  const DropdownOption({
    required this.value,
    required this.label,
    this.icon,
    this.disabled = false,
  });
}

/// A native-styled dropdown/select for desktop applications.
///
/// Displays a button that opens a floating panel with selectable options.
/// Supports keyboard navigation, search, and custom option builders.
///
/// Example:
/// ```dart
/// DesktopDropdown<String>(
///   label: 'Country',
///   value: selectedCountry,
///   options: [
///     DropdownOption(value: 'us', label: 'United States'),
///     DropdownOption(value: 'uk', label: 'United Kingdom'),
///   ],
///   onChanged: (value) => setState(() => selectedCountry = value),
/// )
/// ```
class DesktopDropdown<T> extends StatefulWidget {
  /// Label text displayed above the dropdown.
  final String? label;

  /// The currently selected value.
  final T? value;

  /// List of selectable options.
  final List<DropdownOption<T>> options;

  /// Placeholder text when no value is selected.
  final String? hint;

  /// Callback when the selection changes.
  final ValueChanged<T?>? onChanged;

  /// Whether the dropdown is disabled.
  final bool disabled;

  /// Error message to display.
  final String? error;

  /// The minimum width of the dropdown button.
  final double? minWidth;

  /// Creates a dropdown.
  const DesktopDropdown({
    super.key,
    this.label,
    this.value,
    required this.options,
    this.hint,
    this.onChanged,
    this.disabled = false,
    this.error,
    this.minWidth,
  });

  @override
  State<DesktopDropdown<T>> createState() => _DesktopDropdownState<T>();
}

class _DesktopDropdownState<T> extends State<DesktopDropdown<T>> {
  final _focusNode = FocusNode();
  bool _focused = false;
  bool _open = false;
  final _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  DropdownOption<T>? get _selected {
    if (widget.value == null) return null;
    final index = widget.options.indexWhere((o) => o.value == widget.value);
    return index == -1 ? null : widget.options[index];
  }

  void _showDropdown() {
    if (widget.disabled) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => DropdownOverlay<T>(
        layerLink: _layerLink,
        width: size.width,
        options: widget.options,
        selectedValue: widget.value,
        onSelect: (value) {
          entry.remove();
          setState(() => _open = false);
          widget.onChanged?.call(value);
        },
        onClose: () {
          entry.remove();
          setState(() => _open = false);
        },
      ),
    );

    overlay.insert(entry);
    setState(() => _open = true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;
    final hasError = widget.error != null;
    final borderColor = DesktopInputDecorator.resolveBorderColor(
      colors: colors, hasError: hasError, focused: _focused || _open, disabled: widget.disabled,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DesktopInputDecorator.buildLabel(widget.label, widget.disabled, colors, typography),
        CompositedTransformTarget(
          link: _layerLink,
          child: GestureDetector(
            onTap: _showDropdown,
            child: Focus(
              focusNode: _focusNode,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: widget.minWidth ?? 0),
                child: Container(
                  height: DesktopTokens.inputHeight,
                  padding: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceMd),
                  decoration: BoxDecoration(
                    color: widget.disabled ? colors.surfaceHover : colors.surface,
                    borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
                    border: Border.all(color: borderColor, width: (_focused || _open) && !hasError ? 2 : 1),
                  ),
                  child: Row(
                    children: [
                      if (_selected?.icon != null) ...[
                        Icon(_selected!.icon, size: DesktopTokens.iconMd, color: colors.textSecondary),
                        const SizedBox(width: DesktopTokens.spaceSm),
                      ],
                      Expanded(
                        child: Text(
                          _selected?.label ?? widget.hint ?? '',
                          style: typography.body.copyWith(color: _selected != null ? colors.textPrimary : colors.textTertiary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(_open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: DesktopTokens.iconMd, color: colors.textSecondary),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        DesktopInputDecorator.buildErrorText(widget.error, typography, colors),
      ].whereType<Widget>().toList(),
    );
  }
}
