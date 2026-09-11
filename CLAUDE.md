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

## Documentación relacionada
Este archivo se ha fragmentado para no crecer sin límite. Los siguientes ficheros se cargan automáticamente como parte de este contexto:

@docs/architecture.md
@docs/naming-conventions.md
@docs/design-system.md
@docs/workflow.md
@docs/order-rules.md
@docs/screens-spec.md

## Notas
- Actualizar este archivo (o el doc correspondiente en `docs/`) a medida que se tomen nuevas decisiones (convención final de testing, si se usa Freezed, etc.).
- Si Claude Code pide algo que ya está respondido aquí o en `docs/`, la frase probablemente es ambigua — conviene revisarla y reformularla.