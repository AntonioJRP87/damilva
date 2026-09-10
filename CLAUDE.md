# CLAUDE.md

## Stack
- Flutter Web
- Gestión de estado: **Bloc únicamente**. No usar Cubit. **Prohibido usar `setState`** en cualquier pantalla o widget.
- Inyección de dependencias: `get_it`
- Navegación: `go_router`
- Internacionalización: l10n (ARB files), ya configurado
- Backend/API: aún no definido (probablemente Docker más adelante). No bloquear el desarrollo de UI por esto — ver Workflow.
- **No instalar paquetes nuevos de pub.dev sin consultarlo antes.** El stack de dependencias está cerrado a lo ya decidido (bloc, get_it, go_router, freezed, intl). Si una tarea requiere un paquete nuevo, preguntar antes de añadirlo al `pubspec.yaml`.
- Todo el código (nombres de variables, clases, comentarios) va **en inglés**, aunque la comunicación con el usuario sea en español.

## Estructura de carpetas (feature-first)
```
lib/
├── core/
│   ├── themes/
│   │   ├── colors/
│   │   ├── typography/
│   │   └── theme.dart
│   ├── di/
│   │   ├── core_di.dart          (orquesta el orden de inicialización)
│   │   ├── core_data_di.dart     (servicios core de data: Firebase, SharedPreferences, cliente HTTP...)
│   │   ├── core_domain_di.dart   (dependencias core de domain, si las hay)
│   │   ├── data_di.dart          (data sources + repos de TODOS los features)
│   │   ├── domain_di.dart        (casos de uso de TODOS los features)
│   │   └── presentation_di.dart  (blocs de TODOS los features)
│   ├── router/
│   ├── l10n/
│   ├── errors/
│   │   ├── custom/custom_errors.dart
│   │   ├── generic/generic_error.dart
│   │   ├── errors_mapper.dart
│   │   └── app_error.dart
│   ├── result/
│   │   └── result.dart            (pendiente de confirmar contenido exacto)
│   └── extensions/
├── features/
│   └── <feature>/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── enums/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           ├── page/
│           └── widgets/       (solo si es exclusivo de ese feature)
└── shared/
    └── widgets/                (widgets reutilizados por más de un feature)
```
Las subcarpetas de cada capa se crean conforme haga falta, no hay una plantilla fija impuesta de antemano.

## Result
- `core/result/result.dart` → wrapper genérico con Freezed para representar éxito/fallo:
- Uso habitual: `Result<T, AppError>` como tipo de retorno de repositorios y casos de uso (`E` normalmente será `AppError`).
- Igual que `AppError`, es transversal: no se duplica por feature, vive en `core/`.

## Manejo de errores
- `core/errors/custom/custom_errors.dart` → errores personalizados concretos (ej. `CustomErrors`)
- `core/errors/generic/generic_error.dart` → `abstract class GenericError {}`, contrato base que implementan los distintos tipos de error
- `core/errors/errors_mapper.dart` → `ErrorsMapper.mapToError()` convierte un `GenericError` (capa data) en un `AppError` (capa domain)
- `core/errors/app_error.dart` → unión de todos los `AppError` posibles, consumidos en `presentation`
- Este sistema es transversal a todos los features: no se duplica dentro de `features/<feature>/`, todos importan desde `core/errors/`.
- Flujo: data source lanza `GenericError` → repositorio usa `ErrorsMapper` → domain/presentation trabajan siempre con `AppError`.

## Dependency rules
(Aplican dentro de cada feature — ver ejemplo con rutas reales en la sección siguiente)
- `domain` (de cualquier feature) no importa Flutter, Firebase, clientes HTTP, ni ningún paquete de infraestructura. Es Dart puro.
- `data` (de un feature) puede depender del `domain` de ese mismo feature (implementa sus contratos).
- `presentation` (de un feature) puede depender del `domain` de ese mismo feature y de Flutter.
- `core` no depende de código específico de ningún feature.
- Un feature **no puede depender directamente de otro feature**. Si dos features necesitan lo mismo (un modelo, un widget, un caso de uso), ese código se promociona a `core/` o `shared/`, nunca se importa de `features/feature_a/` a `features/feature_b/`.

