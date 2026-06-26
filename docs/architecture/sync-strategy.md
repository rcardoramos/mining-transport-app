# Estrategia de Sincronización: Cola Persistente y Procesamiento Background

Este documento especifica el funcionamiento del motor de sincronización (`SyncManager`), la gestión de la cola y las políticas de reintento del sistema.

---

## 1. Arquitectura de Sincronización

La sincronización se basa en el patrón de **Cola de Mensajes Persistente (Transactional Outbox Pattern)**. Todo cambio transaccional en la aplicación genera un evento en la tabla `SyncQueue`.

```
 +-----------------------------------------------------------------+
 |                           SyncManager                           |
 +-----------------------------------------------------------------+
    ^                               ^                         ^
    | (1) Escucha                   | (2) Dispara             | (3) Ejecuta
 +---------------------+   +-------------------+   +--------------------+
 | ConnectivityMonitor |   |   Eventos de UI   |   |     SyncWorker     |
 +---------------------+   +-------------------+   +--------------------+
                                                             |
                                                             v (FIFO)
                                                   +--------------------+
                                                   |     SyncQueue      |
                                                   +--------------------+
                                                             |
                                                             v (Envía a)
                                                   +--------------------+
                                                   |   API REST (Dio)   |
                                                   +--------------------+
```

### Componentes Clave
1. **ConnectivityMonitor**: Escucha de forma reactiva los cambios de red utilizando la librería `Connectivity Plus`. Ante una transición de desconectado a conectado, notifica al `SyncManager`.
2. **SyncManager**: Orquestador principal de la sincronización. Se encarga de levantar y apagar el procesamiento de la cola, previniendo condiciones de carrera (race conditions).
3. **SyncWorker**: Hilo o proceso de ejecución (que puede correr en background) encargado de:
   * Leer las tareas pendientes de `SyncQueue` en orden estrictamente secuencial (FIFO) ordenadas por fecha.
   * Ejecutar la petición HTTP correspondiente a través del cliente `Dio`.
   * Actualizar el estado del registro local según la respuesta.

---

## 2. Flujo de Ejecución del SyncWorker

```
[Leer registro FIFO con status = Pending]
                   |
                   v
     [Enviar Petición REST a API]
                   |
         +---------+---------+
         |                   |
         v (Éxito HTTP 2xx)  v (Fallo)
    [Marcar Synced]          {¿Es Error de Red/Servidor?}
         |                   |
         v                   +---- Sí ----> [Incrementar Attempts + Reintento Exponencial]
  [Procesar Siguiente]       |
                             +---- No (HTTP 4xx) -> [Marcar status = Error + Detener Cola]
```

---

## 3. Estrategia de Reintentos y Backoff Exponencial

Si una petición HTTP falla por problemas de conectividad o indisponibilidad del servidor (errores de red, tiempos de espera superados, códigos HTTP 502, 503, 504), se aplica la siguiente política:
* **Fórmula de Reintento**:
  $$T_{\text{espera}} = \text{Base} \times 2^{\text{intentos}} + \text{Jitter}$$
  * *Base*: 5 segundos.
  * *Jitter*: Variación aleatoria de ±1-2 segundos para evitar saturación del servidor por múltiples dispositivos reconectándose al mismo tiempo.
* **Tiempos aproximados**:
  * Intento 1: 5s
  * Intento 2: 10s
  * Intento 3: 20s
  * Intento 4: 40s
  * Intento 5: 80s
* **Límite de Intentos**: Si tras 5 intentos el servidor sigue inaccesible, el estado del registro de la cola cambia a `Error` y se notifica al usuario en el panel de sincronización. El procesamiento de la cola continúa con los siguientes registros si no hay dependencias.

---

## 4. Resolución de Conflictos

| Tipo de Conflicto | Escenario | Solución Arquitectónica |
| :--- | :--- | :--- |
| **Conflicto 409 (Duplicado)** | El abordaje de un pasajero ya existe registrado en el servidor de ADRYAN (por ejemplo, porque una sincronización anterior se envió pero la confirmación HTTP se perdió por corte de red). | **Auto-Resolución**: El `SyncWorker` interpreta el HTTP 409 como un éxito implícito. Actualiza el estado local a `Synced` y continúa con el siguiente elemento. |
| **Viaje ya cerrado en Servidor** | Se intenta enviar un abordaje a un viaje que el servidor ya tiene registrado como cerrado. | **Error de Operación**: El registro se marca con `status = Error` y se agrega a la bitácora de auditoría. Se requiere acción del supervisor para reabrir el viaje o anular el abordaje local. |
| **Kilometraje Inconsistente** | El kilometraje final ingresado offline es menor que el registrado en otra operación en el servidor. | **Forzar validación**: Se detiene la sincronización de ese registro y se genera una alerta en la app solicitando la corrección del kilometraje. |

---

## 5. Sincronización en Segundo Plano (Background Sync)
* Se utiliza la integración con `WorkManager` (Android) y `Background Fetch` (iOS) para registrar tareas del sistema operativo.
* El sistema operativo despertará al `SyncWorker` periódicamente (típicamente cada 15 minutos en Android) para procesar la cola si existen elementos pendientes y el dispositivo tiene internet, asegurando que el servidor se mantenga actualizado incluso si la aplicación ha sido minimizada o cerrada por el operador.
