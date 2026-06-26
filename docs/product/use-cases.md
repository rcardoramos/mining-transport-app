# Casos de Uso: APP Buses (Miski Mayo)

Este documento detalla los principales Casos de Uso (UC) de la aplicación, definiendo los actores, flujos principales y flujos alternativos.

## UC-01: Autenticación de Usuario (Online/Offline)
* **Actores**: Operador de Despacho (Usuario)
* **Precondiciones**: Ninguna.
* **Flujo Principal**:
  1. El operador ingresa a la aplicación.
  2. Digita su usuario y contraseña.
  3. Presiona el botón "Ingresar".
  4. La aplicación verifica que el dispositivo tenga conexión a internet y envía las credenciales a ADRYAN.
  5. ADRYAN valida las credenciales y responde con un token JWT y datos del operador.
  6. La aplicación guarda el token y las credenciales cifradas localmente en *Secure Storage*.
  7. El operador ingresa al panel principal.
* **Flujo Alternativo (Offline)**:
  1. En el paso 4, la aplicación detecta que no hay internet.
  2. El sistema busca las credenciales almacenadas localmente.
  3. Compara el hash de la contraseña ingresada con la almacenada localmente.
  4. Si coincide, autoriza el ingreso en modo local/offline.

## UC-02: Descarga de Datos Maestros (Sincronización Inicial)
* **Actores**: Sistema, Operador
* **Precondiciones**: Conexión a internet estable al iniciar sesión.
* **Flujo Principal**:
  1. Tras un inicio de sesión online exitoso, la app inicia la descarga de catálogos maestros de ADRYAN.
  2. Descarga la lista de Conductores (`Drivers`), Vehículos (`Buses`), Rutas (`Routes`), Servicios (`Services`) y Trabajadores (`Passengers` con sus estados de EMO e inducciones).
  3. Inserta todos los registros en las tablas locales correspondientes de Drift en una sola transacción para consistencia.
  4. Al finalizar, la app marca el estado del dispositivo como "Preparado para Operación Offline".

## UC-03: Apertura de Viaje
* **Actores**: Operador de Despacho
* **Precondiciones**: Operador autenticado.
* **Flujo Principal**:
  1. El operador ingresa a la opción "Apertura de Viaje".
  2. Selecciona la Ruta, el Servicio, el Bus y el Conductor de las listas desplegables (cargadas desde la BD local).
  3. Digita el Kilometraje Inicial del bus en pantalla.
  4. Presiona "Confirmar e Iniciar Viaje".
  5. La app guarda el viaje localmente en Drift con estado "Open".
  6. Inserta una tarea en `SyncQueue` para sincronizar la apertura del viaje.
  7. Navega a la pantalla de control de aforo y escaneo.

## UC-04: Control de Embarque (Escaneo de DNI)
* **Actores**: Operador de Despacho, Pasajero
* **Precondiciones**: Viaje abierto y activo.
* **Flujo Principal**:
  1. El operador presiona "Escanear Pasajero" para activar la cámara.
  2. Enfoca el código PDF417 al reverso del DNI del trabajador.
  3. El sistema decodifica el DNI, recupera el número de documento y busca al pasajero en la base de datos local.
  4. Comprueba las vigencias laborales, examen médico e inducción (`RN-VAL-01`).
  5. Si es válido, incrementa el aforo local y muestra pantalla verde "Acceso Aprobado".
  6. Registra el `BoardingRecord` en la base de datos local y añade la tarea a `SyncQueue`.
  7. Reproduce el sonido de aprobación.
* **Flujo Alternativo (Bloqueo)**:
  1. En el paso 4, la BD local indica que el trabajador tiene el examen médico vencido o la inducción vencida.
  2. La app bloquea el registro de abordaje.
  3. Muestra pantalla roja indicando el motivo detallado de bloqueo.
  4. Reproduce el sonido de error e impide que el pasajero ingrese al bus.

## UC-05: Cierre de Viaje
* **Actores**: Operador de Despacho, Conductor
* **Precondiciones**: Viaje abierto.
* **Flujo Principal**:
  1. El operador finaliza el embarque en el paradero final y presiona "Cerrar Viaje".
  2. Ingresa el Kilometraje Final del bus.
  3. El conductor y el operador firman digitalmente en la pantalla del dispositivo.
  4. Presiona "Guardar y Cerrar".
  5. La app actualiza el estado del viaje a "Closed" en Drift.
  6. Almacena las firmas como imágenes/SVG localmente vinculadas al viaje.
  7. Genera el Manifiesto en PDF.
  8. Añade la tarea de cierre de viaje a `SyncQueue`.
  9. Despliega la opción para imprimir físicamente el manifiesto.
