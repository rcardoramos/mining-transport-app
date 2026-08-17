# Manifiesto anticipado — notas de contrato

## Endpoint

`POST /api/Viaje/Manifiesto`

Body: `{ usuario, token, viajeId }`

Response: `{ Success, Message, Data: { cabecera, pasajeros } }`

## Comportamiento esperado (producto)

Debe permitir consultar viajes **EN CURSO** y devolver los pasajeros registrados hasta ese instante.

## App

1. Con red: llama `Viaje/Manifiesto` (fuente de verdad).
2. Offline: genera con `Pasajero/Lista` / datos locales del viaje.
3. Si `Viaje/Manifiesto` falla por error genérico/red: fallback a lista de pasajeros.
4. Si el backend responde que **solo admite viajes cerrados/finalizados**: **no** hay workaround silencioso; se muestra el mensaje y se pide ajuste backend.
5. La generación **no** cierra ni altera el estado del viaje.

## Validación staging

Pendiente confirmar en staging con un viaje `Estado=A` / EN CURSO:

- Si `Success=true` y trae pasajeros actuales → OK.
- Si rechaza por estado → documentar `Message`/`statusCode` aquí y solicitar cambio backend.

Ver colección Postman: `Buses Miski Mayo - App Movil.postman_collection.json`.
