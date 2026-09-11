# Comandos y workflow

## Comandos
- Analizar código: `flutter analyze`
- Ejecutar tests: `flutter test`
- Generar código (build_runner, si aplica): `dart run build_runner build --delete-conflicting-outputs`
- Ejecutar en Chrome: `flutter run -d chrome`

## Workflow
- Antes de dar una pantalla o feature por terminada: `flutter analyze` y `flutter test` deben pasar sin errores.
- Checklist al crear una pantalla nueva (orden real de trabajo):
  1. Crear el Remote/Local Data Source (capa `data`) y registrarlo en `data_di.dart`
  2. Crear el contrato del repositorio (capa `domain`)
  3. Crear la implementación del repositorio (capa `data`) y registrarla en `data_di.dart`
  4. Crear el/los casos de uso (capa `domain`) y registrarlos en `domain_di.dart`
  5. Crear la UI y, conforme surgen eventos y estados, ir creando el Bloc con Freezed; registrarlo en `presentation_di.dart` y añadir la ruta en `go_router`
- Como el backend se construye conforme se desarrolla cada pantalla (no se usan fakes/mocks): cada feature se completa de principio a fin (data source real → repositorio → caso de uso → UI/Bloc) antes de pasar a la siguiente pantalla. El contrato de repositorio en `domain/` sigue siendo obligatorio aunque no haya mock, precisamente para que `presentation/` nunca dependa de si el dato viene de Docker, Firebase o lo que sea.
