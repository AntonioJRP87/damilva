# Arquitectura

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
