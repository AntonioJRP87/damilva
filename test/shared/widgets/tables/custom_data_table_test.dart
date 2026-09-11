import 'package:damilva/core/themes/damilva_theme.dart';
import 'package:damilva/shared/widgets/tables/custom_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

List<DataTableColumn> get _columns => const [
  DataTableColumn(label: 'Pedido'),
  DataTableColumn(label: 'Importe', alignment: DataTableColumnAlignment.end),
];

List<DataTableRow> _rows({VoidCallback? onAction}) => [
  DataTableRow(
    cells: const [Text('#1001'), Text('39,90 €')],
    action: TextButton(onPressed: onAction, child: const Text('Ver factura')),
  ),
];

Future<void> _pumpTable(
  WidgetTester tester, {
  required Size size,
  VoidCallback? onAction,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: DamilvaTheme.buildTheme(fontFamily: 'Archivo'),
      home: Scaffold(
        body: CustomDataTable(
          columns: _columns,
          rows: _rows(onAction: onAction),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('renders as a table on desktop with the header rule', (
    tester,
  ) async {
    await _pumpTable(tester, size: const Size(1200, 800));

    expect(find.text('PEDIDO'), findsOneWidget);
    expect(find.text('IMPORTE'), findsOneWidget);
    expect(find.text('#1001'), findsOneWidget);
    expect(find.text('39,90 €'), findsOneWidget);
    expect(find.text('Ver factura'), findsOneWidget);
  });

  testWidgets('the amount column is right-aligned on desktop', (tester) async {
    await _pumpTable(tester, size: const Size(1200, 800));

    final align = tester.widget<Align>(
      find
          .ancestor(of: find.text('39,90 €'), matching: find.byType(Align))
          .first,
    );
    expect(align.alignment, Alignment.centerRight);
  });

  testWidgets('shows a single action per row on desktop', (tester) async {
    var tapped = false;
    await _pumpTable(
      tester,
      size: const Size(1200, 800),
      onAction: () => tapped = true,
    );

    expect(find.text('Ver factura'), findsOneWidget);
    await tester.tap(find.text('Ver factura'));
    expect(tapped, isTrue);
  });

  testWidgets('renders as a stacked card list on mobile, not a table', (
    tester,
  ) async {
    await _pumpTable(tester, size: const Size(360, 800));

    expect(find.text('PEDIDO'), findsOneWidget);
    expect(find.text('#1001'), findsOneWidget);
    expect(find.text('IMPORTE'), findsOneWidget);
    expect(find.text('39,90 €'), findsOneWidget);
    expect(find.text('Ver factura'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsNothing);
  });
}
