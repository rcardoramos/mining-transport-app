# Modelo de Dominio: Arquitectura Basada en DDD (Domain-Driven Design)

Este documento detalla las entidades de dominio, sus relaciones y reglas fundamentales en el contexto del sistema de transporte minero.

```
                    +-------------+
                    |    Trip     |
                    +-------------+
                     /    |     \
                    /     |      \
                   v      v       v
            [Driver]   [Bus]    [Route] -- (has many) --> [BusStop]
                                  |
                                  v
                             [Service]
                                  |
                                  v
                             [Schedule]
```

---

## 1. Agregados y Entidades del Dominio

### A. Entidad: User (Usuario)
Representa al personal administrativo, despachador o supervisor que opera la aplicación móvil.
* **Atributos**:
  * `id`: UUID (Identificador único).
  * `username`: String (Código de usuario corporativo).
  * `fullName`: String (Nombres y apellidos completos).
  * `role`: Enum (`ADMIN`, `DISPATCHER`, `SUPERVISOR`).
  * `token`: String? (Token JWT de sesión activa).

### B. Entidad: Driver (Conductor)
Conductor asignado al traslado de personal minero.
* **Atributos**:
  * `id`: UUID (Identificador único).
  * `code`: String (Código interno del conductor).
  * `fullName`: String (Nombres completos).
  * `licenseNumber`: String (Número de licencia de conducir).
  * `licenseExpiration`: DateTime (Fecha de vencimiento de la licencia).
  * `isActive`: Boolean (Estado operativo).
* **Validaciones**:
  * No se puede asignar a un viaje si la licencia está vencida.

### C. Entidad: Bus (Vehículo)
Vehículo físico utilizado para el transporte.
* **Atributos**:
  * `id`: UUID.
  * `plateNumber`: String (Placa única del bus).
  * `capacity`: Integer (Capacidad física total de pasajeros).
  * `model`: String (Modelo/Marca).
  * `isActive`: Boolean (Estado operativo).
* **Reglas**:
  * El aforo máximo en `Trip` está delimitado directamente por `capacity`.

### D. Entidad: Route (Ruta)
El trayecto geográfico predefinido del viaje.
* **Atributos**:
  * `id`: UUID.
  * `name`: String (ej. "Piura - Mina Miski Mayo").
  * `origin`: String (Punto de partida).
  * `destination`: String (Punto de llegada).
  * `distanceKm`: Double (Distancia estimada en kilómetros).

### E. Entidad: BusStop (Paradero)
Puntos de embarque intermedios asociados a una ruta específica.
* **Atributos**:
  * `id`: UUID.
  * `routeId`: UUID (Relación con Ruta).
  * `name`: String (ej. "Cruce Catacaos").
  * `latitude`: Double (Coordenada Y).
  * `longitude`: Double (Coordenada X).

### F. Entidad: Passenger (Pasajero/Empleado)
Trabajador de mina o contratista calificado para abordar.
* **Atributos**:
  * `id`: UUID.
  * `docNumber`: String (DNI, 8 dígitos numéricos).
  * `code`: String (Código de fotocheck o de empleado).
  * `firstName`: String.
  * `lastName`: String.
  * `companyName`: String (Empresa a la que pertenece: Miski Mayo o Contratista).
  * `status`: String (Estado laboral: "Active", "Inactive").
  * `emoExpirationDate`: DateTime (Examen Médico Ocupacional).
  * `inductionExpirationDate`: DateTime (Inducción de seguridad).
  * `hasSecurityBlock`: Boolean (Bloqueo de seguridad disciplinario).

### G. Entidad: Trip (Viaje - AGGREGATE ROOT)
Representa la sesión activa de un transporte de personal. Es la raíz del agregado de embarque.
* **Atributos**:
  * `id`: UUID.
  * `driverId`: UUID (Conductor asignado).
  * `busId`: UUID (Vehículo asignado).
  * `routeId`: UUID (Ruta del viaje).
  * `serviceId`: UUID (Servicio del viaje).
  * `startKm`: Integer (Kilometraje al abrir el viaje).
  * `endKm`: Integer? (Kilometraje al cerrar el viaje).
  * `startTime`: DateTime (Apertura).
  * `endTime`: DateTime? (Cierre).
  * `status`: Enum (`Open`, `Closed`, `Syncing`, `Synced`).
* **Reglas de Agregado**:
  * No se pueden añadir `BoardingRecords` si `status` es diferente de `Open`.
  * `endKm` debe ser mayor que `startKm` obligatoriamente al cerrar.

### H. Entidad: BoardingRecord (Registro de Abordaje)
El evento transaccional individual de embarque de un pasajero.
* **Atributos**:
  * `id`: UUID.
  * `tripId`: UUID (Relación con Trip).
  * `passengerId`: UUID (Relación con Passenger).
  * `busStopId`: UUID (Paradero en el cual abordó).
  * `scanType`: Enum (`DNI`, `FOTOCHECK`, `MANUAL`).
  * `scanTimestamp`: DateTime (Fecha y hora exacta del escaneo).
  * `latitude`: Double (GPS de auditoría).
  * `longitude`: Double (GPS de auditoría).
  * `status`: Enum (`Boarded`, `Cancelled`).
  * `justification`: String? (Motivo si es registro manual o cancelación).

### I. Entidad: SyncQueue (Cola de Sincronización)
Representa una transacción local pendiente de envío al servidor de ADRYAN.
* **Atributos**:
  * `id`: Integer (Clave incremental autogenerada).
  * `actionType`: String (ej. "CREATE_TRIP", "BOARD_PASSENGER", "CLOSE_TRIP").
  * `payloadJson`: String (Representación JSON del DTO correspondiente).
  * `status`: Enum (`Pending`, `Synced`, `Error`).
  * `errorDetails`: String? (Mensajes de error HTTP del servidor).
  * `attempts`: Integer (Contador de reintentos).
  * `createdAt`: DateTime (Fecha de creación del log).
