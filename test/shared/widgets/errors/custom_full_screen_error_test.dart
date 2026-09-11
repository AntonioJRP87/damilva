import 'package:damilva/core/errors/app_error.dart';
import 'package:damilva/core/l10n/app_localizations.dart';
import 'package:damilva/core/themes/damilva_theme.dart';
import 'package:damilva/shared/widgets/buttons/custom_button.dart';
import 'package:damilva/shared/widgets/errors/custom_full_screen_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

final _retryLabel = find.descendant(
  of: find.byKey(const ValueKey('custom_button_visible_content')),
  matching: find.text('REINTENTAR'),
);

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: DamilvaTheme.buildTheme(fontFamily: 'Archivo'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      ...GlobalMaterialLocalizations.delegates,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('shows the no-connection message for NoInternetConnection', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        CustomFullScreenError(
          error: const AppError.noInternetConnection(),
          onRetry: () {},
        ),
      ),
    );

    expect(find.text('Parece que no hay conexión'), findsOneWidget);
    expect(_retryLabel, findsOneWidget);
  });

  testWidgets('shows the server error message for other errors', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        CustomFullScreenError(error: const AppError.errorServer(), onRetry: () {}),
      ),
    );

    expect(find.text('Algo ha fallado por nuestra parte'), findsOneWidget);
  });

  testWidgets('calls onRetry when the button is pressed', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      _wrap(
        CustomFullScreenError(
          error: const AppError.errorServer(),
          onRetry: () => pressed = true,
        ),
      ),
    );

    await tester.tap(find.byType(CustomButton));
    expect(pressed, isTrue);
  });
}
