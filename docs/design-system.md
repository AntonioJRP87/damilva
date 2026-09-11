# Design system

## Breakpoints y medidas responsive
- Definidos en `core/utils/sizes.dart` (`AppSizes`, `DeviceType`) y consumidos vía `core/extensions/sizes_extension.dart` (`context.deviceType`, `context.responsiveMargin`, `context.productGridColumns`, `context.isFilterPanelFixed`, `context.headerIconSize`...). No repetir breakpoints ni magic numbers de márgenes/columnas/iconos en las pantallas: siempre a través de este archivo.
- Móvil (< 600px): 1 columna, márgenes 16px, rejilla de producto a 2 columnas.
- Tableta (600-1023px): márgenes 24px, rejilla a 3 columnas, filtros en panel desplegable.
- Escritorio (≥ 1024px): márgenes 40px, contenido máximo 1280px centrado, rejilla a 4 columnas, filtros en columna fija de 260px.

## Tipografía

Escala completa (tamaño / peso / tracking / uso). Cada fila corresponde a un campo de `DamilvaTypography` / `DamilvaTypographyExtension` en `core/themes/typography/` (ej. `text64w800`, `text14w600`, `text12w800caps` para versalitas).

| Tamaño | Peso | Tracking | Uso |
|---|---|---|---|
| 64px | 800 | −0,04em | Titular del héroe en portada |
| 48px | 800 | −0,04em | Titular de 404 y de confirmación |
| 40px | 800 | −0,03em | Título de pantalla en escritorio |
| 32px | 800 | −0,03em | Título de sección y héroe móvil |
| 26px | 800 | −0,02em | Título de pantalla en móvil, subtítulo escritorio |
| 22px | 800 | −0,02em | Subtítulo móvil, total del carrito |
| 20px | 800 | — | Precio destacado en ficha, cifras del panel |
| 18px | 800 | — | Total del pedido, número de pedido |
| 16px | 800 | — | Nombre de prenda en listas y tablas |
| 15px | 800 | — | Precio en tarjeta, nombre en tabla de admin |
| 14px | 800 | — | Texto de botón, precio en móvil |
| 13px | 800 | — | Botón móvil, cabecera de tabla, menú |
| 12px | 800 | +0,10em, MAYÚS. | Etiquetas de menú, botones, pasos |
| 11px | 800 | +0,20em, MAYÚS. | Antetítulo de sección, cabecera de columna |
| 10px | 800 | +0,12em, MAYÚS. | Etiqueta sobre foto: Nuevo, Oferta, Agotado |
| 14px | 600 | — | Aviso o error en rojo, escritorio |
| 13px | 600 | — | Aviso o error en rojo, móvil |
| 16px | 400 | — | Párrafo destacado: instrucción del Bizum |
| 15px | 400 | — | Párrafo en escritorio |
| 14px | 400 | — | Cuerpo base y valor de campo de formulario |
| 13px | 400 | — | Cuerpo en móvil, texto secundario |
| 12px | 400 | — | Metadato, etiqueta de campo, pie |
| 11px | 400 | — | Pie en móvil, nota al pie |

**Reglas que no se negocian**
- El peso fuerte es 800, no 700. Con 700 se pierde el contraste de toda la maqueta.
- El 600 existe sólo para texto en rojo a tamaño de párrafo: avisos y errores. No se usa para nada más.
- Toda versalita va en mayúsculas con interletrado abierto. Una versalita con interletrado 0 delata la maqueta mal trasladada.
- Los titulares van cerrados: −0,04em en display, −0,02em en títulos.
- Altura de línea: 0,95 en display, 1,1 en títulos, 1,55-1,65 en párrafo, 1,3 en nombre de prenda.
- Nunca por debajo de 11px en pantalla, ni de 12px en cualquier texto que el cliente deba leer para decidir.

**Empaquetado de la fuente**
- Archivo (Google Fonts, licencia OFL) se empaqueta con la aplicación en los pesos 400, 600 y 800. No se carga desde CDN: la tienda debe verse igual sin red externa y sin salto de fuente al abrir.

## Estados de interacción (botones)
- Reposo: principal con fondo de acento y texto blanco, sin borde. Secundario con borde de 2px tinta y fondo blanco.
- Sobre él (hover): principal con acento un tono más oscuro. Secundario con fondo tinta al 6%.
- Pulsado: acento 600, sin desplazamiento ni escala.
- Foco de teclado: contorno de 2px en acento, separado 2px del control. Nunca el azul por defecto del navegador.
- Deshabilitado: opacidad 45%, sin cursor de puntero.
- Cargando: el botón conserva su ancho, cambia el texto por el de progreso y queda deshabilitado. Nunca desaparece ni colapsa.
- Esta lógica se implementa con `WidgetStateProperty` en el `ButtonStyle` del widget compartido correspondiente (ej. `custom_elevated_button.dart`), no con lógica manual de hover/pressed repetida en cada pantalla.

