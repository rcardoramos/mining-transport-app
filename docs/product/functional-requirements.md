# Requerimientos Funcionales: APP Buses (Miski Mayo)

Este documento especifica los requerimientos funcionales del sistema, organizados por módulos de negocio.

## 1. Módulo de Autenticación (RF-AUTH)
* **RF-AUTH-01 (Login Online)**: El usuario (despachador o supervisor) debe poder iniciar sesión ingresando credenciales (usuario y contraseña) contra el backend corporativo.
* **RF-AUTH-02 (Caché de Credenciales)**: La aplicación debe almacenar las credenciales de forma cifrada (mediante *Flutter Secure Storage*) para permitir inicios de sesión locales en zonas sin internet (Login Offline).
* **RF-AUTH-03 (Acceso por PIN/Huella)**: Se debe permitir configurar un PIN de seguridad de 4 dígitos para accesos rápidos offline sin necesidad de reingresar la contraseña completa.

## 2. Módulo de Gestión de Viajes (RF-TRIP)
* **RF-TRIP-01 (Apertura de Viaje)**: El usuario debe poder abrir un viaje seleccionando el vehículo (Bus), el conductor (Driver), el servicio (ej. Entrada Guardia, Salida Guardia), la ruta (Origen - Destino) y registrando el kilometraje inicial del bus.
* **RF-TRIP-02 (Listado de Viajes Activos)**: La pantalla principal debe mostrar el viaje actualmente activo del operador, permitiéndole reanudar el registro de abordajes.
* **RF-TRIP-03 (Cierre de Viaje)**: El sistema debe permitir cerrar el viaje en curso ingresando el kilometraje final y recopilando la firma digital en pantalla del despachador y del conductor.
* **RF-TRIP-04 (Historial de Viajes)**: Visualizar el historial de viajes realizados localmente y su estado de sincronización hacia el ERP.

## 3. Módulo de Registro de Pasajeros (RF-PSG)
* **RF-PSG-01 (Escaneo de DNI - PDF417)**: La aplicación debe activar la cámara trasera y decodificar el código bidimensional PDF417 de la cédula de DNI peruano para extraer el número de documento, nombres, apellidos y fecha de nacimiento.
* **RF-PSG-02 (Escaneo de Fotocheck - QR/Code39)**: Permitir escanear el código de barras o QR del fotocheck de la mina para extraer el código de empleado.
* **RF-PSG-03 (Búsqueda e Ingreso Manual)**: Proveer una barra de búsqueda para ingresar el número de DNI o código de empleado manualmente en caso de desgaste físico de los documentos.
* **RF-PSG-04 (Justificación de Registro Manual)**: Si el registro se hace de forma manual, la aplicación debe requerir al usuario seleccionar el motivo (ej. "Código de barras ilegible", "Pérdida de documento").

## 4. Módulo de Validación Laboral (RF-VAL)
* **RF-VAL-01 (Consulta Local de Datos)**: Al capturar el identificador del pasajero, el sistema debe consultar la base de datos local (Drift) para evaluar las reglas `RN-VAL-01`.
* **RF-VAL-02 (Visualización de Estado)**:
  * **Acceso Permitido**: Mostrar pantalla con fondo verde gigante, nombres del pasajero y empresa contratista, y reproducir un sonido breve y agudo de aprobación.
  * **Acceso Bloqueado**: Mostrar pantalla con fondo rojo gigante, motivo detallado del bloqueo (ej. "Examen Médico Vencido") y reproducir un sonido grave y repetitivo de alerta.

## 5. Módulo de Geolocalización y Paraderos (RF-GEO)
* **RF-GEO-01 (Identificación de Paradero)**: El despachador debe poder seleccionar el paradero actual de una lista asociada a la ruta del viaje.
* **RF-GEO-02 (Sugerencia de Paradero Cercano)**: Utilizando el GPS del dispositivo, la aplicación debe sugerir automáticamente el paradero más cercano en un radio de 500 metros.
* **RF-GEO-03 (Auditoría GPS)**: Capturar y guardar en la tabla `BoardingRecords` la latitud, longitud, altitud y precisión del GPS en el instante exacto en que se realiza el abordaje.

## 6. Módulo de Control de Aforo (RF-OCC)
* **RF-OCC-01 (Indicador de Aforo)**: Mostrar visualmente una barra de progreso que indique los asientos ocupados versus el total disponible en el bus en tiempo real (ej. 32 / 40 - 80%).
* **RF-OCC-02 (Prevención de Sobreaforo)**: Bloquear automáticamente el botón de registro de abordajes al llegar al 100% de la capacidad del vehículo.

## 7. Módulo de Emisión de Manifiesto PDF (RF-MAN)
* **RF-MAN-01 (Generación de Manifiesto)**: Generar un archivo PDF formateado de acuerdo a los estándares de fiscalización minera que contenga el encabezado con datos del viaje (Bus, Placa, Conductor, Ruta, Kilometraje, Fecha/Hora de inicio y fin) y la lista detallada de pasajeros.
* **RF-MAN-02 (Previsualización)**: Permitir previsualizar el PDF antes de mandarlo a la cola de impresión.
* **RF-MAN-03 (Impresión Directa)**: Enviar el documento PDF a impresoras térmicas portátiles conectadas mediante Bluetooth o red local Wi-Fi utilizando el canal nativo de impresión del sistema operativo.

## 8. Módulo de Sincronización (RF-SYNC)
* **RF-SYNC-01 (Operación Offline)**: Garantizar que la app pueda realizar el login (offline), abrir viajes, registrar y validar pasajeros, y cerrar viajes sin conexión activa a internet.
* **RF-SYNC-02 (Cola de Sincronización Persistente)**: Cada acción de escritura local (Apertura de viaje, Registro de abordaje, Cierre de viaje) debe generar una tarea en la tabla `SyncQueue`.
* **RF-SYNC-03 (Monitoreo de Red)**: Escuchar los cambios de conectividad de red usando `Connectivity Plus`.
* **RF-SYNC-04 (Worker de Sincronización)**: Un servicio en segundo plano debe procesar la cola secuencialmente en orden FIFO. Al recuperar red, enviará los registros pendientes.
* **RF-SYNC-05 (Reintentos Exponenciales)**: En caso de error de red (ej. HTTP 503), el worker debe esperar intervalos crecientes (ej. 5s, 15s, 30s, 60s) antes de reintentar la sincronización del registro fallido.
