import 'package:damilva/core/l10n/app_localizations.dart';
import 'package:damilva/core/themes/damilva_theme.dart';
import 'package:damilva/features/widgets/notices/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget child) {
  return MaterialApp(
    theme: DamilvaTheme.buildTheme(fontFamily: 'Archivo'),
    localizationsDelegates: [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

Future<BuildContext> _pumpAndCaptureContext(WidgetTester tester) async {
  late BuildContext capturedContext;
  await tester.pumpWidget(
    _app(
      Builder(
        builder: (context) {
          capturedContext = context;
          return const SizedBox();
        },
      ),
    ),
  );
  return capturedContext;
}

void main() {
  testWidgets('shows the message', (tester) async {
    final context = await _pumpAndCaptureContext(tester);

    CustomSnackbar.show(context, message: 'Producto añadido al carrito');
    await tester.pump();

    expect(find.text('Producto añadido al carrito'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('shows the Deshacer action only when onUndo is provided', (
    tester,
  ) async {
    final context = await _pumpAndCaptureContext(tester);

    CustomSnackbar.show(context, message: 'Producto eliminado', onUndo: () {});
    await tester.pump();

    expect(find.text('Deshacer'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('does not show an action when onUndo is null', (tester) async {
    final context = await _pumpAndCaptureContext(tester);

    CustomSnackbar.show(context, message: 'Cambios guardados');
    await tester.pump();

    expect(find.text('Deshacer'), findsNothing);

    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('tapping Deshacer triggers onUndo', (tester) async {
    var undone = false;
    final context = await _pumpAndCaptureContext(tester);

    CustomSnackbar.show(
      context,
      message: 'Producto eliminado',
      onUndo: () => undone = true,
    );
    await tester.pump();

    final action = tester.widget<SnackBarAction>(find.byType(SnackBarAction));
    action.onPressed();
    expect(undone, isTrue);

    await tester.pump(const Duration(seconds: 5));
  });
}
