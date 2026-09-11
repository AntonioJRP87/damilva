import 'package:damilva/core/di/presentation_di.dart';
import 'package:damilva/core/themes/damilva_theme.dart';
import 'package:damilva/shared/widgets/text_fields/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

String? _requiredValidator(String value) =>
    value.isEmpty ? 'Campo obligatorio' : null;

Future<void> _pumpField(WidgetTester tester, Widget field) {
  return tester.pumpWidget(
    MaterialApp(
      theme: DamilvaTheme.buildTheme(fontFamily: 'Archivo'),
      home: Scaffold(
        body: Column(
          children: [
            field,
            // Somewhere to move focus to, to simulate losing focus on the field.
            const TextField(key: Key('other_field')),
          ],
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    await presentationInitDi();
  });

  testWidgets('shows the label above the field', (tester) async {
    await _pumpField(
      tester,
      const CustomTextField(label: 'Correo electrónico'),
    );

    expect(find.text('Correo electrónico'), findsOneWidget);
  });

  testWidgets('shows the hint text as placeholder', (tester) async {
    await _pumpField(
      tester,
      const CustomTextField(label: 'Correo', hintText: 'nombre@correo.com'),
    );

    expect(find.text('nombre@correo.com'), findsOneWidget);
  });

  testWidgets('does not show an error while typing', (tester) async {
    await _pumpField(
      tester,
      CustomTextField(label: 'Correo', validator: _requiredValidator),
    );

    await tester.tap(find.byType(CustomTextField));
    await tester.enterText(find.byType(CustomTextField), '');
    await tester.pump();

    expect(find.text('Campo obligatorio'), findsNothing);
  });

  testWidgets('shows the error only after losing focus', (tester) async {
    await _pumpField(
      tester,
      CustomTextField(label: 'Correo', validator: _requiredValidator),
    );

    await tester.tap(find.byType(CustomTextField));
    await tester.pump();
    expect(find.text('Campo obligatorio'), findsNothing);

    await tester.tap(find.byKey(const Key('other_field')));
    await tester.pump();

    expect(find.text('Campo obligatorio'), findsOneWidget);
  });

  testWidgets('clears the error as soon as the value is corrected', (
    tester,
  ) async {
    await _pumpField(
      tester,
      CustomTextField(label: 'Correo', validator: _requiredValidator),
    );

    await tester.tap(find.byType(CustomTextField));
    await tester.tap(find.byKey(const Key('other_field')));
    await tester.pump();
    expect(find.text('Campo obligatorio'), findsOneWidget);

    await tester.tap(find.byType(CustomTextField));
    await tester.enterText(find.byType(CustomTextField), 'a');
    await tester.pump();

    expect(find.text('Campo obligatorio'), findsNothing);
  });
}
