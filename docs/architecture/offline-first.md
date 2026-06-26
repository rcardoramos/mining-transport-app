# Estrategia Offline First: Arquitectura y Gestión de Caché Local

Este documento detalla la estrategia **Offline First** del sistema "APP Buses" para garantizar la operatividad continua del embarque minero en zonas remotas de Miski Mayo.

---

## 1. Principios de Operación Local-First

```
+------------------+     (1) Escribe     +---------------------+
|   Acción de UI   | ------------------> | Base de Datos Local |
+------------------+                     +---------------------+
         |                                          |
         | (2) Genera                               | (3) Refleja
         v                                          v
+------------------+                     +---------------------+
| Tarea SyncQueue  |                     | UI Estado Actualizado|
+------------------+                     +---------------------+
```

1. **La base de datos local es la única fuente de verdad (Single Source of Truth)**: Los ViewModels y componentes de la UI solo leen e interactúan con la base de datos local Drift (`AppDatabase`).
2. **Escrituras no bloqueantes**: Cualquier inserción de datos (ej. aperturas de viajes, embarques de pasajeros) se escribe directamente en la base de datos local y se confirma en la UI de inmediato. La red nunca está en la ruta crítica del usuario.
3. **Persistencia de cola (`SyncQueue`)**: Cada cambio de estado local de tipo transaccional (escrituras) inserta paralelamente una tarea en la tabla `SyncQueue` dentro de la misma transacción de base de datos.
4. **Desconexión transparente**: La interfaz de usuario no cambia su flujo básico de registro si se pierde la red; únicamente muestra un indicador discreto del estado de conexión y el número de elementos pendientes en la cola de sincronización.

---

## 2. Estrategia de Almacenamiento Local

La aplicación utiliza tres mecanismos de almacenamiento diferentes según el tipo de datos:

| Tipo de Datos | Tecnología | Propósito | Cifrado |
| :--- | :--- | :--- | :--- |
| **Datos Relacionales** <br> (Maestros y Transacciones) | **Drift (SQLite)** | Guardar usuarios, conductores, buses, rutas, pasajeros, registros de abordaje y cola de sincronización. | Opcional (SQLCipher) |
| **Credenciales y Tokens** | **Flutter Secure Storage** | Almacenar JWT, PIN de acceso rápido y contraseña cifrada local del supervisor. | Sí (Keychain/Keystore nativos) |
| **Documentos Generados** | **Local Files System** <br> (`path_provider`) | Almacenar manifiestos de viaje en formato PDF generados localmente para reimpresiones inmediatas. | No |

---

## 3. Estados de Sincronización y Transición de Registros

Todos los registros transaccionales (viajes y abordajes) tienen un estado de sincronización mapeado en la base de datos local a través de la columna `sync_status`:

```
   [Registro Local Creado] 
             |
             v
      State: PENDING
             |
             v  (Procesado por SyncWorker)
     +-------+-------+
     |               |
     v (HTTP 200)    v (HTTP 500/400)
State: SYNCED    State: ERROR (con detalles en SyncQueue)
```

* **`Pending`**: El registro ha sido creado exitosamente de forma local, pero aún no se envía al backend.
* **`Synced`**: El registro fue transmitido al backend de ADRYAN y se ha confirmado su recepción (HTTP 200/201).
* **`Error`**: El servidor rechazó la transacción por error de validación o fallo del servidor. El operador puede visualizar el error e intentar la resolución o justificación.
