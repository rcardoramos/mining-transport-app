# Crear Viaje — Brechas de contrato (Postman vs flujo app)

Fuente: `Buses Miski Mayo - App Movil.postman_collection.json`

## 1. Estado inicial (`estado` / `fechaApertura`)

| Postman `POST /api/Viaje/Crear` | Flujo funcional app |
| --- | --- |
| Envía `estado: "A"` y `fechaApertura` | Crear → **Por iniciar** → Aperturar → En curso |
| Descripción: `A = aperturado` | Existe `POST /api/Viaje/Aperturar` aparte |

**Decisión de app:** el request de creación **omite** `estado` y `fechaApertura` para no aperturar al crear. No se envía `estado: "P"` sin confirmación del backend.

**Impacto:** si el SP `uspABSViajeCrear` exige esos campos, la creación fallará con el `Message` del wrapper; la UI lo muestra.

**Opciones:**

1. Backend acepta omitir campos → viaje queda programado/pendiente.
2. Backend define `estado` programado (p. ej. `"P"`) sin `fechaApertura`.
3. Backend confirma que Crear siempre aperturan → unificar UX (sin paso “Por iniciar”).

**Recomendación:** opción 2, alineada a Historial (`Estado: P` / `C` / `A`).

---

## 2. `choferId`

Postman envía `choferId: 1` (entero). Bootstrap **no** incluye choferes. Login `User.id` en docs es string (`DRV-998`); no hay contrato `User.id == choferId`.

**Decisión de app:** no enviar `User.id` como `choferId` por coincidencia de nombre. La creación falla con mensaje claro hasta que backend defina el mapeo (campo numérico en Login, catálogo Choferes, o endpoint de perfil).

---

## 3. `detalles` (paraderos de la ruta)

Postman hardcodea `{ paraderoId: 5, orden: 1 }`. Bootstrap `Paraderos` no documenta `rutaId`.

**Decisión de app:** no hardcodear paradero 5. Si un paradero trae `rutaId`/`RutaId` en runtime, se filtran por la ruta seleccionada. Si no hay relación, la creación se bloquea con mensaje claro.

---

## 4. Offline

`CREATE_TRIP` aparece en el schema Drift / docs, pero `SyncWorker` **no** procesa esa acción. Política actual: **requiere conexión** para crear viaje.
