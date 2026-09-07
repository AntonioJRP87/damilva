#!/bin/sh
flutter clean
find . -name "*.freezed.dart" -delete
find . -name "*.g.dart" -delete
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n