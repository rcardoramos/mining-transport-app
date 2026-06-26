# Estado del Proyecto - APP Buses Miski Mayo

Este documento centraliza el estado actual del desarrollo de la aplicación **APP Buses - Miski Mayo**, detallando la arquitectura base, la base de datos local, la inyección de dependencias, la infraestructura de red, la navegación, y el avance general del proyecto.

---

## 📋 Resumen Ejecutivo
La aplicación está diseñada bajo el patrón de **Clean Architecture Estricto** (separado en capas de `domain`, `data` y `presentation` para cada característica) combinado con **MVVM + Riverpod** para la gestión de estados e interactores UI. Además, implementa un enfoque **Offline-First**, donde todas las escrituras se realizan primero en la base de datos local ([drift](https://pub.dev/packages/drift)) y se encolan en una cola de sincronización secuencial (`SyncQueue`) para su posterior sincronización con el servidor remoto.

---

## 🏗️ Estado del Roadmap de Implementación

Actualmente el proyecto se encuentra en la **Fase 1 (Arquitectura Base)**. A continuación se muestra el progreso detallado de las fases planificadas:

| Fase | Descripción | Estado | Detalle |
| :--- | :--- | :--- | :--- |
| **Fase 1** | **Arquitectura Base** | 🟢 **Completado** | Estructuración inicial, configuración de base de datos local Drift, contenedor de dependencias (`GetIt`), cliente Dio configurado con interceptores, sistema de rutas base (`GoRouter`) y utilitarios principales. |
| **Fase 2** | **Autenticación (Auth)** | 🔴 **Pendiente** | Creación del flujo de login online/offline, validación de PIN local, y almacenamiento seguro de tokens. |
| **Fase 3** | **Gestión de Viajes (Trip)** | 🔴 **Pendiente** | Flujos de apertura, listado de viajes activos, kilometraje inicial/final y firmas de cierre. |
| **Fase 4** | **Captura de Pasajeros** | 🔴 **Pendiente** | Escaneo QR/Fotocheck/DNI con la cámara trasera utilizando `mobile_scanner`. |
| **Fase 5** | **Validación Laboral** | 🔴 **Pendiente** | Reglas locales de chequeo (EMO, inducción anual, bloqueos administrativos). |
| **Fase 6** | **Geolocalización (GPS)** | 🔴 **Pendiente** | Registro de paraderos, proximidad y geofencing con `geolocator`. |
| **Fase 7** | **Control de Aforo** | 🔴 **Pendiente** | Alertas visuales sobre aforo excedido en tiempo real. |
| **Fase 8** | **Emisión de Manifiestos** | 🔴 **Pendiente** | Generación de reportes PDF e impresión Bluetooth/Wi-Fi. |
| **Fase 9** | **Sincronización en Background** | 🔴 **Pendiente** | Procesador secuencial FIFO para el envío asíncrono de transacciones de la cola local. |
| **Fase 10** | **Reportes y Auditoría** | 🔴 **Pendiente** | Logs de auditoría local de la aplicación y vista de estadísticas. |

---

## 📂 Estructura del Código Fuente y Archivos Creados

Toda la base técnica inicial está implementada dentro de la carpeta `lib/core`. Las vistas y componentes de UI son stubs temporales a la espera de la implementación de cada feature de negocio.

### 🌟 Archivo Principal
* [main.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/main.dart): Punto de entrada de la aplicación. Inicializa los enlaces de Flutter, configura las variables de entorno para desarrollo por defecto, levanta el contenedor de dependencias, y renderiza la aplicación envuelta en un `ProviderScope` (Riverpod) usando `GoRouter` para navegación.

### 🔌 Componentes Base e Infraestructura (`lib/core/`)

1. **Configuración de Entorno**
   * [env_config.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/constants/env_config.dart): Modela la configuración de red y timeouts según el entorno activo (`dev`, `staging` o `prod`).
     * `dev`: `https://api-dev.miskimayo.pe/api/v1`
     * `staging`: `https://api-qa.miskimayo.pe/api/v1`
     * `prod`: `https://api.miskimayo.pe/api/v1`

2. **Base de Datos Local (Offline Engine)**
   * [app_database.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/database/app_database.dart): Define la estructura relacional de SQLite administrada por Drift. Cuenta con las siguientes tablas implementadas:
     * `Users`: Almacenamiento local de usuarios autenticados.
     * `Drivers`: Registro de conductores activos y estados de sus licencias.
     * `Buses`: Vehículos con sus capacidades y placas.
     * `Routes`: Rutas registradas con origen, destino y distancia.
     * `Services`: Tipos de servicio de transporte.
     * `BusStops`: Paraderos georreferenciados vinculados a rutas.
     * `Trips`: Viajes iniciados por el conductor.
     * `Passengers`: Empleados/Contratistas con vigencia de EMO e inducciones.
     * `BoardingRecords`: Marcaciones de subida (pasajero, viaje, paradero, tipo de escaneo, coordenadas y timestamp).
     * `SyncQueue`: Cola local FIFO para la sincronización diferida al servidor.
     * `AuditLogs`: Registro de auditoría local de la app.

3. **Inyección de Dependencias**
   * [injection_container.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/di/injection_container.dart): Inicializa y expone el contenedor de dependencias global utilizando [get_it](https://pub.dev/packages/get_it). Registra de forma perezosa (`LazySingleton`):
     * [AppLogger](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/utils/logger.dart)
     * [SecureStorage](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/storage/secure_storage.dart)
     * [AppDatabase](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/database/app_database.dart)
     * [DioClient](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/network/dio_client.dart)

4. **Cliente de Red HTTP**
   * [dio_client.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/network/dio_client.dart): Implementa un cliente `Dio` configurado con timeouts de 15 segundos y dos interceptores:
     * `_AuthInterceptor`: Adjunta automáticamente el token JWT almacenado en `SecureStorage` en la cabecera `Authorization: Bearer <token>`.
     * `_LoggingInterceptor`: Registra en consola las peticiones salientes, cuerpos enviados, respuestas de servidor y errores detallados de red.

5. **Navegación y Rutas**
   * [app_router.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/router/app_router.dart): Define la navegación con `GoRouter`. Contiene las siguientes rutas iniciales con vistas placeholder temporales para asegurar la compilación limpia del proyecto:
     * `/`: Redirecciona a la vista de carga inicial (`SplashView`).
     * `/login`: Pantalla de inicio de sesión (`LoginView`).
     * `/dashboard`: Panel principal (`DashboardView`).

6. **Almacenamiento Seguro**
   * [secure_storage.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/storage/secure_storage.dart): Wrapper de `FlutterSecureStorage`. Almacena de forma encriptada datos críticos como el Token JWT, el PIN local y el nombre de usuario recordado.

7. **Estilo y Temas Visuales**
   * [app_theme.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/theme/app_theme.dart): Centraliza el tema visual. Configura colores corporativos personalizados de Miski Mayo:
     * **Color Primario**: Teal Oscuro (`0xFF0F4C5C`)
     * **Color Secundario**: Naranja de Seguridad (`0xFFE36414`)
     * Soporta cambio de tema Light y Dark integrado siguiendo las directivas del sistema operativo.

8. **Utilitarios y Patrones Core**
   * [logger.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/utils/logger.dart): Adaptador de registro con PrettyPrinter que varía su detalle según estemos en modo depuración o producción.
   * [result.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/utils/result.dart): Define el **Result Pattern** para retornos seguros de operaciones sin lanzar excepciones inesperadas. Cuenta con subclases de `Failure`:
     * `NetworkFailure` (Errores de conectividad)
     * `ServerFailure` (Errores HTTP 500, etc.)
     * `DatabaseFailure` (Errores en almacenamiento local)
     * `CacheFailure` (Errores de almacenamiento de sesión)
     * `ValidationFailure` (Errores de validación de negocio)

---

## 🛠️ Stack Tecnológico en Detalle

La aplicación se apoya en las siguientes librerías de Flutter definidas en [pubspec.yaml](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/pubspec.yaml):

* **Gestión de Estado**: `flutter_riverpod` y `riverpod_annotation` para el manejo de estados inmutables reactivos.
* **Base de Datos Relacional Local**: `drift` junto con `sqlite3_flutter_libs` y `path_provider` para persistir la cola de sincronización y registros de manera relacional estructurada.
* **Comunicaciones HTTP**: `dio` para llamadas estructuradas con interceptores.
* **Inyección de Dependencias**: `get_it` como localizador de servicios base.
* **Seguridad**: `flutter_secure_storage` para encriptar a nivel de sistema operativo tokens y credenciales de usuario.
* **Sensores & Hardware**:
  * `mobile_scanner` para procesamiento de código de barras/DNI/Fotocheck.
  * `geolocator` para geofencing y auditoría de coordenadas en paraderos.
  * `connectivity_plus` para determinar la presencia de red de forma reactiva.
* **Reportes & Ticketera**: `pdf` y `printing` para la estructuración y envío a impresión de manifiestos.
* **Generación de Código**: `build_runner`, `drift_dev`, `freezed`, `json_serializable`, `riverpod_generator`.
* **Testing**: `mocktail` para mockeo flexible de clases e infraestructura en pruebas unitarias.

---

## ⚙️ Comandos de Desarrollo Frecuentes

Estos comandos se deben ejecutar desde la raíz del proyecto ([mining-transport-app](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app)):

* **Generar archivos autogenerados (Drift, Freezed, etc.)**:
  ```powershell
  dart run build_runner build --delete-conflicting-outputs
  ```
* **Mantener generación en segundo plano (Hot reload de generación)**:
  ```powershell
  dart run build_runner watch --delete-conflicting-outputs
  ```
* **Ejecutar pruebas unitarias**:
  ```powershell
  flutter test
  ```
* **Correr el analizador estático**:
  ```powershell
  flutter analyze
  ```

---

## 📖 Documentos de Referencia del Proyecto
Para detalles adicionales sobre el diseño y requerimientos, consulte los siguientes documentos de especificación técnica:
* **Contexto Técnico**: [project-context.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/project-context.md)
* **Diseño de Base de Datos**: [database-design.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/database-design.md)
* **Estrategia de Sincronización**: [sync-strategy.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/sync-strategy.md)
* **Requerimientos Funcionales**: [functional-requirements.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/functional-requirements.md)
* **Decisiones de Arquitectura**: [0001-choice-of-local-database.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/adr/0001-choice-of-local-database.md) y [0002-choice-of-state-manager.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/adr/0002-choice-of-state-manager.md)
