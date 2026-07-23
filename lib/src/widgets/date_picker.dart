import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app.dart';
import '../theme/colors.dart';
import '../theme/tokens.dart';
import '../theme/typography.dart';

/// A native-styled date picker for desktop applications.
///
/// Displays a text field that opens a calendar popup overlay when tapped.
/// Supports keyboard-first navigation with arrow keys, Enter to select,
/// and Escape to close. Includes month and year navigation controls.
///
/// Example:
/// ```dart
/// DesktopDatePicker(
///   label: 'Due Date',
///   hint: 'Select a date',
///   selectedDate: DateTime(2026, 7, 15),
///   onDateChanged: (date) => print('Selected: $date'),
/// )
/// ```
class DesktopDatePicker extends StatefulWidget {
  /// Label text displayed above the field.
  final String? label;

  /// Placeholder text when no date is selected.
  final String? hint;

  /// The currently selected date, or null if none selected.
  final DateTime? selectedDate;

  /// Callback when the selected date changes.
  final ValueChanged<DateTime>? onDateChanged;

  /// The earliest selectable date, or null for no limit.
  final DateTime? firstDate;

  /// The latest selectable date, or null for no limit.
  final DateTime? lastDate;

  /// Whether the field is disabled.
  final bool disabled;

  /// Creates a date picker field.
  const DesktopDatePicker({
    super.key,
    this.label,
    this.hint,
    this.selectedDate,
    this.onDateChanged,
    this.firstDate,
    this.lastDate,
    this.disabled = false,
  });

  @override
  State<DesktopDatePicker> createState() => _DesktopDatePickerState();
}

class _DesktopDatePickerState extends State<DesktopDatePicker> {
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void didUpdateWidget(DesktopDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate && _overlayEntry != null) {
      _removeOverlay();
      _showOverlay();
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    final themeData = DesktopTheme.of(context);
    _overlayEntry = OverlayEntry(
      builder: (_) => DesktopTheme(
        data: themeData,
        child: _CalendarPopup(
          layerLink: _layerLink,
          selectedDate: widget.selectedDate,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          onDateSelected: (date) {
            widget.onDateChanged?.call(date);
            _removeOverlay();
          },
          onDismiss: _removeOverlay,
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _togglePopup() {
    if (widget.disabled) return;
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;
    final borderColor = _resolveBorderColor(colors);

    return Semantics(
      textField: true,
      enabled: !widget.disabled,
      label: widget.label ?? 'Date picker',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: DesktopTokens.spaceXxs),
              child: Text(
                widget.label!,
                style: typography.label.copyWith(
                  color: widget.disabled ? colors.textDisabled : colors.textPrimary,
                ),
              ),
            ),
          CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              onTap: _togglePopup,
              child: Focus(
                focusNode: _focusNode,
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.enter ||
                        event.logicalKey == LogicalKeyboardKey.space) {
                      _togglePopup();
                      return KeyEventResult.handled;
                    }
                  }
                  return KeyEventResult.ignored;
                },
                child: Container(
                  height: DesktopTokens.inputHeight,
                  decoration: BoxDecoration(
                    color: widget.disabled ? colors.surfaceHover : colors.surface,
                    borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
                    border: Border.all(
                      color: borderColor,
                      width: _focused ? 2 : 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceMd),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: DesktopTokens.iconSm,
                        color: widget.disabled ? colors.textDisabled : colors.textSecondary,
                      ),
                      const SizedBox(width: DesktopTokens.spaceSm),
                      Expanded(
                        child: Text(
                          widget.selectedDate != null
                              ? _formatDate(widget.selectedDate!)
                              : (widget.hint ?? 'Select a date'),
                          style: typography.body.copyWith(
                            color: widget.selectedDate != null
                                ? (widget.disabled ? colors.textDisabled : colors.textPrimary)
                                : colors.textTertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        size: DesktopTokens.iconMd,
                        color: widget.disabled ? colors.textDisabled : colors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _resolveBorderColor(DesktopColorScheme colors) {
    if (widget.disabled) return colors.borderDisabled;
    if (_focused) return colors.borderFocused;
    return colors.border;
  }
}

class _CalendarPopup extends StatefulWidget {
  final LayerLink layerLink;
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onDismiss;

  const _CalendarPopup({
    required this.layerLink,
    required this.selectedDate,
    this.firstDate,
    this.lastDate,
    required this.onDateSelected,
    required this.onDismiss,
  });

  @override
  State<_CalendarPopup> createState() => _CalendarPopupState();
}

class _CalendarPopupState extends State<_CalendarPopup> {
  late DateTime _viewMonth;
  late DateTime _focusedDay;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _viewMonth = DateTime(
      widget.selectedDate?.year ?? DateTime.now().year,
      widget.selectedDate?.month ?? DateTime.now().month,
    );
    _focusedDay = widget.selectedDate ?? DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _previousMonth() {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1);
    });
  }

  void _previousYear() {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year - 1, _viewMonth.month);
    });
  }

  void _nextYear() {
    setState(() {
      _viewMonth = DateTime(_viewMonth.year + 1, _viewMonth.month);
    });
  }

