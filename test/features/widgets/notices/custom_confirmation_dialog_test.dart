import 'package:damilva/core/l10n/app_localizations.dart';
import 'package:damilva/core/themes/damilva_theme.dart';
import 'package:damilva/features/widgets/notices/custom_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpTrigger(
  WidgetTester tester, {
  required Future<bool> Function(BuildContext) onTrigger,
  required ValueChanged<bool> onResult,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: DamilvaTheme.buildTheme(fontFamily: 'Archivo'),
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return CustomButtonTrigger(
              onPressed: () async => onResult(await onTrigger(context)),
            );
          },
        ),
      ),
    ),
  );
}

class CustomButtonTrigger extends StatelessWidget {
  const CustomButtonTrigger({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: const Text('open'));
  }
}

// CustomButton keeps an invisible copy of its label around (to reserve its
// max width for the loading state), so a plain find.text() always matches
// twice. Scope the search to the visible copy only.
final _visibleButtonContent = find.byKey(
  const ValueKey('custom_button_visible_content'),
);

Finder _visibleButtonText(String text) =>
    find.descendant(of: _visibleButtonContent, matching: find.text(text));

void main() {
  testWidgets('never shows a generic confirm label, always the one passed in', (
    tester,
  ) async {
    bool? result;
    await _pumpTrigger(
      tester,
      onTrigger: (context) => CustomConfirmationDialog.show(
        context,
        title: 'Cancelar pedido',
        message: 'Esta acción no se puede deshacer.',
        confirmLabel: 'Devolver y cancelar',
      ),
      onResult: (value) => result = value,
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(_visibleButtonText('DEVOLVER Y CANCELAR'), findsOneWidget);
    expect(_visibleButtonText('ACEPTAR'), findsNothing);
    expect(_visibleButtonText('CANCELAR'), findsOneWidget);

    await tester.tap(_visibleButtonText('DEVOLVER Y CANCELAR'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });

  testWidgets('tapping cancel resolves to false', (tester) async {
    bool? result;
    await _pumpTrigger(
      tester,
      onTrigger: (context) => CustomConfirmationDialog.show(
        context,
        title: 'Borrar dirección',
        message: 'Esta acción no se puede deshacer.',
        confirmLabel: 'Borrar dirección',
      ),
      onResult: (value) => result = value,
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(_visibleButtonText('CANCELAR'));
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });

  testWidgets('accepts a custom cancel label', (tester) async {
    await _pumpTrigger(
      tester,
      onTrigger: (context) => CustomConfirmationDialog.show(
        context,
        title: 'Borrar dirección',
        message: 'Esta acción no se puede deshacer.',
        confirmLabel: 'Borrar dirección',
        cancelLabel: 'Volver',
      ),
      onResult: (_) {},
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(_visibleButtonText('VOLVER'), findsOneWidget);
    expect(_visibleButtonText('CANCELAR'), findsNothing);
  });
}
