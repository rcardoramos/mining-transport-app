# Contexto del Proyecto y Reglas del Asistente (AI Project Context)

Este documento sirve como la fuente de verdad del contexto del proyecto para cualquier asistente de desarrollo basado en Inteligencia Artificial (IA) en el entorno de desarrollo.

---

## 1. Reglas Generales de Comportamiento para la IA
Cuando generes o modifiques archivos de código o arquitectura en este proyecto, **debes cumplir estrictamente con las siguientes directrices**:

* **Clean Architecture Estricto**: Todo código debe dividirse en `domain` (lógica de negocio pura), `data` (implementación e infraestructura) y `presentation` (UI y control de vista).
* **MVVM + Riverpod**: Los ViewModels deben implementarse como `StateNotifier` o `Notifier` de Riverpod. Los Widgets leen el estado inmutable (`State`) y no deben manejar lógica de negocio.
* **Offline First**: Las escrituras de la aplicación siempre se realizan primero en la base de datos local (Drift). Todas las peticiones HTTP se colocan en `SyncQueue` para envío asíncrono secundario.
* **Procesamiento FIFO**: La cola de sincronización debe procesar tareas secuencialmente en orden de inserción.
* **Inmutabilidad**: Utiliza `freezed` para definir entidades del dominio y estados de los ViewModels.
* **Result Pattern**: Los repositorios y casos de uso retornan un tipo `Result<S, F>` en lugar de lanzar excepciones no controladas.
* **Uso de Enlaces en Documentos**: Al hacer referencia a archivos de código fuente, genera enlaces cliqueables utilizando el esquema `file:///`.

---

## 2. Estructura del Directorio de Trabajo

```
lib/
├── core/                   # Componentes globales e infraestructura base
│   ├── database/           # Conectividad local Drift y migraciones
│   ├── network/            # Cliente Dio, interceptores de seguridad
│   ├── storage/            # Flutter Secure Storage e inyección base
│   ├── sync/               # SyncManager, SyncQueue y SyncWorker
│   ├── scanner/            # Control de escaneo nativo
│   ├── gps/                # Integración con Geolocator
│   ├── pdf/                # Generador de Manifiestos PDF
│   ├── constants/          # Constantes globales de la app
│   └── utils/              # Clases de soporte genéricas
│
├── features/               # Módulos del negocio estructurados Feature-First
│   ├── auth/               # Autenticación online/offline
│   ├── trip/               # Apertura, historial y cierre de viajes
│   ├── passenger/          # Escaneo y captura de pasajeros
│   ├── validation/         # Reglas de validación laboral (EMO, seguridad)
│   ├── geolocation/        # Registro de paraderos y auditoría GPS
│   ├── occupancy/          # Control de aforo en tiempo real
│   ├── manifest/           # Visualización e impresión de PDF
│   └── sync/               # Monitor de sincronización y estado de cola
│
├── shared/                 # Componentes compartidos reutilizables
│   ├── widgets/            # Elementos visuales comunes de UI (alertas, botones)
│   ├── models/             # Modelos de datos compartidos
│   └── extensions/         # Extensiones útiles sobre clases base
```

---

## 3. Stack Tecnológico Principal
* **Core**: Flutter Web/Mobile.
* **Gestión de Estado**: `flutter_riverpod` (v2.x).
* **Base de Datos Local**: `drift` / `drift_dev` (SQLite relacional).
* **Comunicación HTTP**: `dio` (con interceptores para reintentos y tokens).
* **Inyección de Dependencias**: `get_it`.
* **Modelos Inmutables**: `freezed` y `json_serializable`.
* **Seguridad**: `flutter_secure_storage` para tokens JWT e identificadores cifrados.
* **Hardware & Sensores**: `mobile_scanner` (Cámara) y `geolocator` (GPS).
* **Reportes**: `pdf` y `printing` para ticketera Bluetooth/Wi-Fi.

---

## 4. Comandos de Compilación y Generación de Código
* **Generar código Freezed/Drift**:
  `dart run build_runner build --delete-conflicting-outputs`
* **Ejecutar Pruebas Unitarias**:
  `flutter test`
* **Ejecutar Analizador de Código**:
  `flutter analyze`

---

## 5. Roadmap de Implementación Recomendado

El desarrollo del sistema se llevará a cabo de forma incremental y ordenada en 10 fases clave:

1. **Fase 1: Arquitectura Base**
   - Configuración inicial de Flutter, dependencias (`pubspec.yaml`).
   - Inicialización del motor local Drift (`AppDatabase`), inyectores `GetIt` y clientes `Dio`.
2. **Fase 2: Autenticación (Auth)**
   - Login contra backend e inicio de sesión local (Secure Storage + PIN).
3. **Fase 3: Gestión de Viajes (Trip)**
   - Flujos de apertura, listado activo, kilometraje y cierre de viaje con captura de firmas.
4. **Fase 4: Captura de Pasajeros (Passenger)**
   - Integración de la cámara (`mobile_scanner`) para decodificación de DNI y lectura de fotocheck.
5. **Fase 5: Validación Laboral (Validation)**
   - Lógica en local de verificación de EMO, inducción anual y bloqueos de seguridad.
6. **Fase 6: Geolocalización (GPS)**
   - Geofencing de paraderos, cálculo de proximidad y captura de coordenadas de auditoría.
7. **Fase 7: Control de Aforo (Occupancy)**
   - Limitador visual y alertas por sobreaforo de pasajeros.
8. **Fase 8: Emisión de Manifiestos (PDF & Print)**
   - Generación de archivos PDF conforme a normativas e impresión Bluetooth/Wi-Fi en ticketera.
9. **Fase 9: Sincronización en Background (Sync)**
   - Sincronización asíncrona de la cola persistente (`SyncQueue`) y resolución de conflictos.
10. **Fase 10: Reportes y Auditoría**
    - Bitácora local de auditoría y reportes del estado de viajes y sincronizaciones.