  bool _isDateEnabled(DateTime date) {
    if (widget.firstDate != null && date.isBefore(widget.firstDate!)) return false;
    if (widget.lastDate != null && date.isAfter(widget.lastDate!)) return false;
    return true;
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.escape) {
      widget.onDismiss();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      _moveFocus(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      _moveFocus(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      _moveFocus(-7);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      _moveFocus(7);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      if (_isDateEnabled(_focusedDay)) {
        widget.onDateSelected(_focusedDay);
      }
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _moveFocus(int days) {
    setState(() {
      _focusedDay = _focusedDay.add(Duration(days: days));
      if (_focusedDay.month != _viewMonth.month || _focusedDay.year != _viewMonth.year) {
        _viewMonth = DateTime(_focusedDay.year, _focusedDay.month);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = DesktopTheme.of(context).colors;
    final typography = DesktopTheme.of(context).typography;
    final daysInMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
    final firstWeekday = DateTime(_viewMonth.year, _viewMonth.month, 1).weekday;

    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onDismiss,
          behavior: HitTestBehavior.translucent,
          child: Container(color: Colors.transparent),
        ),
        Positioned(
          top: DesktopTokens.inputHeight + DesktopTokens.spaceXs,
          left: 0,
          child: CompositedTransformFollower(
            link: widget.layerLink,
            showWhenUnlinked: false,
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
              child: Focus(
                focusNode: _focusNode,
                onKeyEvent: _handleKeyEvent,
                child: Container(
                  width: DesktopTokens.datePickerWidth,
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
                    border: Border.all(color: colors.border),
                  ),
                  padding: const EdgeInsets.all(DesktopTokens.spaceSm),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(colors, typography),
                      const SizedBox(height: DesktopTokens.spaceSm),
                      _buildWeekdayLabels(colors, typography),
                      const SizedBox(height: DesktopTokens.spaceXxs),
                      _buildDayGrid(colors, typography, daysInMonth, firstWeekday),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(DesktopColorScheme colors, DesktopTextStyle typography) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];

    return SizedBox(
      height: DesktopTokens.datePickerHeaderHeight,
      child: Row(
        children: [
          _navButton(Icons.chevron_left, _previousMonth, colors),
          _navButton(Icons.keyboard_double_arrow_left, _previousYear, colors),
          Expanded(
            child: Center(
              child: Text(
                '${monthNames[_viewMonth.month - 1]} ${_viewMonth.year}',
                style: typography.label.copyWith(color: colors.textPrimary),
              ),
            ),
          ),
          _navButton(Icons.keyboard_double_arrow_right, _nextYear, colors),
          _navButton(Icons.chevron_right, _nextMonth, colors),
        ],
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap, DesktopColorScheme colors) {
    return SizedBox(
      width: DesktopTokens.datePickerCellSize,
      height: DesktopTokens.datePickerCellSize,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(DesktopTokens.radiusSm),
        child: InkWell(
          borderRadius: BorderRadius.circular(DesktopTokens.radiusSm),
          hoverColor: colors.surfaceHover,
          onTap: onTap,
          child: Icon(icon, size: DesktopTokens.iconSm, color: colors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildWeekdayLabels(DesktopColorScheme colors, DesktopTextStyle typography) {
    const labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Row(
      children: [
        for (final label in labels)
          Expanded(
            child: Center(
              child: Text(
                label,
                style: typography.caption.copyWith(color: colors.textTertiary),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDayGrid(
    DesktopColorScheme colors,
    DesktopTextStyle typography,
    int daysInMonth,
    int firstWeekday,
  ) {
    final cells = <Widget>[];
    final offset = firstWeekday - 1;
    final today = DateTime.now();
    final isCurrentMonth = _viewMonth.year == today.year && _viewMonth.month == today.month;
    final selected = widget.selectedDate;

    for (int i = 0; i < offset; i++) {
      cells.add(const SizedBox(width: DesktopTokens.datePickerCellSize, height: DesktopTokens.datePickerCellSize));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_viewMonth.year, _viewMonth.month, day);
      final isToday = isCurrentMonth && day == today.day;
      final isSelected = selected != null &&
          selected.year == date.year &&
          selected.month == date.month &&
          selected.day == date.day;
      final isFocused = _focusedDay.year == date.year &&
          _focusedDay.month == date.month &&
          _focusedDay.day == date.day;
      final enabled = _isDateEnabled(date);

      cells.add(
        SizedBox(
          width: DesktopTokens.datePickerCellSize,
          height: DesktopTokens.datePickerCellSize,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(DesktopTokens.radiusSm),
            child: InkWell(
              borderRadius: BorderRadius.circular(DesktopTokens.radiusSm),
              hoverColor: enabled ? colors.surfaceHover : null,
              onTap: enabled ? () => widget.onDateSelected(date) : null,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.accent
                      : isFocused
                          ? colors.accent.withAlpha(38)
                          : null,
                  borderRadius: BorderRadius.circular(DesktopTokens.radiusSm),
                  border: isToday && !isSelected
                      ? Border.all(color: colors.accent, width: DesktopTokens.borderThin)
                      : null,
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: typography.bodySmall.copyWith(
                      color: isSelected
                          ? colors.accentText
                          : enabled
                              ? colors.textPrimary
                              : colors.textDisabled,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(
      spacing: 0,
      runSpacing: 0,
      children: cells,
    );
  }
}
