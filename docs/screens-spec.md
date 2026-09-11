# Especificación de pantallas

Importado desde el documento de Claude Design **"Damilva Especificación Desarrollo" v1.0 (8 de septiembre de 2026)**. Es la fuente de verdad para el contenido literal, la tipografía por elemento, el comportamiento, los estados y los errores de cada pantalla. Complementa (no sustituye) a [architecture.md](architecture.md), [design-system.md](design-system.md) y [order-rules.md](order-rules.md).

**Regla de oro del documento original:** ningún texto visible se improvisa en código. Si una cadena no aparece aquí (o en el anexo de mensajes del dossier de cliente, con los 51 códigos de error citados abajo como `XXX-00`), no se escribe: se pregunta antes de inventarla. Importes, plazos y el teléfono de Bizum son siempre configurables, nunca literales en código (ver [order-rules.md](order-rules.md#configurable-nunca-en-código)).

> Los códigos de error (`SYS-01`, `CAT-04`, `BIZ-03`...) remiten al catálogo completo de 51 mensajes del anexo del dossier de cliente, que no forma parte de este documento. Aquí sólo se lista el texto que sí es literal de cada pantalla; para el resto, usar el código como referencia y preguntar el texto exacto si hace falta antes de implementarlo.

## Índice de pantallas

| # | Pantalla | Ruta | Acceso |
|---|---|---|---|
| 1 | Portada | `/` | Pública |
| 2 | Cabecera y menú de categorías | Global | Pública |
| 3 | Listado por categoría y búsqueda | `/c/:categoria` · `/buscar?q=` | Pública |
| 4 | Ficha de producto | `/p/:id` | Pública |
| 5 | Carrito | `/carrito` | Pública |
| 6 | Registro | `/registro` | Pública |
| 7 | Inicio de sesión | `/acceso` | Pública |
| 8 | Checkout | `/checkout` | Requiere sesión |
| 9 | Pedido confirmado y pago por Bizum | `/pedido/:numero` | Requiere sesión · crítica |
| 10 | Mi cuenta y mis pedidos | `/cuenta` · `/cuenta/pedidos` | Requiere sesión |
| 11 | Contacto | `/contacto` | Pública |
| 12 | Preguntas frecuentes | `/faq` | Pública |
| 13-14 | Legales, envíos y devoluciones | `/aviso-legal` · `/privacidad` · `/cookies` · `/envios` | Pública |
| 15 | Pie de página | Global | Pública |
| 16 | Acceso al panel | `/admin` | Sólo administración |
| 17 | Alta de producto | `/admin/productos/nuevo` | Sólo administración |
| 18 | Edición de producto | `/admin/productos/:id` | Sólo administración |
| 19 | Gestión de pedidos y conciliación | `/admin/pedidos` · `/admin/bizum` | Sólo administración |
| 20 | Error 404 | Cualquier ruta desconocida | Pública |

---

## Pantalla 1 · Portada

**Objetivo:** enseñar la colección y llevar al catálogo en un toque. Las novedades se llenan solas con lo último publicado, sin que nadie edite la portada.

**Contenido literal**
- Barra superior: «Envío gratis a partir de 40€» — importe leído de configuración; si el umbral cambia, cambia el texto.
- Antetítulo del héroe: «Otoño / invierno 2026»
- Titular del héroe: «Nueva colección»
- Botón del héroe: «Ver ahora»
- Sección: «Novedades · Ver todas las novedades»
- Sección: «Categorías destacadas»
- Franja de confianza: «Pago seguro por Bizum · Atención personalizada · Envíos a toda España»

**Tipografía**
- Barra superior (mayúsculas): `text12w800caps`
- Titular del héroe: `text64w800 / 32` (desktop/móvil)
- Antetítulo del héroe: `text12w800caps`
- Título de sección: `text32w800`
- Nombre de prenda: `text14w400 / 13`
- Precio: `text15w800 / 14`
- Franja de confianza: `text15w800`

**Comportamiento**
- Carrusel de 3 diapositivas, avance automático cada 6 s, se detiene al pasar el puntero o al enfocar con teclado. Flechas y guiones pulsables; en móvil, gesto de arrastre.
- Novedades: 8 prendas en escritorio (4×2), 4 en móvil (2×2) con enlace a ver todas.
- Categorías destacadas: 4 fijas, elegidas en el panel. Con menos de 4, la rejilla se ajusta sin huecos.
- El contador del carrito de la cabecera se actualiza sin recargar.
- Imágenes en diferido salvo la primera del carrusel (prioridad).

**Estados**
- Carga: huecos gris `#eae9e9` con relación 3:4 reservada.
- Sin novedades: la sección entera se oculta, nunca un título sin contenido.
- Sin red: `SYS-02` con «Reintentar».

**Errores**
- `SYS-02` — sin conexión al abrir.
- `SYS-03` — error del servidor al pedir la portada.
- (sin código) — imagen que no carga: se queda el hueco gris, nunca un icono roto.
- (sin código) — prenda despublicada entre la carga y el toque: se resuelve en la ficha con `CAT-06`.

**Datos**
```
GET /home → carrusel[3]{imagen, antetítulo, titular, enlace}
          → novedades[8]{id, nombre, precio, precioAnterior, etiqueta, imagen}
          → categoriasDestacadas[4]{id, nombre, imagen}
          → config{umbralEnvioGratis, plazoEntrega}
```

---

## Pantalla 2 · Cabecera y menú de categorías (global)

**Objetivo:** dar acceso permanente a buscar, categorías, cuenta y carrito. Único elemento presente en todas las pantallas de tienda.

**Contenido literal**
- Buscador: «Buscar productos...»
- Menú: «Categorías»
- Cuenta sin sesión: «Iniciar sesión»
- Cuenta con sesión: nombre de pila del cliente (nunca el correo completo)
- Categorías del menú: «Novedades · Vestidos y monos · Camisetas, bodies y tops · Abrigos y chaquetas · Pantalones y faldas · Calzado · Complementos y bisutería · Ofertas» — **orden pendiente de cerrar con el cliente** (ver Pendiente de decisión #3)

**Tipografía**
- Etiquetas del menú: `text14w800 caps`
- Texto del buscador: `text14w400`
- Enlace de cuenta: `text13w400`
- Contador del carrito: `text10w800`
- Categorías desplegadas: `text13w400`

**Comportamiento**
- Escritorio: logotipo, buscador, menú de categorías, cuenta y carrito en una fila sobre filete de 2 px. Móvil: hamburguesa, logotipo centrado, lupa y carrito.
- El menú de categorías se abre al pulsar, no al pasar por encima. Se cierra con Escape, al pulsar fuera o al elegir.
- El buscador sugiere a partir de 3 caracteres, máximo 5 resultados; Enter lleva al listado completo.
- Móvil: la hamburguesa abre panel a pantalla completa con categorías, cuenta y acceso a legales.
- El contador del carrito muestra unidades, no líneas; desaparece a cero.

**Estados**
- Sin sesión: «Iniciar sesión» con icono de persona.
- Con sesión: nombre de pila; al pulsar, acceso a Mis pedidos, Mis datos y Cerrar sesión.
- Carrito vacío: icono sin contador; al pulsar, pantalla 5 (CAR-01).

**Errores**
- (sin código) — sugerencias del buscador que fallan: se cierra el desplegable en silencio, Enter sigue funcionando.
- `AC-08` — sesión caducada al cargar: pasa a sin sesión conservando el carrito.
- (sin código) — categoría vacía o despublicada: no aparece en el menú.

**Datos**
```
GET /categorias → [{id, nombre, orden, visible}]
GET /buscar?q= → sugerencias[5]{id, nombre, imagen}
Estado local: sesión, unidades del carrito
```

---

## Pantalla 3 · Listado por categoría y búsqueda

**Objetivo:** recorrer el catálogo con filtros de talla, color y precio, y llegar a la ficha. Misma pantalla para categoría y resultado de búsqueda.

**Contenido literal**
- Migas: «Inicio > Ropa > Vestidos y monos»
- Título: nombre de la categoría; en búsqueda, «Resultados para "vestido rojo"»
- Recuento: «128 productos»
- Filtros: «Filtros · Talla · Color · Precio · Solo con stock»
- Orden (por defecto «Novedades primero»): «Novedades primero · Precio de menor a mayor · Precio de mayor a menor»
- Botón: «Cargar más productos»
- Móvil: «Filtrar y ordenar»

**Tipografía**
- Título de categoría: `text40w800 / 26`
- Migas: `text12w400`
- Cabecera de filtro: `text13w800 caps`
- Opción de filtro: `text13w400`
- Talla y orden: `text12w800`
- Nombre y precio: `text14w400` · `text15w800`

**Comportamiento**
- Rejilla de 4 columnas escritorio, 3 tableta, 2 móvil. Carga de 12 en 12 con botón, no scroll infinito.
- Filtros aplican al instante y se reflejan en la URL (compartible, back funciona).
- Filtros activos como etiquetas quitables encima de la rejilla, también en escritorio.
- «Solo con stock» desmarcado por defecto: se ven los agotados, marcados como tales.
- Móvil: un botón abre panel con filtros y orden juntos; se aplica al cerrar.

**Estados**
- Carga: 12 huecos grises 3:4.
- Sin resultados: `CAT-01` en búsqueda, `CAT-02` con filtros, `CAT-03` en categoría vacía. Siempre con salida.
- Última página: el botón desaparece, no se deja deshabilitado.

**Errores**
- `CAT-01` — búsqueda sin resultados.
- `CAT-02` — combinación de filtros sin resultados, con «Quitar todos los filtros».
- `CAT-03` — categoría sin productos publicados.
- `SYS-03` — fallo al cargar más: se mantiene lo cargado, se ofrece reintentar.
- (sin código) — categoría inexistente en la URL: 404 (`SYS-01`).

**Datos**
```
GET /c/:categoria?talla=&color=&precioMax=&stock=&orden=&pagina=
  → total, productos[12]{id, nombre, precio, precioAnterior, etiqueta, agotado, imagen}
  → filtrosDisponibles{tallas[], colores[], precioMin, precioMax}
```

---

## Pantalla 4 · Ficha de producto

**Objetivo:** dar toda la información para decidir la compra y añadir la variante correcta al carrito. La pantalla que más convierte: nada que estorbe.

**Contenido literal**
- Precio: «39,90 € · 49,90 € tachado · −20% · IVA incluido»
- Selectores: «Color · Rojo lunares    Talla»
- Enlace: «Consultar guía de tallas»
- Nota de talla: «La talla L aparece tachada: sin stock en este color.»
- Aviso de stock bajo (sólo con ≤3 unidades de la variante elegida): «¡Últimas unidades! Quedan 2 en talla M»
- Acción: «Añadir al carrito»
- Envío y secciones: «Envío en 24-48h · Ver información de envíos y devoluciones · Descripción · Composición y cuidados · Devoluciones · También te puede gustar»

**Tipografía**
- Nombre del producto: `text40w800 / 26`
- Precio actual: `text32w800 / 24`
- Precio anterior tachado: `text16w400 / 14`
- Etiqueta de descuento: `text11w800caps`
- Talla y cantidad: `text14w800`
- Aviso de stock bajo: `text13w600 acento`
- Descripción: `text14w400`

**Comportamiento**
- Galería 3-5 fotos: miniaturas debajo en escritorio, guiones y arrastre en móvil. Lupa para ampliar.
- Color y talla obligatorios antes de añadir. Botón deshabilitado con «Elige talla para continuar» hasta elegir.
- Al cambiar color se recarga galería y se recalculan tallas: agotadas tachadas y no pulsables.
- Cantidad de 1 a unidades disponibles; el «+» se deshabilita en el tope.
- Al añadir: aviso efímero «Añadido al carrito» con «Ver carrito», contador de cabecera sube. No se abandona la ficha.
- Secciones plegables abren de una en una, arrancan cerradas salvo Descripción (arranca abierta).

**Estados**
- Carga: hueco de galería 4:5 y dos líneas grises en vez de nombre y precio.
- Talla agotada: `CAT-04` junto al selector, con «Avísame si vuelve».
- Todo agotado: `CAT-05` sustituye al botón de añadir.
- Despublicado: `CAT-06` a pantalla entera, con salida a la categoría.

**Errores**
- `CAT-04` — variante sin stock en el color elegido.
- `CAT-05` — producto entero agotado.
- `CAT-06` — producto despublicado o inexistente.
- `CAR-04` — se piden más unidades de las que hay: se ajusta y se avisa.
- `SYS-03` — fallo al añadir al carrito: no se toca el contador, se ofrece reintentar.

**Datos**
```
GET /p/:id → {nombre, descripcion, composicion, devoluciones, precio, precioAnterior, imagenes[]}
           → variantes[]{color, colorHex, talla, sku, stock, precio}
           → relacionados[4]{id, nombre, precio, imagen}
POST /carrito {sku, cantidad}
```

---

## Pantalla 5 · Carrito

**Objetivo:** revisar y ajustar el pedido antes de pagar, con el total siempre visible y sin sorpresas de última hora.

**Contenido literal**
- Título: «Tu carrito · 4 artículos»
- Aviso de reserva: «Tenemos tu pedido reservado durante 29:41 minutos.»
- Resumen: «Subtotal · Gastos de envío · Gratis · Total»
- Descuento: «Código descuento · Introduce tu código · Aplicar»
- Acciones: «Finalizar compra · Seguir comprando»
- Nota de pago: «Pago seguro por Bizum al confirmar el pedido»

**Tipografía**
- Título: `text40w800 / 22`
- Nombre de línea: `text16w800 / 14`
- Variante de línea: `text13w400 / 12`
- Importe de línea: `text18w800 / 14`
- Total: `text26w800 / 22`
- Aviso en la línea: `text13w600 acento`

**Comportamiento**
- Cantidad editable en la propia línea; total y envío se recalculan al instante.
- Quitar una línea muestra aviso efímero con «Deshacer» durante 4 segundos.
- El envío pasa a «Gratis» al superar el umbral; por debajo se indica cuánto falta.
- El carrito se revalida contra stock al entrar y al pulsar Finalizar compra.
- Móvil: subtotal, envío, total y botón fijos al pie; la lista se desplaza por detrás.
- El código de descuento se aplica sin recargar y se puede quitar.

**Estados**
- Vacío: `CAR-01` a pantalla entera con «Ver novedades».
- Reserva viva: cuenta atrás en el aviso, con la hora que manda el servidor.
- Reserva caducada: `CAR-02` arriba; líneas conservadas sin reserva y revalidadas ([política 3 de stock](order-rules.md#reserva-de-stock)).
- Línea con problema: `CAR-03` o `CAR-04` dentro de la línea, con sus dos acciones.

**Errores**
- `CAR-01` — carrito vacío.
- `CAR-02` — reserva de 30 minutos agotada.
- `CAR-03` — línea agotada mientras estaba en el carrito: no cuenta en el total.
- `CAR-04` — stock insuficiente: se ajusta la cantidad a la baja.
- `CAR-05` — código de descuento inválido, caducado o no acumulable.
- `CAR-06` — precio cambiado desde que se añadió.

**Datos**
```
GET /carrito → lineas[]{sku, nombre, variante, precio, cantidad, stockDisponible, agotado}
             → subtotal, envio, total, descuento{codigo, importe}, reservaHasta
PATCH /carrito/:sku {cantidad}
DELETE /carrito/:sku
POST /carrito/descuento
```

---

## Pantalla 6 · Registro

**Objetivo:** crear cuenta con el mínimo imprescindible, sin que el cliente tema perder el carrito.

**Contenido literal**
- Título: «Crear una cuenta»
- Aviso: «Regístrate para completar tu pedido. No te preocupes, tu carrito sigue intacto.»
- Campos: «Nombre · Apellidos · Correo electrónico · Contraseña · Repite la contraseña»
- Ayuda de contraseña: «Mínimo 8 caracteres, con una mayúscula y un número.»
- Legal (obligatorio): «He leído y acepto el Aviso Legal y la Política de Privacidad *»
- Opcional: «Quiero recibir novedades y ofertas por correo electrónico»
- Acciones: «Crear cuenta · ¿Ya tienes cuenta? Inicia sesión»
- Si se llega desde checkout, el botón dice «Crear cuenta y continuar»

**Tipografía**
- Título: `text40w800 / 26`
- Etiqueta de campo: `text12w400`
- Valor escrito: `text14w400`
- Ayuda y legal: `text13w400`
- Error de campo: `text12w600 acento`
- Botón: `text14w800 caps`

**Comportamiento**
- Casilla legal obligatoria: sin marcar, botón deshabilitado; al pulsarlo se enfoca la casilla y se muestra `AC-06`.
- Validación al salir de cada campo, nunca mientras se escribe. Sin resumen de errores: cada mensaje bajo su campo.
- Ojo para mostrar contraseña en los dos campos, con estado accesible.
- Al crear cuenta: sesión iniciada y vuelta exacta al punto de partida, con el carrito intacto.

**Estados**
- Enviando: botón con progreso y deshabilitado; campos en sólo lectura.
- Éxito: sin pantalla intermedia, vuelta al origen con aviso efímero «Cuenta creada».

**Errores**
- `AC-02` — correo ya registrado, con enlace a iniciar sesión.
- `AC-03` — correo con formato incompleto.
- `AC-04` — contraseña que no cumple los requisitos.
- `AC-05` — las dos contraseñas no coinciden.
- `AC-06` — legales sin aceptar.
- `SYS-03` — fallo del servidor: se conserva todo lo escrito menos las contraseñas.

**Datos**
```
POST /registro {nombre, apellidos, correo, contrasena, aceptaLegal, aceptaMarketing}
  → 201 sesión · 409 correo duplicado · 422 validación por campo
El carrito de invitado se asocia a la cuenta nueva, sin perder líneas
```

---

## Pantalla 7 · Inicio de sesión

**Objetivo:** entrar en la cuenta en dos campos, y ofrecer salida a quien no recuerda la contraseña.

**Contenido literal**
- Título: «Iniciar sesión»
- Error: «El correo o la contraseña no son correctos» — nunca se dice cuál de los dos falla
- Campos: «Correo electrónico · Contraseña»
- Enlace: «¿Has olvidado tu contraseña?»
- Acciones: «Acceder · ¿Aún no tienes cuenta? Regístrate»

**Tipografía**
- Título: `text40w800 / 26`
- Cajón de error: `text14w600 / 13 acento`
- Etiqueta de campo: `text12w400`
- Valor escrito: `text14w400`
- Enlaces: `text13w400`

**Comportamiento**
- Error en cajón arriba, borde del campo de contraseña en rojo, sin vaciar el correo escrito.
- Enter en cualquiera de los dos campos envía el formulario.
- Tras entrar se vuelve al punto de partida, no siempre a la portada.
- El enlace de recuperación pide sólo el correo y responde siempre igual, exista o no la cuenta.
- Los campos llevan los `autocomplete`/tipos correctos para gestores de contraseñas del navegador.

**Estados**
- Enviando: botón con progreso, campos en sólo lectura.
- Bloqueado: `AC-09` con el tiempo restante; botón deshabilitado.

**Errores**
- `AC-01` — credenciales incorrectas.
- `AC-03` — correo con formato incompleto, antes de enviar.
- `AC-07` — enlace de recuperación caducado o ya usado.
- `AC-09` — demasiados intentos seguidos: espera de 15 minutos.
- `SYS-03` — fallo del servidor al validar.

**Datos**
```
POST /acceso {correo, contrasena} → 200 sesión · 401 credenciales · 429 bloqueo
POST /recuperar {correo} → 202 siempre, sin revelar si existe
```
La respuesta `401` nunca distingue entre correo y contraseña.

---

## Pantalla 8 · Checkout

**Objetivo:** recoger la dirección de envío y confirmar el pedido. Bizum es el único método: se explica antes de confirmar, no después.

**Contenido literal**
- Pasos: «Carrito → Datos de envío → Confirmación»
- Título e introducción: «Datos de envío · Comprobamos la dirección antes de preparar el paquete. Todos los campos son obligatorios salvo indicación.»
- Campos: «Nombre y apellidos · Dirección · Código postal · Ciudad · Provincia · Teléfono de contacto»
- Opcional: «Guardar esta dirección para próximos pedidos»
- Pago: «Método de pago · Bizum · Único método disponible»
- Explicación: «Tras confirmar el pedido, te mostraremos el número/QR de Bizum y el importe exacto a enviar.»
- Acción y nota: «Confirmar pedido · Al confirmar, tu pedido queda reservado 30 minutos.»

**Tipografía**
- Título: `text40w800 / 26`
- Pasos (mayúsculas): `text12w800caps`
- Etiqueta de campo: `text12w400`
- Valor escrito: `text14w400`
- Total del resumen: `text26w800 / 20`
- Botón de confirmar: `text14w800 caps`

**Comportamiento**
- Sin sesión se lleva a la pantalla 7 con vuelta al checkout; el carrito no se toca.
- Provincia: desplegable con las 52; ciudad sugerida por código postal, corregible.
- Teléfono obligatorio: es el que se cruza con el Bizum recibido.
- Resumen fijo en escritorio, plegable en móvil, con «4 artículos · 175,60 €» siempre visible.
- Confirmar valida stock una última vez, crea el pedido con **clave de idempotencia** y reserva 30 minutos ([idempotencia](order-rules.md#idempotencia)).
- Mientras se crea el pedido: botón deshabilitado con `CHK-07`; no se puede volver atrás ni pulsar dos veces.

**Estados**
- Enviando: «Estamos creando tu pedido, no cierres esta página» y campos bloqueados.
- Stock caído: `CHK-06` arriba, línea afectada quitada y total actualizado antes de dejar confirmar.
- Éxito: se sustituye por la pantalla 9; el botón atrás no vuelve al formulario.

**Errores**
- `CHK-01` — campo obligatorio vacío.
- `CHK-02` — código postal que no son 5 números.
- `CHK-03` — código postal y provincia incoherentes.
- `CHK-04` — teléfono que no son 9 números.
- `CHK-05` — zona sin cobertura de envío.
- `CHK-06` — stock agotado al confirmar.
- `CHK-08` — fallo de red al confirmar: reintento sin duplicar pedido.

**Datos**
```
GET /checkout → carrito, direccionGuardada, config{umbralEnvioGratis}
POST /pedidos {direccion, telefono, guardarDireccion, claveIdempotencia}
  → 201 {numeroPedido, total, telefonoBizum, concepto, reservaHasta}
  → 409 stock insuficiente con el detalle de la línea afectada
```

---

## Pantalla 9 · Pedido confirmado y pago por Bizum (crítica)

**Objetivo:** conseguir que el Bizum llegue bien: teléfono, importe exacto y concepto, con el plazo claro. La pantalla donde se gana o se pierde el cobro.

**Contenido literal**
- Título: «¡Gracias por tu pedido! · Nº de pedido: 10428»
- Estado: «Pendiente de pago · Tu pedido aún no está pagado.»
- Instrucción: «Realiza un Bizum al 612 34 56 78 por importe de 175,60 € indicando en el concepto el número de pedido 10428» *(teléfono de muestra, ver Pendiente de decisión #1)*
- Los tres datos: «Teléfono · Importe exacto · Concepto»
- Plazo: «Tienes 29:41 para completar el pago · Pasado ese tiempo, el pedido se cancelará automáticamente y los artículos volverán a estar disponibles.»
- Después: «Qué pasa después · En cuanto confirmemos tu Bizum recibirás un correo y el pedido pasará a "Pagado". Prepararemos el envío el mismo día.»
- Acciones: «Ver mis pedidos · Seguir comprando»

**Tipografía**
- Título: `text48w800 / 28`
- Número de pedido: `text18w800 / 14`
- Etiqueta de estado: `text11w800caps`
- Instrucción del Bizum: `text16w400 / 14`
- Los tres datos: `text20w800 / 18`
- Plazo: `text15w800 / 13`

**Comportamiento**
- Los tres datos en un bloque con borde de 2 px acento, cada uno copiable con aviso efímero «Copiado».
- Móvil: botón para abrir la app del banco si el dispositivo lo permite; si no, sólo copiar.
- Cuenta atrás calculada sobre la hora de caducidad del servidor, sobrevive a recargas.
- Al llegar a cero, la pantalla cambia sola al estado cancelado, sin recargar a mano.
- El mismo contenido llega por correo en cuanto se crea el pedido, con los tres datos repetidos.
- Volver atrás no rehace el pedido: siempre recuperable desde Mis pedidos.

**Estados**
- Pendiente: los tres datos y la cuenta atrás. Estado por defecto al llegar.
- Cancelado: `BIZ-02`, carrito conservado sin reserva, aviso de qué hacer si ya se pagó.
- En revisión: `BIZ-03` con lo recibido, lo esperado y la acción (devolver y cancelar).
- Reactivado: `BIZ-04` (pagado) o `BIZ-05` (faltó stock: devolución completa).

**Errores**
- `BIZ-02` — tiempo agotado sin pago.
- `BIZ-03` — importe recibido distinto: se devuelve y se cancela ([política 1](order-rules.md#política-1--importe-distinto)).
- `BIZ-04` — Bizum tardío con stock: se reactiva ([política 2](order-rules.md#política-2--bizum-tardío)).
- `BIZ-05` — Bizum tardío sin stock: devolución completa.
- `BIZ-06` — dos Bizums al mismo pedido: se devuelve uno.
- `BIZ-07` — pago aún sin constar: no repetir, escribir.

**Datos**
```
GET /pedido/:numero → {estado, total, telefonoBizum, concepto, reservaHasta, lineas[], direccion}
                     → pagoRecibido{importe, telefonoOrigen, fecha} cuando existe
```
El teléfono y el plazo salen de configuración, nunca del código.

---

## Pantalla 10 · Mi cuenta y mis pedidos

**Objetivo:** consultar el historial, recuperar un pago pendiente y editar los datos personales.

**Contenido literal**
- Título y menú: «Mi cuenta · Mis pedidos · Mis datos · Direcciones · Lista de deseos · Cerrar sesión» *(lista de deseos pendiente de decisión #2)*
- Línea de pedido: «Pedido 10428 · 2 sep 2026 · 4 artículos · 175,60 € · Ver detalle»
- Estados: «Pendiente de pago · Enviado · Entregado · Cancelado»
- Recordatorio: «Completa el Bizum de 175,60 € con el concepto 10428»
- Sin pedidos: «Todavía no has hecho ningún pedido · Ver novedades»

**Tipografía**
- Título: `text40w800 / 28`
- Menú lateral activo: `text13w800`
- Menú lateral inactivo: `text13w400`
- Número de pedido: `text18w800 / 15`
- Fecha y totales: `text13w400 / 12`
- Recordatorio de pago: `text13w600 acento`

**Comportamiento**
- Pedidos ordenados del más reciente al más antiguo, paginación de 10 en 10.
- El pedido pendiente de pago aparece primero con el recordatorio, aunque no sea el más reciente.
- «Ver detalle» lleva a la pantalla 9 en el estado que corresponda.
- Móvil: el menú lateral se convierte en tres pestañas (Pedidos, Datos, Deseos).
- Cerrar sesión pide confirmación sólo si hay un pedido pendiente de pago.

**Estados**
- Carga: tres líneas grises con la forma de la fila.
- Sin pedidos: mensaje con salida a novedades; el menú sigue disponible.
- Sesión caída: `AC-08` y vuelta al acceso, conservando la dirección a la que se quería ir.

**Errores**
- `AC-08` — sesión caducada al entrar.
- `BIZ-07` — pago hecho que aún no consta, en el pedido pendiente.
- `SYS-03` — fallo al cargar el historial.
- `SYS-04` — intento de ver el pedido de otra persona: no se confirma su existencia.

**Datos**
```
GET /cuenta/pedidos?pagina= → pedidos[]{numero, fecha, articulos, total, estado, imagen}
GET /cuenta → {nombre, apellidos, correo, telefono, direcciones[]}
PATCH /cuenta para editar datos, con reautenticación al cambiar el correo
```

---

## Pantalla 11 · Contacto

**Objetivo:** dar una vía de contacto rápida, sobre todo para los casos de Bizum, con el número de pedido a mano.

**Contenido literal**
- Título e introducción: «Contacto · Escríbenos y te contestamos nosotras, normalmente el mismo día.»
- Campos: «Nombre · Correo electrónico · Nº de pedido (opcional) · Mensaje»
- Ejemplo de campo: «Ej. 10428 · Cuéntanos en qué podemos ayudarte»
- Acción: «Enviar mensaje»
- Datos directos: «hola@damilva.es · 612 34 56 78 · WhatsApp · Lunes a viernes, 10:00 a 18:00»
- Éxito: «Mensaje enviado. Te contestamos en menos de 24 horas laborables.»

**Tipografía**
- Título: `text40w800 / 28`
- Introducción: `text15w400 / 14`
- Etiqueta de campo: `text12w400`
- Datos de contacto: `text14w400`
- Botón: `text14w800 caps`

**Comportamiento**
- Con sesión, nombre y correo vienen rellenos y editables.
- Si se llega desde un pedido, el número viene puesto.
- Mensaje admite 1000 caracteres, contador a partir de 900.
- Tras enviar, el formulario se sustituye por el mensaje de éxito; no se vacía y se queda en blanco.
- Protección antispam invisible, sin captcha visual.

**Estados**
- Enviando: botón con progreso; campos en sólo lectura.
- Éxito: mensaje de confirmación con el plazo de respuesta.

**Errores**
- `CHK-01` — campo obligatorio vacío.
- `AC-03` — correo con formato incompleto.
- `SYS-03` — fallo al enviar: se conserva el mensaje escrito, se ofrece reintentar.
- (sin código) — número de pedido inexistente: no se bloquea el envío, se avisa en el panel.

**Datos**
```
POST /contacto {nombre, correo, numeroPedido, mensaje}
  → 202 aceptado · 422 validación por campo
```

---

## Pantalla 12 · Preguntas frecuentes

**Objetivo:** resolver sin escribir las dudas que más llegan, empezando por el pago con Bizum, la que más se pregunta.

**Contenido literal**
- Título e introducción: «Preguntas frecuentes · Lo que más nos preguntáis, empezando por el pago.»
- Primera pregunta (abierta por defecto): «¿Cómo pago mi pedido con Bizum?»
- Respuesta: «Al confirmar el pedido te mostramos un número de teléfono, el importe exacto y un concepto (tu número de pedido). Haces el Bizum desde tu banco con esos tres datos y nosotras lo confirmamos en cuanto entra. Tienes 30 minutos: pasado ese tiempo el pedido se cancela y las prendas vuelven a estar disponibles.»
- Resto de preguntas: «¿Cuánto tarda en llegar mi pedido? · ¿Puedo cambiar la talla de una prenda? · ¿Qué pasa si no completo el pago en 30 minutos? · ¿Hacéis envíos a Canarias y Baleares? · ¿Puedo recoger el pedido en tienda?»
- Cierre: «¿No encuentras tu respuesta? Escríbenos»

**Tipografía**
- Título: `text40w800 / 28`
- Pregunta: `text16w800 / 14`
- Respuesta: `text14w400 / 13`
- Enlace de cierre: `text13w400`

**Comportamiento**
- La primera pregunta arranca abierta, el resto cerradas. Se pueden abrir varias a la vez.
- El icono cambia de más a menos, sin girar.
- Cada pregunta tiene enlace propio (ancla), para compartir por WhatsApp desde atención al cliente.
- El contenido se edita desde el panel; el orden lo marca la administradora.

**Estados**
- Carga: cinco filas grises del alto de una pregunta.
- Sin contenido: la pantalla no se publica; el enlace del pie se oculta.

**Errores**
- `SYS-03` — fallo al cargar el contenido.
- `SYS-01` — enlace a una pregunta que ya no existe: se abre la lista completa, no un 404.

**Datos**
```
GET /faq → [{id, pregunta, respuesta, orden}]
```
Respuesta con formato básico: negrita, enlaces y lista. Editable desde el panel.

---

## Pantallas 13-14 · Legales, envíos y devoluciones

Cuatro páginas (`/aviso-legal`, `/privacidad`, `/cookies`, `/envios`) comparten una sola plantilla de texto corrido, para que añadir una página nueva no cueste nada.

**Contenido literal**
- Títulos: «Aviso legal · Política de privacidad · Política de cookies · Envíos y devoluciones»
- Marca de fecha: «Última actualización: 8 de septiembre de 2026»
- Texto: pendiente de entrega por el cliente (ver Pendiente de decisión #4) — el desarrollo monta la plantilla, el contenido se vuelca sin tocar código
- Aviso de cookies: «Usamos cookies propias para que la tienda funcione y para recordar tu carrito. · Aceptar · Solo las necesarias»

**Tipografía**
- Título de página: `text40w800 / 28`
- Título de apartado: `text20w800 / 18`
- Párrafo: `text15w400 / 14`
- Marca de fecha: `text12w400`
- Texto del aviso de cookies: `text13w400`

**Comportamiento**
- Ancho de lectura limitado a 720 px, aunque la pantalla sea más ancha.
- Índice de apartados arriba en páginas de más de cinco apartados, con enlace interno.
- El aviso de cookies aparece una vez, no bloquea la navegación y guarda la elección.
- Las cuatro páginas enlazadas desde el pie y desde el registro.

**Estados**
- Sin contenido: la página no se publica y su enlace no aparece en el pie.
- Carga: cuatro líneas grises del ancho del párrafo.

**Errores**
- `SYS-01` — página legal inexistente: 404.
- `SYS-03` — fallo al cargar el texto.

**Datos**
```
GET /pagina/:slug → {titulo, contenido, actualizado}
```
Contenido con formato básico y anclas por apartado. Editable desde el panel, sin publicar versión nueva de la aplicación.

---

## Pantalla 15 · Pie de página (global)

**Objetivo:** cerrar cualquier pantalla con las salidas de ayuda, legales y catálogo, y con las redes de la tienda.

**Contenido literal**
- Columna: «Ayuda · Contacto · Preguntas frecuentes · Envíos y devoluciones»
- Columna: «Legal · Aviso legal · Política de privacidad · Política de cookies»
- Columna: «La tienda · Novedades · Ofertas · Quiénes somos»
- Redes: «Instagram · Facebook · TikTok» — sólo las que la tienda tenga activas, una red sin cuenta no se dibuja
- Aviso legal: «© 2026 Damilva. Todos los derechos reservados.»

**Tipografía**
- Título de columna: `text13w800 caps`
- Enlace: `text13w400`
- Aviso de derechos: `text12w400` tinta 55%

**Comportamiento**
- Escritorio: logotipo y tres columnas de enlaces sobre filete de 2 px. Móvil: acordeones plegados por defecto.
- El logotipo del pie no enlaza a la portada si ya se está en ella.
- Los iconos de red abren en pestaña nueva, con etiqueta accesible.
- El año del aviso de derechos se calcula, no se escribe.

**Estados**
- Móvil: tres acordeones cerrados, se abre uno a la vez.

**Errores**
- (sin código) — enlace a página no publicada: el enlace no se dibuja.

**Datos**
```
GET /pie → columnas[]{titulo, enlaces[]}, redes[]{tipo, url}
```
Se puede servir junto a `/categorias` en la misma llamada de arranque.

---

## Pantalla 16 · Acceso al panel

**Objetivo:** dejar entrar sólo a la administradora, y decirlo sin dar pistas a quien no debe estar aquí.

**Contenido literal**
- Marca: «Panel de administración»
- Título e introducción: «Acceso restringido · Solo para la administradora de la tienda.»
- Campos y acción: «Correo electrónico · Contraseña · Entrar al panel»
- Nota: «La sesión caduca a los 30 minutos de inactividad.»
- Sin permiso: «Esta parte es solo para la administración de la tienda»

**Tipografía**
- Marca del panel: `text11w800caps` blanco
- Título: `text26w800`
- Etiqueta de campo: `text12w400`
- Botón: `text13w800 caps`
- Nota de sesión: `text12w400`

**Comportamiento**
- Cabecera en tinta con el logotipo sobre fondo blanco, para separar el panel de la tienda de un vistazo.
- La sesión caduca a los 30 minutos de inactividad, con aviso un minuto antes y opción de seguir.
- Mismo mensaje de error para correo y contraseña, igual que en la tienda.
- No hay registro ni recuperación pública: la clave se restablece desde el servidor.
- El panel se diseña para escritorio; en móvil sólo se garantiza el acceso y la consulta de pedidos.

**Estados**
- Enviando: botón con progreso.
- Sin permiso: `SYS-04`, sin confirmar que la dirección exista.
- Sesión caída: vuelta al acceso conservando el formulario a medias en memoria.

**Errores**
- `AC-01` — credenciales incorrectas.
- `AC-09` — demasiados intentos: bloqueo temporal.
- `SYS-04` — entrada sin permiso al panel.
- `ADM-08` — sesión caducada con un formulario a medias: no se pierde lo escrito.

**Datos**
```
POST /admin/acceso {correo, contrasena} → sesión con rol administración
```
Toda ruta `/admin` exige rol; sin él se responde 404, no 403, a la vista pública. Registro de accesos con fecha e IP.

---

## Pantalla 17 · Alta de producto

**Objetivo:** publicar una prenda con sus variantes y fotos sin ayuda técnica, y no dejar publicar algo incompleto.

**Contenido literal**
- Migas y título: «Productos > Nuevo producto · Nuevo producto»
- Datos básicos: «Nombre del producto · Categoría · Referencia base · Precio · Precio rebajado (opcional) · Descripción»
- Variantes: «Variantes · color y talla · Añadir variante · Color · Talla · SKU · Stock · Precio»
- Nota de stock: «El stock a cero oculta la talla en la tienda; la variante sigue existiendo para reponer.»
- Imágenes: «Imágenes · Arrastra para reordenar. La primera es la que sale en el listado.»
- Visibilidad: «Publicado en la tienda · Aparecer en "Novedades" · Destacar en la portada»
- Acciones: «Guardar como borrador · Publicar producto»

**Tipografía**
- Título: `text32w800`
- Título de bloque: `text13w800 caps`
- Etiqueta de campo: `text12w400`
- Cabecera de tabla: `text11w800caps`
- Celda de variante: `text13w400`
- Talla en la tabla: `text13w800`

**Comportamiento**
- El SKU se propone solo a partir de referencia, color y talla; se puede editar.
- Se puede añadir variante a variante o generar la matriz completa eligiendo colores y tallas.
- Imágenes se suben arrastrando, se reordenan arrastrando, la primera queda marcada como principal.
- «Publicar» exige nombre, categoría, precio, una imagen y una variante con stock; si falta algo, se señala el bloque y no se envía.
- El borrador se guarda sin validar nada, para poder dejarlo a medias.
- Se avisa antes de salir con cambios sin guardar.

**Estados**
- Borrador: etiqueta «Borrador» junto al título; no visible en la tienda.
- Guardando: botón con progreso; el formulario no se bloquea entero.
- Subiendo imagen: hueco con barra de progreso en el lugar que ocupará la foto.

**Errores**
- `ADM-01` — referencia o SKU duplicado.
- `ADM-02` — variante repetida de color y talla.
- `ADM-03` — publicar sin variantes con stock o sin imagen.
- `ADM-04` — precio rebajado mayor o igual que el precio normal.
- `ADM-05` — imagen de formato no admitido o de más de 5 MB.
- `SYS-03` — fallo al guardar: no se pierde nada de lo escrito.

**Datos**
```
POST /admin/productos {nombre, categoriaId, referencia, precio, precioRebajado, descripcion, visibilidad}
POST /admin/productos/:id/variantes {color, colorHex, talla, sku, stock, precio}
POST /admin/productos/:id/imagenes (multipart, JPG o PNG, 5 MB máximo)
```

---

## Pantalla 18 · Edición de producto

**Objetivo:** corregir datos, reponer stock y retirar prendas sin romper el historial de pedidos.

**Contenido literal**
- Migas y título: «Productos > Editar producto · Nombre del producto»
- Acciones: «Descartar · Guardar cambios»
- Estados de stock en la tabla: «Sin stock · 2 · bajo · 7» — cada variante muestra un solo estado: normal, bajo (≤3) o sin stock
- Retirar: «Eliminar producto»
- Confirmación: «¿Retirar "Vestido midi de lunares" de la tienda? · Dejará de verse, pero se conservará en los pedidos anteriores. · Retirar de la tienda · Cancelar»

**Tipografía**
- Título: `text32w800`
- Migas: `text12w400`
- Celda de variante: `text13w400`
- Stock bajo: `text13w800 acento oscuro`
- Botón de retirar: `text12w800 caps acento`

**Comportamiento**
- Guardar sólo envía lo que ha cambiado, para no pisar el trabajo de otra sesión.
- Cambiar el stock a cero oculta la talla en la tienda al instante, sin borrar la variante.
- No se permite borrar una variante que aparece en pedidos: se pone a cero y se marca como retirada.
- «Eliminar producto» retira de la tienda; no borra de la base de datos si tiene pedidos.
- Se detecta la edición simultánea comparando la versión al guardar.

**Estados**
- Guardando: botón con progreso; el resto del formulario sigue usable.
- Guardado: aviso efímero «Cambios guardados» y marca de hora junto al título.
- Conflicto: `ADM-08` con opción de recargar; no se sobrescribe nada.

**Errores**
- `ADM-01` — referencia duplicada al cambiarla.
- `ADM-02` — variante repetida al añadir.
- `ADM-04` — precio rebajado incoherente.
- `ADM-07` — intento de borrar un producto con pedidos.
- `ADM-08` — edición simultánea de dos sesiones.
- `ADM-06` — al mover de categoría, categoría de destino inexistente.

**Datos**
```
GET /admin/productos/:id → producto con variantes, imágenes y versión
PATCH /admin/productos/:id {cambios, version} → 409 si la versión no coincide
DELETE /admin/productos/:id → retirada lógica si tiene pedidos
```

---

## Pantalla 19 · Gestión de pedidos y conciliación

**Objetivo:** ver de un vistazo qué hay que cobrar, preparar y enviar, y resolver las discrepancias del Bizum con la política ya acordada ([order-rules.md](order-rules.md)).

**Contenido literal**
- Título y recuento: «Pedidos · 128 pedidos · 1 pendiente de pago»
- Indicadores: «Ventas del mes · Pendientes de pago · Por preparar · Sin stock»
- Filtros: «Nº de pedido o cliente · Todos los estados · Últimos 30 días · Exportar CSV»
- Columnas: «Pedido · Cliente · Fecha · Art. · Total · Estado · Acción»
- Acción por estado: «Marcar como pagado · Marcar enviado · Marcar entregado · Cerrado · Stock liberado»
- Conciliación: «Conciliación de Bizum · 3 casos requieren tu decisión · Cada caso llega con la acción por defecto que acordamos.»
- Acciones de conciliación: «Devolver y cancelar · Reactivar pedido · Asignar a pedido · Devolver importe · Resolver a mano»

**Tipografía**
- Título: `text32w800`
- Cifra de indicador: `text32w800`
- Etiqueta de indicador: `text11w800caps`
- Cabecera de tabla: `text11w800caps`
- Número de pedido: `text15w800`
- Botón de acción en fila: `text11w800 caps`

**Comportamiento**
- Cada fila ofrece sólo la acción que permite su estado; las transiciones inválidas no se dibujan (ver [transiciones permitidas](order-rules.md#transiciones-permitidas)).
- «Marcar como pagado» pide confirmar el importe recibido y deja registro con fecha y usuario.
- La bandeja de conciliación separa los casos por tipo y muestra recibido, esperado y acción acordada.
- «Reactivar pedido» revalida stock: si falta una línea, la única acción posible pasa a ser la devolución completa.
- Un Bizum sin concepto no se asigna por parecido de importe: se ofrece escribir al cliente primero.
- Exportar CSV respeta los filtros aplicados y no incluye datos de pago del cliente.

**Estados**
- Carga: seis filas grises del alto de la tabla.
- Sin casos: «No hay nada pendiente de conciliar» y el contador del menú desaparece.
- Aplicando: la fila queda deshabilitada mientras se aplica; el resto de la tabla sigue usable.

**Errores**
- `BIZ-03` — importe distinto: acción acordada, devolver y cancelar.
- `BIZ-04` — Bizum tardío con stock: reactivar.
- `BIZ-05` — Bizum tardío sin stock: devolución completa.
- `BIZ-06` — dos Bizums al mismo pedido.
- `ADM-09` — Bizum sin concepto: escribir antes de asignar.
- (sin código) — transición de estado inválida: se rechaza y no se ofrece.

**Datos**
```
GET /admin/pedidos?estado=&desde=&hasta=&q=&pagina= → pedidos[], indicadores{}
POST /admin/pedidos/:numero/estado {estado, importeRecibido, motivo}
GET /admin/bizum/pendientes → casos[]{tipo, recibido, esperado, candidatos[], accionPorDefecto}
POST /admin/bizum/:id/resolver {accion, pedidoDestino}
```

---

## Pantalla 20 · Error 404

**Objetivo:** recoger a quien se ha perdido y devolverlo al catálogo en un toque, sin culparle del enlace roto.

**Contenido literal**
- Antetítulo: «Error 404»
- Titular: «Esta página no existe»
- Explicación: «Puede que la prenda ya no esté disponible o que el enlace esté mal escrito.»
- Acciones: «Volver al inicio · Ver novedades»
- Variante de prenda: «Esta prenda ya no está en la tienda» — con salida a su categoría, no a la portada

**Tipografía**
- Antetítulo: `text11w800caps acento`
- Titular: `text64w800 / 34`
- Explicación: `text16w400 / 14`
- Botones: `text14w800 caps / 13`

**Comportamiento**
- Se sirve con código 404 real, no como página normal, para no ensuciar el buscador.
- Conserva cabecera y pie: desde aquí se puede seguir comprando.
- Si la ruta era de un producto, se usa la variante con salida a su categoría.
- Sin buscador propio: el de la cabecera ya está a mano.

**Estados**
- Genérica: ruta desconocida.
- De producto: producto despublicado, con salida a la categoría (`CAT-06`).

**Errores**
- `SYS-01` — página inexistente.
- `CAT-06` — producto retirado de la tienda.
- `SYS-04` — ruta de administración sin permiso: se responde 404, no 403.

**Datos**
No necesita datos propios. Cabecera y pie se cargan igual que en el resto de la tienda. Se registra la ruta fallida para detectar enlaces rotos.

---

## Checklist antes de dar una pantalla por terminada

- [ ] Todos los textos visibles salen de este documento o del anexo de mensajes: ninguno está escrito a mano en el código.
- [ ] Los tres pesos de Archivo (400, 600 y 800) están empaquetados y no hay salto de fuente al abrir.
- [ ] Ninguna esquina redondeada, ninguna sombra, y los filetes son de 2 px en sección y 1 px dentro.
- [ ] Las versalitas van en mayúsculas y con interletrado abierto, nunca a 0.
- [ ] Ninguna zona pulsable en móvil por debajo de 44×44 px.
- [ ] Cada campo valida al salir del foco y muestra su mensaje debajo, no en un resumen.
- [ ] Los estados de carga reservan el hueco de la imagen: nada salta al terminar de cargar.
- [ ] Cada pantalla tiene resuelto su estado vacío, su estado de carga y su estado sin red.
- [ ] El foco de teclado se ve en cada elemento interactivo, con el contorno de 2 px en acento.
- [ ] El recorrido completo funciona con teclado, incluidos el carrusel y el menú de categorías.
- [ ] Los textos alternativos de las imágenes de producto llevan el nombre de la prenda.
- [ ] Confirmar pedido es idempotente: dos pulsaciones no crean dos pedidos.
- [ ] La cuenta atrás de los 30 minutos sale de la hora del servidor y sobrevive a una recarga.
- [ ] Teléfono de Bizum, minutos de reserva y umbral de envío gratis se leen de configuración.
- [ ] Ninguna transición de estado inválida es posible desde el panel.
- [ ] Probado en móvil real a 390 px y en escritorio a 1280 px, no sólo redimensionando la ventana.

## Pendiente de decisión

1. **Teléfono de Bizum definitivo.** En las maquetas aparece `612 34 56 78`, de muestra. Bloquea la pantalla 9 y el correo de confirmación.
2. **Lista de deseos en la primera versión.** Está dibujada (corazón en la tarjeta y en la ficha, pestaña en Mi cuenta). Si se deja para más adelante, se retiran los tres puntos de entrada, no se dejan sin función.
3. **Árbol de categorías cerrado.** «Camisetas, bodies y tops» ya está confirmado. Falta el resto y su orden en el menú (pantalla 2).
4. **Textos legales y de envíos.** Aviso legal, privacidad, cookies y condiciones de envío y devolución, para volcarlos en la plantilla común (pantallas 13-14).
5. **Cobertura y coste de envío.** Umbral de envío gratis (en maqueta, 40 €), coste por debajo del umbral y si hay recargo a Canarias y Baleares.
