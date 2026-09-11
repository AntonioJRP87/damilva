# Reglas de negocio: pedidos, stock y Bizum

Reglas de dominio para el futuro feature de pedido/checkout (aún no implementado). Son la fuente de verdad para el diseño de entidades, casos de uso y estados del Bloc cuando se aborde ese feature — no se derivan del código porque el código todavía no existe.

## Reserva de stock
- El stock **no** se reserva al añadir al carrito. Se reserva al confirmar el pedido, y dura 30 minutos.
- El temporizador lo manda el servidor: la pantalla muestra la cuenta atrás, pero la verdad es la hora de caducidad que devuelve el pedido. Si el cliente recarga, la cuenta sigue donde estaba (no se reinicia en cliente).
- Al caducar: el pedido pasa a `Cancelado`, el stock se libera y se envía correo de aviso.

**Carrito tras caducidad (Política 3)**
- El carrito se conserva con sus líneas, ya sin reserva.
- Al volver, se revalida contra stock: lo agotado se marca en la línea y no cuenta en el total; lo que excede la disponibilidad se ajusta a la baja.

## Idempotencia
- Confirmar pedido lleva clave de idempotencia: dos pulsaciones o un reintento tras fallo de red no pueden crear dos pedidos.
- El botón se deshabilita mientras la petición está en vuelo.

## Conciliación del Bizum
- La conciliación es **manual**: no hay integración bancaria. La administradora marca el pago en el panel.
- Tres datos identifican el pago: teléfono, importe exacto y concepto (número de pedido). Los tres se muestran destacados y copiables.

**Política 1 · importe distinto**
- Se devuelve lo recibido y se cancela el pedido.
- Estado intermedio: `Pago en revisión`.
- Si el cliente escribe en la hora siguiente, se reactiva si hay stock.

**Política 2 · Bizum tardío**
- Se reactiva el pedido si hay stock de todas las líneas.
- Si falta una sola, devolución completa: nunca se sirve a medias.

**Sin concepto**
- No se asigna a ningún pedido por parecido de importe: se escribe primero al cliente.

## Estados del pedido
| Estado | Significado |
|---|---|
| Pendiente de pago | Creado y con stock reservado 30 min. Muestra los datos del Bizum. |
| Pago en revisión | Ha llegado un Bizum que no cuadra en importe, concepto o plazo. |
| Pagado | Bizum conciliado. Stock consumido definitivamente. |
| Enviado | Entregado al transporte. Admite número de seguimiento. |
| Entregado | Cerrado. Sin acciones en el panel. |
| Cancelado | Por tiempo agotado, por importe distinto o a mano. Stock liberado. |
| Devuelto | Importe devuelto al cliente; el pedido queda cerrado con el motivo. |

**Transiciones permitidas** (cualquier otra combinación se rechaza y no se ofrece en el panel):
- `Pendiente de pago` → `Pagado`, `Cancelado` o `Pago en revisión`
- `Pago en revisión` → `Pagado` o `Cancelado`
- `Pagado` → `Enviado`
- `Enviado` → `Entregado`
- `Cancelado` → `Pagado` (sólo por reactivación)

**Historial**
- Todo cambio de estado queda registrado con fecha, importe, usuario y motivo.
- El historial no se borra ni se edita.

## Configurable, nunca en código
Se leen de configuración y se pueden cambiar sin volver a publicar:
- Teléfono de Bizum
- Minutos de reserva de stock
- Umbral de envío gratis
- Plazo de entrega
- Correo de contacto
