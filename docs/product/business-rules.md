# Reglas de Negocio: APP Buses (Miski Mayo)

Este documento contiene las reglas de negocio imperativas que rigen el comportamiento de la aplicación de transporte minero.

## 1. Validación Laboral (RN-VAL-01)
* **RN-VAL-01-01 (Estado del Trabajador)**: Solo se permite el abordaje de personal con estado laboral "Activo" en el sistema ADRYAN.
* **RN-VAL-01-02 (Examen Médico)**: El trabajador debe contar con su Examen Médico Ocupacional (EMO) vigente. Si el EMO está vencido, el sistema debe bloquear el abordaje.
* **RN-VAL-01-03 (Inducción de Seguridad)**: El trabajador debe tener la inducción de seguridad vigente (vence anualmente). Si está vencida, el abordaje se bloqueará con una alerta visual roja y un sonido de error característico.
* **RN-VAL-01-04 (Bloqueos de Seguridad)**: Si un trabajador tiene una restricción activa por motivos de seguridad o disciplina, se impedirá el abordaje.

## 2. Control de Aforo (RN-AFO-02)
* **RN-AFO-02-01 (Capacidad Máxima)**: Ningún viaje puede tener más pasajeros registrados que la capacidad física establecida en el registro del Bus (`Bus.capacity`).
* **RN-AFO-02-02 (Bloqueo por Límite)**: Al alcanzar el aforo máximo, cualquier intento de escaneo o registro manual adicional debe ser rechazado inmediatamente con una alerta de "Aforo Completo" y sonido de bloqueo.

## 3. Integridad del Embarque (RN-EMB-03)
* **RN-EMB-03-01 (Doble Embarque)**: Un pasajero no puede estar registrado en dos viajes simultáneamente activos en el mismo día. Si se escanea un DNI que ya se encuentra en estado "Abordado" en un viaje en curso, el sistema lanzará la alerta "Pasajero ya registrado".
* **RN-EMB-03-02 (Registro Histórico Inmutable)**: Todo registro de abordaje (`BoardingRecord`) es histórico. No se eliminan físicamente registros del dispositivo; en su lugar, se registran eventos de cancelación (`status = 'Cancelled'`) con justificación y firma digital del supervisor si aplica.

## 4. Geolocalización y Paraderos (RN-GEO-04)
* **RN-GEO-04-01 (Geofencing de Paraderos)**: Al realizar un abordaje, se debe capturar la coordenada GPS del dispositivo móvil. Si el dispositivo se encuentra a más de 100 metros del paradero seleccionado (`BusStop`), el sistema debe alertar al operador (pero permitir forzar el registro con justificación escrita para no detener la operación).
* **RN-GEO-04-02 (Precisión GPS)**: No se registrará una coordenada GPS que tenga una precisión (accuracy) peor a 30 metros. Si la señal es deficiente, la aplicación debe alertar al operador y reintentar la obtención de la geolocalización.

## 5. Gestión del Viaje (RN-TRIP-05)
* **RN-TRIP-05-01 (Apertura de Viaje)**: Para abrir un viaje, se requiere seleccionar obligatoriamente un Servicio, una Ruta, un Bus, un Conductor (`Driver`) y registrar el kilometraje inicial.
* **RN-TRIP-05-02 (Cierre de Viaje)**: El viaje solo puede ser cerrado por el operador/supervisor de despacho. Al cerrarse, el kilometraje final debe ser registrado y debe ser mayor al inicial.
* **RN-TRIP-05-03 (Inmutabilidad al Cierre)**: Una vez que el viaje se marca como cerrado (`status = 'Closed'`), no se admitirán nuevos abordajes ni modificaciones a los pasajeros del mismo.
* **RN-TRIP-05-04 (Generación de Manifiesto)**: La generación y firma digital del Manifiesto PDF solo estará disponible cuando el viaje se encuentre en estado "Cerrado" o "En Ruta".
