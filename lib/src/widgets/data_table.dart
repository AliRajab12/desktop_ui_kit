import 'package:flutter/material.dart';
import '../theme/app.dart';
import '../theme/tokens.dart';

/// Defines a column in a [DesktopDataTable].
///
/// Specifies the column header, width, and cell rendering logic.
class DesktopColumn {
  /// The column header text.
  final String header;

  /// Optional fixed width. If null, uses flexible width.
  final double? width;

  /// Whether the column can be sorted by tapping the header.
  final bool sortable;

  /// Whether the column can be resized by dragging.
  final bool resizable;

  /// Builder function that creates a cell widget for the column's value.
  final Widget Function(dynamic value) cellBuilder;

  /// Creates a data table column definition.
  const DesktopColumn({
    required this.header,
    this.width,
    this.sortable = false,
    this.resizable = false,
    required this.cellBuilder,
  });
}

/// A native-styled data table for displaying tabular data.
///
/// Supports column sorting, row selection, and custom cell rendering.
/// Use [DesktopColumn] to define columns with sortable headers and cell builders.
///
/// Example:
/// ```dart
/// DesktopDataTable(
///   columns: [
///     DesktopColumn(
///       header: 'Name',
///       sortable: true,
///       cellBuilder: (value) => Text(value),
///     ),
///   ],
///   rows: [
///     {'Name': 'Alice'},
///     {'Name': 'Bob'},
///   ],
/// )
/// ```
class DesktopDataTable extends StatefulWidget {
  /// Column definitions for the table.
  final List<DesktopColumn> columns;

  /// Row data as a list of maps. Keys should match column headers.
  final List<Map<String, dynamic>> rows;

  /// Optional field name used as the unique key for each row.
  final String? keyField;

  /// Creates a desktop data table.
  const DesktopDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.keyField,
  });

  @override
  State<DesktopDataTable> createState() => _DesktopDataTableState();
}

class _DesktopDataTableState extends State<DesktopDataTable> {
  int? _sortColumn;
  bool _sortAsc = true;
  int? _selectedIndex;

  List<Map<String, dynamic>> get _sortedRows {
    if (_sortColumn == null) return widget.rows;
    final col = widget.columns[_sortColumn!];
    final key = col.header;
    final sorted = List<Map<String, dynamic>>.from(widget.rows);
    sorted.sort((a, b) {
      final aVal = a[key];
      final bVal = b[key];
      if (aVal == null && bVal == null) return 0;
      if (aVal == null) return 1;
      if (bVal == null) return -1;
      return _sortAsc
          ? Comparable.compare(aVal, bVal)
          : Comparable.compare(bVal, aVal);
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;
    final rows = _sortedRows;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(DesktopTokens.radiusMd),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HeaderRow(
            columns: widget.columns,
            sortColumn: _sortColumn,
            sortAsc: _sortAsc,
            onSort: (i) {
              setState(() {
                if (_sortColumn == i) {
                  _sortAsc = !_sortAsc;
                } else {
                  _sortColumn = i;
                  _sortAsc = true;
                }
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: rows.length,
              itemBuilder: (context, i) {
                final row = rows[i];
                final selected = i == _selectedIndex;
                return InkWell(
                  hoverColor: colors.surfaceHover,
                  onTap: () => setState(() => _selectedIndex = i),
                  child: Container(
                    height: DesktopTokens.buttonHeight,
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesktopTokens.spaceMd,
                    ),
                    decoration: BoxDecoration(
                      color: selected ? colors.accent.withAlpha(38) : null,
                      border: i < rows.length - 1
                          ? Border(bottom: BorderSide(color: colors.border))
                          : null,
                    ),
                    child: Row(
                      children: [
                        for (int c = 0; c < widget.columns.length; c++) ...[
                          if (c > 0)
                            const SizedBox(width: DesktopTokens.spaceMd),
                          SizedBox(
                            width: widget.columns[c].width,
                            child: DefaultTextStyle(
                              style: typography.bodySmall,
                              child: widget.columns[c].cellBuilder(
                                row[widget.columns[c].header],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final List<DesktopColumn> columns;
  final int? sortColumn;
  final bool sortAsc;
  final void Function(int index) onSort;

  const _HeaderRow({
    required this.columns,
    required this.sortColumn,
    required this.sortAsc,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DesktopTheme.of(context);
    final colors = theme.colors;
    final typography = theme.typography;

    return Container(
      height: DesktopTokens.tabHeight,
      padding: const EdgeInsets.symmetric(horizontal: DesktopTokens.spaceMd),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          for (int i = 0; i < columns.length; i++) ...[
            if (i > 0) const SizedBox(width: DesktopTokens.spaceMd),
            SizedBox(
              width: columns[i].width,
              child: GestureDetector(
                onTap: columns[i].sortable ? () => onSort(i) : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(columns[i].header, style: typography.label),
                    if (columns[i].sortable && sortColumn == i)
                      Icon(
                        sortAsc ? Icons.arrow_upward : Icons.arrow_downward,
                        size: DesktopTokens.iconXs,
                        color: colors.textSecondary,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
