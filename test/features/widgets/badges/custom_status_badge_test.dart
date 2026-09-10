import 'package:damilva/core/themes/damilva_theme.dart';
import 'package:damilva/features/widgets/badges/custom_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpBadge(WidgetTester tester, Widget badge) {
  return tester.pumpWidget(
    MaterialApp(
      theme: DamilvaTheme.buildTheme(fontFamily: 'Archivo'),
      home: Scaffold(body: badge),
    ),
  );
}

void main() {
  testWidgets('always renders the full status text in uppercase', (
    tester,
  ) async {
    await _pumpBadge(
      tester,
      const CustomStatusBadge(
        label: 'pago en revisión',
        style: StatusBadgeStyle.accent,
      ),
    );

    expect(find.text('PAGO EN REVISIÓN'), findsOneWidget);
  });

  testWidgets('accent style fills the background with accent and white text', (
    tester,
  ) async {
    await _pumpBadge(
      tester,
      const CustomStatusBadge(
        label: 'descuento',
        style: StatusBadgeStyle.accent,
      ),
    );

    final decoratedBox = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decoration = decoratedBox.decoration as BoxDecoration;
    expect(decoration.color, const Color(0xFFEC3013));
    expect(decoration.border!.top.style, BorderStyle.none);

    final text = tester.widget<Text>(find.text('DESCUENTO'));
    expect(text.style?.color, const Color(0xFFFFFFFF));
  });

  testWidgets('outline style has a 2px ink border and no fill', (tester) async {
    await _pumpBadge(
      tester,
      const CustomStatusBadge(
        label: 'enviado',
        style: StatusBadgeStyle.outline,
      ),
    );

    final decoratedBox = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decoration = decoratedBox.decoration as BoxDecoration;
    expect(decoration.color, const Color(0xFFFFFFFF));
    expect(decoration.border!.top.width, 2);
    expect(decoration.border!.top.color, const Color(0xFF201E1D));
  });

  testWidgets('neutral style uses the neutral100 background', (tester) async {
    await _pumpBadge(
      tester,
      const CustomStatusBadge(
        label: 'entregado',
        style: StatusBadgeStyle.neutral,
      ),
    );

    final decoratedBox = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decoration = decoratedBox.decoration as BoxDecoration;
    expect(decoration.color, const Color(0xFFF8F4F4));
  });

  testWidgets('muted reduces the whole badge opacity to 0.55', (tester) async {
    await _pumpBadge(
      tester,
      const CustomStatusBadge(
        label: 'cancelado',
        style: StatusBadgeStyle.neutral,
        muted: true,
      ),
    );

    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, 0.55);
  });

  testWidgets('is not muted by default', (tester) async {
    await _pumpBadge(
      tester,
      const CustomStatusBadge(
        label: 'entregado',
        style: StatusBadgeStyle.neutral,
      ),
    );

    expect(find.byType(Opacity), findsNothing);
  });
}