## Dirección de dependencias
`data`, `domain` y `presentation` no son carpetas de primer nivel: son subcarpetas dentro de cada feature (`features/<feature>/data`, `features/<feature>/domain`, `features/<feature>/presentation`). La regla aplica dentro de cada feature, así:

```
features/<feature>/presentation → features/<feature>/domain → core
features/<feature>/data         → features/<feature>/domain → core
shared/                         → core

features/<feature>/presentation NUNCA importa features/<feature>/data directamente (pasa por domain)
features/<feature>/domain NUNCA importa data ni presentation (ni de su propio feature ni de otro)
core NUNCA importa nada de features/
features/<feature_a> NUNCA importa nada de features/<feature_b>
shared/ NUNCA importa nada de features/
```

Ejemplo concreto con el feature `auth`:
- `features/auth/presentation/bloc/auth_bloc.dart` puede importar `features/auth/domain/usecases/login_use_case.dart` ✅
- `features/auth/presentation/bloc/auth_bloc.dart` puede importar `features/auth/data/...` ❌ (debe pasar por el caso de uso)
- `features/auth/domain/...` puede importar `core/errors/app_error.dart` ✅
- `features/auth/...` puede importar `features/profile/...` ❌ — si `profile` necesita algo de `auth`, ese código se sube a `core/` o `shared/`

Si Claude Code necesita romper alguna de estas reglas para resolver algo, es señal de que el código en cuestión está mal ubicado (probablemente debería subir a `core/` o `shared/`), no de que la regla no aplique.

## Reglas de código
- Bloc para todo el manejo de estado, usando Freezed para eventos/estados. Nunca `setState`, nunca Cubit.
- Toda dependencia (data sources, repositorios, casos de uso, blocs) se registra en `get_it`, dentro del archivo de DI de su capa en `core/di/` (no se crea un archivo de DI por feature; se añade al ya existente, agrupado con un comentario tipo `/// <Feature>`).
- Toda pantalla nueva registra su ruta en `go_router`.
- Todos los textos visibles van vía l10n. Nunca strings hardcodeados en la UI.
- `domain/` es Dart puro: no importa nada de Flutter ni de `data/`. Mantenerlo testable.
- `presentation/` nunca accede directamente a `data/`; siempre pasa por `domain/` (casos de uso / contratos de repositorio).
- Repositorio: contrato abstracto en `domain/repositories/`, implementación en `data/repositories/`.

## Convenciones de nombres

**Capa data**
- Data source (contrato): `<feature>_data_source.dart` → `abstract class <Feature>DataSourceContract`
- Data source (implementación): `<feature>_remote_data_source.dart` / `<feature>_local_data_source.dart` según origen. Devuelve datos "en crudo" o lanza excepciones — **no** devuelve `Result` (eso se maneja en el repositorio).
- Modelos/DTOs: `<entity>_remote_entity.dart`
- Repositorio (implementación): `<feature>_repository_impl.dart`. Envuelve la llamada al data source con un helper `_handleError`, que captura la excepción, la mapea con `ErrorsMapper` y devuelve `Result<T, AppError>`:
  ```dart
  @override
  Future<Result<void, AppError>> login(String email, String pass) async {
    return _handleError(() async {
      await _authDataSource.login(email, pass);
    });
  }
  ```

**Capa domain**
- Entidades: nombre simple, ej. `car.dart`, `order.dart`, `photo.dart`, `user.dart`
- Repositorio (contrato): `<feature>_repository.dart` → `abstract class <Feature>RepositoryContract`
- Casos de uso: `<accion>_use_case.dart`, con patrón Contract + Impl y clase invocable (`call()`):
  ```dart
  abstract class LoginUseCaseContract {
    Future<Result<void, AppError>> call(String email, String pass);
  }

  class LoginUseCase implements LoginUseCaseContract {
    LoginUseCase(this._authRepository);
    final AuthRepositoryContract _authRepository;

    @override
    Future<Result<void, AppError>> call(String email, String pass) async {
      return _authRepository.login(email, pass);
    }
  }
  ```
  Se invocan desde el Bloc como `_loginUseCase.call(...)` (o `_loginUseCase(...)` al ser invocable).

