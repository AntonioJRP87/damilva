import 'package:damilva/core/themes/damilva_theme.dart';
import 'package:damilva/shared/widgets/notices/custom_notice_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the icon, title and detail', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: DamilvaTheme.buildTheme(fontFamily: 'Archivo'),
        home: const Scaffold(
          body: CustomNoticeBox(
            icon: Icon(Icons.info),
            title: 'Pago pendiente',
            detail: 'Completa el pago antes de que caduque la reserva.',
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.info), findsOneWidget);
    expect(find.text('Pago pendiente'), findsOneWidget);
    expect(
      find.text('Completa el pago antes de que caduque la reserva.'),
      findsOneWidget,
    );
  });

  testWidgets('has a 2px accent border', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: DamilvaTheme.buildTheme(fontFamily: 'Archivo'),
        home: const Scaffold(
          body: CustomNoticeBox(
            icon: Icon(Icons.info),
            title: 'Pago pendiente',
            detail: 'Completa el pago antes de que caduque la reserva.',
          ),
        ),
      ),
    );

    final decoratedBox = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
    final decoration = decoratedBox.decoration as BoxDecoration;
    expect(decoration.border!.top.width, 2);
    expect(decoration.border!.top.color, const Color(0xFFEC3013));
  });
}
