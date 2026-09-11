import 'package:damilva/core/themes/damilva_theme.dart';
import 'package:damilva/shared/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpButton(WidgetTester tester, Widget button) {
  return tester.pumpWidget(
    MaterialApp(
      theme: DamilvaTheme.buildTheme(fontFamily: 'Archivo'),
      home: Scaffold(body: button),
    ),
  );
}

final _visibleContent = find.byKey(
  const ValueKey('custom_button_visible_content'),
);

Finder _visibleText(String text) =>
    find.descendant(of: _visibleContent, matching: find.text(text));

void main() {
  testWidgets('shows the label in uppercase', (tester) async {
    await _pumpButton(
      tester,
      CustomButton(label: 'continuar', onPressed: () {}),
    );

    expect(_visibleText('CONTINUAR'), findsOneWidget);
  });

  testWidgets('calls onPressed when tapped', (tester) async {
    var tapped = false;
    await _pumpButton(
      tester,
      CustomButton(label: 'continuar', onPressed: () => tapped = true),
    );

    await tester.tap(find.byType(CustomButton));
    expect(tapped, isTrue);
  });

  testWidgets('does not call onPressed when disabled', (tester) async {
    await _pumpButton(
      tester,
      CustomButton(label: 'continuar', onPressed: null),
    );

    await tester.tap(find.byType(CustomButton), warnIfMissed: false);
    final elevatedButton = tester.widget<ElevatedButton>(
      find.byType(ElevatedButton),
    );
    expect(elevatedButton.enabled, isFalse);
  });

  testWidgets('shows loadingLabel and disables tap while loading', (
    tester,
  ) async {
    var tapped = false;
    await _pumpButton(
      tester,
      CustomButton(
        label: 'continuar',
        onPressed: () => tapped = true,
        isLoading: true,
        loadingLabel: 'enviando',
      ),
    );

    expect(_visibleText('ENVIANDO'), findsOneWidget);
    expect(_visibleText('CONTINUAR'), findsNothing);

    await tester.tap(find.byType(CustomButton), warnIfMissed: false);
    expect(tapped, isFalse);
  });

  testWidgets('keeps the same width switching between label and loadingLabel', (
    tester,
  ) async {
    await _pumpButton(
      tester,
      CustomButton(
        label: 'continuar',
        onPressed: () {},
        loadingLabel: 'enviando el pedido ahora mismo',
        fullWidth: false,
      ),
    );

    final idleWidth = tester.getSize(find.byType(CustomButton)).width;

    await _pumpButton(
      tester,
      CustomButton(
        label: 'continuar',
        onPressed: () {},
        isLoading: true,
        loadingLabel: 'enviando el pedido ahora mismo',
        fullWidth: false,
      ),
    );

    final loadingWidth = tester.getSize(find.byType(CustomButton)).width;

    expect(loadingWidth, idleWidth);
  });
}