## Iconografía
- Librería: Lucide, trazo de 1.6px, sin relleno. Paquete decidido: `lucide_icons_flutter` (`import 'package:lucide_icons_flutter/lucide_icons.dart';`, uso `Icon(LucideIcons.<nombre>)`). Ya está en el `pubspec.yaml`, no hace falta volver a consultarlo.
- Como los iconos Lucide son solo trazo (sin relleno), un estado "activo" (ej. corazón de wishlist marcado) se distingue por **color**, nunca sustituyendo por una variante rellena.
- Tamaños, ya definidos en `AppSizes`/`sizes_extension.dart`: 24px en cabecera móvil/tableta, 20px en cabecera escritorio (`context.headerIconSize`); 16-18px junto a texto (`AppSizes.iconSizeInlineSmall` / `iconSizeInlineLarge`); 14px dentro de botón (`AppSizes.iconSizeInButton`).
- El icono hereda el color del texto que acompaña. Solo va en rojo cuando todo el aviso es rojo.

## Alineación
- Todo alineado a la izquierda, incluida la etiqueta dentro de un botón ancho: el texto empieza en el borde interior izquierdo y el icono se sitúa a la derecha.
- Nada centrado, salvo el logotipo en las pantallas de acceso (login/registro).

## Componentes compartidos
Especificación de los widgets compartidos en `shared/widgets/`. Mismo comportamiento en toda la tienda; no se reimplementa por pantalla.

**Botón** (`custom_elevated_button.dart` y variantes)
- Alto 48 px en escritorio, 44 px en móvil. Relleno 15-26 px. Radio 0.
- Etiqueta en `text14w800` mayúsculas, +0,06 em, alineada a la izquierda; el icono opcional se va al borde derecho.
- Principal: fondo acento, texto blanco. Secundario: borde 2 px tinta sobre blanco. Fantasma: sólo texto, para acciones destructivas menores.
- A ancho completo en móvil; en escritorio, ancho del contenido salvo en el resumen del carrito.
- Mientras envía: mismo ancho, texto de progreso y deshabilitado. Nunca sustituir por un indicador giratorio suelto.

**Campo de formulario**
- Borde 1 px tinta 40%, relleno 12-14 px, alto 46 px. Sin radio, sin sombra.
- Etiqueta encima en `text12w400`; nunca dentro del campo como marca de agua sustituta.
- Texto escrito en `text14w400` tinta plena; texto de ejemplo en tinta 45%.
- Con foco: borde 2 px acento. Con error: borde 2 px acento y mensaje debajo en `text12w600` acento oscuro.
- El mensaje de error aparece al salir del campo, no mientras se escribe; desaparece en cuanto se corrige.

**Tarjeta de producto**
- Imagen 3:4 sobre fondo `#eae9e9`, sin recorte del sujeto. Sin borde ni sombra.
- Etiqueta en la esquina superior izquierda, pegada al borde: Nuevo o Oferta en tinta, Agotado en velo blanco al 62% con sello centrado.
- Nombre en `text14w400` a dos líneas máximo; precio en `text15w800`; precio anterior tachado en tinta 50%.
- Corazón de lista de deseos arriba a la derecha, 32 px, fondo blanco 92%.
- Toda la tarjeta es pulsable; el corazón no propaga la pulsación.

**Etiqueta de estado**
- Acento: pendiente de pago, pago en revisión, descuento.
- Contorno: enviado, pagado.
- Neutra: entregado, y neutra al 55% para cancelado.
- Siempre con el texto completo del estado, nunca sólo color.

**Tabla de datos**
- Cabecera en `text11w800caps` sobre filete de 2 px; filas separadas por 1 px tinta 22%.
- Alto de fila 44 px, alineación a la izquierda salvo importes, que van a la derecha.
- Una sola acción por fila, la que corresponde al estado. El resto, en el detalle.
- En móvil la tabla se convierte en lista de fichas apiladas; nunca desplazamiento horizontal.

**Aviso y diálogo**
- Cajón de aviso: recuadro 2 px acento, icono de 18-20 px, título en `text15w800` y detalle en `text13w400`.
- Aviso efímero: barra inferior, 4 segundos, con «Deshacer» cuando la acción destruye algo.
- Diálogo de confirmación sólo para acciones irreversibles: borrar, cancelar pedido, devolver importe.
- El diálogo nombra la consecuencia en el botón: «Devolver y cancelar», no «Aceptar».

Especificación completa, pantalla por pantalla (contenido literal, tipografía por elemento, comportamiento, estados y errores): ver [screens-spec.md](screens-spec.md).
