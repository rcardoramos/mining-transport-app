# Diseño de Base de Datos: Esquema Drift Relacional y Caché Local

Este documento define la estructura física de la base de datos local (Drift) optimizada para el rendimiento y la integridad de datos offline.

---

## 1. Esquema de Tablas (DDL / Definición en Drift)

```
   [users]           [drivers]         [buses]          [routes]
      |                  |                |                |
      v                  v                v                v
   [audit_logs]     +----------------------------------------+
                    |                 trips                  |
                    +----------------------------------------+
                                      |
                                      v
 [passengers] ----------------> [boarding_records] <-------- [bus_stops]
```

### 1.1 Tabla: Users
* `id` (Text, Primary Key)
* `username` (Text, Unique Index)
* `full_name` (Text)
* `role` (Text) - Valores: `ADMIN`, `DISPATCHER`, `SUPERVISOR`
* `token` (Text, Nullable)

### 1.2 Tabla: Drivers
* `id` (Text, Primary Key)
* `code` (Text, Unique Index)
* `full_name` (Text)
* `license_number` (Text)
* `license_expiration` (DateTime)
* `is_active` (Bool)

### 1.3 Tabla: Buses
* `id` (Text, Primary Key)
* `plate_number` (Text, Unique Index)
* `capacity` (Int)
* `model` (Text)
* `is_active` (Bool)

### 1.4 Tabla: Routes
* `id` (Text, Primary Key)
* `name` (Text)
* `origin` (Text)
* `destination` (Text)
* `distance_km` (Real)

### 1.5 Tabla: Services
* `id` (Text, Primary Key)
* `name` (Text)
* `code` (Text, Unique Index)

### 1.6 Tabla: BusStops
* `id` (Text, Primary Key)
* `route_id` (Text, References `routes(id)`)
* `name` (Text)
* `latitude` (Real)
* `longitude` (Real)

### 1.7 Tabla: Passengers
* `id` (Text, Primary Key)
* `doc_number` (Text, Unique Index) - DNI (Indexado para búsquedas < 50ms)
* `code` (Text, Unique Index) - Código de fotocheck (Indexado)
* `first_name` (Text)
* `last_name` (Text)
* `company_name` (Text)
* `status` (Text) - Valores: `Active`, `Inactive`
* `emo_expiration_date` (DateTime)
* `induction_expiration_date` (DateTime)
* `has_security_block` (Bool)

### 1.8 Tabla: Trips
* `id` (Text, Primary Key)
* `driver_id` (Text, References `drivers(id)`)
* `bus_id` (Text, References `buses(id)`)
* `route_id` (Text, References `routes(id)`)
* `service_id` (Text, References `services(id)`)
* `start_km` (Int)
* `end_km` (Int, Nullable)
* `start_time` (DateTime)
* `end_time` (DateTime, Nullable)
* `status` (Text) - Valores: `Open`, `Closed`, `Syncing`, `Synced`

### 1.9 Tabla: BoardingRecords
* `id` (Text, Primary Key)
* `trip_id` (Text, References `trips(id)`)
* `passenger_id` (Text, References `passengers(id)`)
* `bus_stop_id` (Text, References `bus_stops(id)`)
* `scan_type` (Text) - Valores: `DNI`, `FOTOCHECK`, `MANUAL`
* `scan_timestamp` (DateTime)
* `latitude` (Real)
* `longitude` (Real)
* `status` (Text) - Valores: `Boarded`, `Cancelled`
* `justification` (Text, Nullable)

### 1.10 Tabla: SyncQueue
* `id` (Int, Primary Key, AutoIncrement)
* `action_type` (Text) - Valores: `CREATE_TRIP`, `BOARD_PASSENGER`, `CLOSE_TRIP`
* `payload_json` (Text) - Estructura DTO serializada en JSON
* `status` (Text) - Valores: `Pending`, `Synced`, `Error`
* `error_details` (Text, Nullable)
* `attempts` (Int, Default 0)
* `created_at` (DateTime)

### 1.11 Tabla: AuditLogs
* `id` (Text, Primary Key)
* `user_id` (Text, References `users(id)`)
* `action` (Text)
* `timestamp` (DateTime)
* `details` (Text)

---

## 2. Índices de Rendimiento Críticos (Indexes)

Para garantizar búsquedas instantáneas (<100ms) durante el escaneo de pasajeros con miles de registros cargados en el dispositivo local, se definen los siguientes índices:

```sql
-- Index para búsquedas de DNI (Escaneo de DNI)
CREATE UNIQUE INDEX idx_passengers_doc_number ON passengers(doc_number);

-- Index para búsquedas por Fotocheck
CREATE UNIQUE INDEX idx_passengers_code ON passengers(code);

-- Index para el control de doble embarque e histórico del viaje
CREATE INDEX idx_boarding_records_trip_passenger ON boarding_records(trip_id, passenger_id);

-- Index para el procesamiento FIFO en la cola de sincronización
CREATE INDEX idx_sync_queue_status_time ON sync_queue(status, created_at);

-- Index para relacionar paraderos por ruta
CREATE INDEX idx_bus_stops_route ON bus_stops(route_id);
```

---

## 3. Integridad Referencial y Reglas de Base de Datos
* **Claves Ajenas (Foreign Keys)**: Habilitadas explícitamente en Drift en la inicialización de SQLite mediante `PRAGMA foreign_keys = ON;`.
* **Restricciones de Unicidad**: El DNI y código de fotocheck del pasajero deben ser únicos en la tabla `passengers` para evitar registros duplicados durante las sincronizaciones maestras parciales.
* **Historización**: No se configuran disparadores `ON DELETE CASCADE`. Todos los registros de la base de datos local se conservan; las cancelaciones se registran mediante inserciones de cambio de estado en `BoardingRecords`.
