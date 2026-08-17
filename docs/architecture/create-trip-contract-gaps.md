# Crear Viaje — Brechas de contrato (Postman vs flujo app)

Fuente: `Buses Miski Mayo - App Movil.postman_collection.json`

## 1. Estado inicial (`estado` / `fechaApertura`)

| Postman `POST /api/Viaje/Crear` | Flujo funcional app |
| --- | --- |
| Envía `estado: "A"` y `fechaApertura` | Crear → **Por iniciar** → Aperturar → En curso |
| Descripción: `A = aperturado` | Existe `POST /api/Viaje/Aperturar` aparte |

**Hallazgo staging:** omitir esos campos responde
`400 — Los campos obligatorios del viaje son requeridos.`

**Decisión de app:** enviar siempre:

- `estado: "P"` (programado / por iniciar, alineado a Historial)
- `fechaApertura`: misma marca que `fechaProgramado` (el SP exige el campo)

Si el backend solo acepta `A` y abre al crear, habrá que unificar UX (sin paso “Por iniciar”) o que backend acepte `P` sin aperturar.

---

## 2. `choferId`

Postman envía `choferId: 1` (entero). Bootstrap **no** incluye choferes.

**Contrato Login confirmado (staging):**

```json
"User": {
  "driverId": "1",
  "id": "000000888",
  "username": "pbeltran",
  ...
}
```

- `driverId` = código de chofer = `choferId` de `POST /api/Viaje/Crear`
- `id` = identificador de usuario (**no** usar como choferId)

**Decisión de app:** `EnvAwareChoferIdResolver` usa `int.tryParse(User.driverId)`.
Si falta `driverId`: en DEV mock `1`; en staging/prod se bloquea pidiendo re-login / ajuste backend.

---

## 3. `detalles` (paraderos de la ruta)

Postman hardcodea `{ paraderoId: 5, orden: 1 }`. Bootstrap staging `Paraderos`
**no trae** `rutaId` (solo `ParaderoId`, `Nombre`, coords, `RadioMetros`).

**Decisión de app:**

1. Si algún paradero trae `rutaId` coincidente → se usan automáticamente.
2. Si no hay relación → UI muestra desplegable **Paradero** obligatorio y se
   envía en `detalles` la selección del conductor (sin hardcodear id 5).

---

## 4. Offline

`CREATE_TRIP` aparece en el schema Drift / docs, pero `SyncWorker` **no** procesa esa acción. Política actual: **requiere conexión** para crear viaje.

## 5. Historial no lista viajes recién creados (`estado: P`)

Tras `Viaje/Crear` exitoso, `POST /api/Viaje/Historial` puede devolver `Data: []`
para el mismo usuario/chofer.

**Workaround app:** tras crear, se inserta el viaje en “Viajes de Hoy” con los
datos del formulario si Historial no lo trae (para poder aperturar).

**Pedido backend:** Historial debe incluir viajes programados (`P`) del chofer
del día (o documentar el filtro `estado`/`desde`/`hasta` correcto).
