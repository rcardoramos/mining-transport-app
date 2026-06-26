# Criterios de Aceptación: APP Buses (Miski Mayo)

Este documento define las condiciones necesarias para que las funcionalidades sean consideradas terminadas y correctas por el equipo de calidad.

## 1. Módulo: Gestión de Viajes (Apertura de Viaje)
### Escenario 1: Apertura exitosa de viaje con red u offline
* **Dado que** el operador está autenticado y se encuentra en la pantalla de "Apertura de Viaje",
* **Cuando** selecciona un Servicio, una Ruta, un Bus (con capacidad de 40 pasajeros), un Conductor, e ingresa el Kilometraje Inicial "120500",
* **Y** presiona el botón "Iniciar Viaje",
* **Entonces** la base de datos local registra un nuevo registro en la tabla `Trips` con estado `Open` y `SyncStatus = Pending`,
* **Y** redirige a la pantalla de "Control de Embarque" del viaje iniciado.

## 2. Módulo: Registro de Pasajeros (Escaneo y Validación)
### Escenario 1: Escaneo de DNI de trabajador Activo y con EMO/Inducción vigentes
* **Dado que** hay un viaje abierto con aforo actual en 0/40,
* **Cuando** el operador escanea el código PDF417 de un DNI y se extrae el número "44556677",
* **Entonces** el sistema busca en la tabla local `Passengers` y valida que:
  * Su estado es "Activo".
  * Su examen médico está vigente (fecha de vencimiento posterior a hoy).
  * Su inducción está vigente (fecha de vencimiento posterior a hoy).
* **Y** muestra una pantalla verde gigante con el mensaje "ABORDADO: JUAN PEREZ",
* **Y** emite un pitido de confirmación,
* **Y** añade un registro en la tabla `BoardingRecords` con estado `Boarded`,
* **Y** el aforo se incrementa a 1/40.

### Escenario 2: Escaneo de DNI de trabajador con Examen Médico Ocupacional vencido
* **Dado que** hay un viaje abierto con aforo actual en 1/40,
* **Cuando** el operador escanea un DNI y se extrae el número "77889900",
* **Y** la base de datos local indica que su EMO está vencido (venció hace 5 días),
* **Entonces** el sistema muestra una pantalla roja gigante con el mensaje "BLOQUEADO: EXAMEN MÉDICO VENCIDO",
* **Y** emite un sonido grave de error durante 1.5 segundos,
* **Y** no crea ningún registro de abordaje en `BoardingRecords`,
* **Y** el aforo se mantiene en 1/40.

### Escenario 3: Intento de Doble Embarque
* **Dado que** el pasajero "JUAN PEREZ" con DNI "44556677" ya fue registrado en el viaje actual,
* **Cuando** el operador vuelve a escanear el DNI "44556677" en el mismo viaje,
* **Entonces** el sistema muestra una pantalla de advertencia amarilla con el mensaje "PASAJERO YA REGISTRADO EN ESTE VIAJE",
* **Y** emite un pitido de advertencia,
* **Y** no altera el conteo de aforo.

## 3. Módulo: Control de Aforo
### Escenario 1: Bloqueo de registro al llegar al aforo máximo
* **Dado que** el viaje abierto tiene un bus asignado con capacidad de 2 pasajeros,
* **Y** el aforo actual es de 2/2,
* **Cuando** el operador intenta escanear el DNI de un tercer pasajero válido,
* **Entonces** el sistema detiene el escaneo inmediatamente,
* **Y** muestra un modal con el mensaje "LÍMITE DE AFORO ALCANZADO",
* **Y** emite un sonido de bloqueo,
* **Y** no permite registrar al pasajero.

## 4. Módulo: Sincronización Offline First
### Escenario 1: Operación offline y sincronización posterior al recuperar red
* **Dado que** el dispositivo móvil se encuentra en "Modo Avión" (sin internet),
* **Cuando** el operador abre un viaje, registra 5 pasajeros activos y cierra el viaje,
* **Entonces** todas las transacciones se realizan con éxito en la base de datos local Drift,
* **Y** se crean 7 registros en la tabla `SyncQueue` con estado `Pending` (1 apertura, 5 abordajes, 1 cierre),
* **Cuando** el dispositivo recupera la conexión a internet,
* **Entonces** el `SyncManager` detecta el cambio de red, activa el `SyncWorker` y procesa los 7 registros de la cola en orden cronológico (FIFO) contra el servidor de ADRYAN,
* **Y** actualiza el estado de cada registro en `SyncQueue` a `Synced` tras recibir el HTTP 200 OK del backend.

## 5. Módulo: Generación e Impresión del Manifiesto PDF
### Escenario 1: Emisión física de manifiesto al cerrar viaje
* **Dado que** el operador cierra un viaje con 35 pasajeros registrados,
* **Cuando** presiona el botón "Imprimir Manifiesto",
* **Entonces** el sistema genera un PDF que contiene:
  * Logotipo de Miski Mayo.
  * Encabezado con datos del conductor, placa, kilómetros, fecha y hora.
  * Tabla con el número correlativo, nombres completos, DNI, empresa y paradero de los 35 pasajeros.
  * Campo de firmas del conductor y despachador.
* **Y** abre la interfaz de impresión nativa del sistema operativo para transferir el PDF a la ticketera móvil conectada.
