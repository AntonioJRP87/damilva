import 'package:damilva/core/extensions/context_extension.dart';
import 'package:damilva/core/extensions/sizes_extension.dart';
import 'package:damilva/core/utils/sizes.dart';
import 'package:flutter/material.dart';

enum DataTableColumnAlignment { start, end }

class DataTableColumn {
  const DataTableColumn({
    required this.label,
    this.alignment = DataTableColumnAlignment.start,
  });

  final String label;
  final DataTableColumnAlignment alignment;
}

class DataTableRow {
  const DataTableRow({required this.cells, this.action, this.onTap});

  final List<Widget> cells;
  final Widget? action;
  final VoidCallback? onTap;
}

class CustomDataTable extends StatelessWidget {
  const CustomDataTable({super.key, required this.columns, required this.rows});

  final List<DataTableColumn> columns;
  final List<DataTableRow> rows;

  @override
  Widget build(BuildContext context) {
    return context.isMobile
        ? _DataCardList(columns: columns, rows: rows)
        : _DataTableView(columns: columns, rows: rows);
  }
}

class _DataTableView extends StatelessWidget {
  const _DataTableView({required this.columns, required this.rows});

  final List<DataTableColumn> columns;
  final List<DataTableRow> rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colors.ink,
                width: AppSizes.dataTableHeaderRuleWidth,
              ),
            ),
          ),
          child: SizedBox(
            height: AppSizes.dataTableRowHeight,
            child: _DataTableRowLayout(
              columns: columns,
              cells: [
                for (final column in columns) _HeaderCell(column: column),
              ],
              trailing: const SizedBox(
                width: AppSizes.dataTableActionColumnWidth,
              ),
            ),
          ),
        ),
        for (final row in rows)
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colors.ink.withValues(
                    alpha: AppSizes.dataTableRowDividerAlpha,
                  ),
                  width: AppSizes.dataTableRowDividerWidth,
                ),
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: row.onTap,
                child: SizedBox(
                  height: AppSizes.dataTableRowHeight,
                  child: _DataTableRowLayout(
                    columns: columns,
                    cells: row.cells,
                    trailing: SizedBox(
                      width: AppSizes.dataTableActionColumnWidth,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: row.action,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DataTableRowLayout extends StatelessWidget {
  const _DataTableRowLayout({
    required this.columns,
    required this.cells,
    required this.trailing,
  });

  final List<DataTableColumn> columns;
  final List<Widget> cells;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < columns.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSizes.dataTableCellSpacing),
          Expanded(
            child: Align(
              alignment: columns[i].alignment == DataTableColumnAlignment.end
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: cells[i],
            ),
          ),
        ],
        const SizedBox(width: AppSizes.dataTableCellSpacing),
        trailing,
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.column});

  final DataTableColumn column;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return Text(
      column.label.toUpperCase(),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: typography.text11w800caps.copyWith(color: colors.ink),
    );
  }
}

class _DataCardList extends StatelessWidget {
  const _DataCardList({required this.columns, required this.rows});

  final List<DataTableColumn> columns;
  final List<DataTableRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSizes.dataTableCardSpacing),
          _DataCard(columns: columns, row: rows[i]),
        ],
      ],
    );
  }
}

class _DataCard extends StatelessWidget {
  const _DataCard({required this.columns, required this.row});

  final List<DataTableColumn> columns;
  final DataTableRow row;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: row.onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: colors.ink.withValues(
                alpha: AppSizes.dataTableRowDividerAlpha,
              ),
              width: AppSizes.dataTableRowDividerWidth,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.dataTableCardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < columns.length; i++) ...[
                  if (i > 0)
                    const SizedBox(height: AppSizes.dataTableCardRowSpacing),
                  _DataCardField(column: columns[i], value: row.cells[i]),
                ],
                if (row.action != null) ...[
                  const SizedBox(height: AppSizes.dataTableCardSpacing),
                  Align(alignment: Alignment.centerRight, child: row.action),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DataCardField extends StatelessWidget {
  const _DataCardField({required this.column, required this.value});

  final DataTableColumn column;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    final colors = context.damilvaColors;
    final typography = context.damilvaTypography;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          column.label.toUpperCase(),
          style: typography.text11w800caps.copyWith(color: colors.ink),
        ),
        Flexible(
          child: Align(alignment: Alignment.centerRight, child: value),
        ),
      ],
    );
  }
}
