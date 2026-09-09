import 'package:damilva/core/l10n/app_localizations.dart';
import 'package:damilva/core/router/router.dart';
import 'package:damilva/core/themes/damilva_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:damilva/core/di/app_di.dart' as di;

void main() async {
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Damilva',
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      theme: DamilvaTheme.buildTheme(
        fontFamily: 'Archivo',
        brightness: Brightness.light,
      ),
    );
  }
}