**Capa presentation**
- Bloc: `<feature>_bloc.dart` (+ `<feature>_event.dart`, `<feature>_state.dart`, con Freezed)
- El estado tiene un campo `status` (enum propio del feature: ej. `LoginStatus.initial/loading/success/error`) y un campo `error` de tipo `AppError?`. Se actualiza con `copyWith`.
- Los handlers de evento consultan el `Result` devuelto por el caso de uso con `result.isSuccess` / `result.isFailure` / `result.error`:
  ```dart
  Future<void> _onLogin(Login event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));
    final result = await _loginUseCase.call(state.email, state.pass);
    if (result.isSuccess) {
      emit(state.copyWith(status: LoginStatus.success));
    }
    if (result.isFailure) {
      emit(state.copyWith(status: LoginStatus.error, error: result.error));
    }
  }
  ```
- Page: `<feature>_page.dart`
- Widgets compartidos: `custom_<nombre>.dart`, ej. `custom_elevated_button.dart`, `custom_linear_progress_indicator.dart`

## Design system

**Breakpoints y medidas responsive**
- Definidos en `core/utils/sizes.dart` (`AppSizes`, `DeviceType`) y consumidos vía `core/extensions/sizes_extension.dart` (`context.deviceType`, `context.responsiveMargin`, `context.productGridColumns`, `context.isFilterPanelFixed`, `context.headerIconSize`...). No repetir breakpoints ni magic numbers de márgenes/columnas/iconos en las pantallas: siempre a través de este archivo.
- Móvil (< 600px): 1 columna, márgenes 16px, rejilla de producto a 2 columnas.
- Tableta (600-1023px): márgenes 24px, rejilla a 3 columnas, filtros en panel desplegable.
- Escritorio (≥ 1024px): márgenes 40px, contenido máximo 1280px centrado, rejilla a 4 columnas, filtros en columna fija de 260px.

**Estados de interacción (botones)**
- Reposo: principal con fondo de acento y texto blanco, sin borde. Secundario con borde de 2px tinta y fondo blanco.
- Sobre él (hover): principal con acento un tono más oscuro. Secundario con fondo tinta al 6%.
- Pulsado: acento 600, sin desplazamiento ni escala.
- Foco de teclado: contorno de 2px en acento, separado 2px del control. Nunca el azul por defecto del navegador.
- Deshabilitado: opacidad 45%, sin cursor de puntero.
- Cargando: el botón conserva su ancho, cambia el texto por el de progreso y queda deshabilitado. Nunca desaparece ni colapsa.
- Esta lógica se implementa con `WidgetStateProperty` en el `ButtonStyle` del widget compartido correspondiente (ej. `custom_elevated_button.dart`), no con lógica manual de hover/pressed repetida en cada pantalla.

**Iconografía**
- Librería: Lucide, trazo de 1.6px, sin relleno. Paquete de pub.dev aún sin decidir — no añadir sin consultar antes (ver regla de dependencias en Stack).
- Tamaños, ya definidos en `AppSizes`/`sizes_extension.dart`: 24px en cabecera móvil/tableta, 20px en cabecera escritorio (`context.headerIconSize`); 16-18px junto a texto (`AppSizes.iconSizeInlineSmall` / `iconSizeInlineLarge`); 14px dentro de botón (`AppSizes.iconSizeInButton`).
- El icono hereda el color del texto que acompaña. Solo va en rojo cuando todo el aviso es rojo.

**Alineación**
- Todo alineado a la izquierda, incluida la etiqueta dentro de un botón ancho: el texto empieza en el borde interior izquierdo y el icono se sitúa a la derecha.
- Nada centrado, salvo el logotipo en las pantallas de acceso (login/registro).

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

## Notas
- Actualizar este archivo a medida que se tomen nuevas decisiones (convención final de testing, si se usa Freezed, etc.).
- Si Claude Code pide algo que ya está respondido aquí, la frase probablemente es ambigua — conviene revisarla y reformularla.