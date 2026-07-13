# Estado del Proyecto - APP Buses Miski Mayo

Este documento centraliza el estado actual del desarrollo de la aplicación **APP Buses - Miski Mayo**, detallando la arquitectura base, la base de datos local, la inyección de dependencias, la infraestructura de red, la navegación, y el avance general del proyecto.

---

## 📋 Resumen Ejecutivo
La aplicación está diseñada bajo el patrón de **Clean Architecture Estricto** (separado en capas de `domain`, `data` y `presentation` para cada característica) combinado con **MVVM + Riverpod** para la gestión de estados e interactores UI. Además, implementa un enfoque **Offline-First**, donde todas las escrituras se realizan primero en la base de datos local ([drift](https://pub.dev/packages/drift)) y se encolan en una cola de sincronización secuencial (`SyncQueue`) para su posterior sincronización con el servidor remoto.

El proyecto incorpora un **Sistema de Diseño Corporativo** unificado, soporte completo para **Autenticación Online/Offline**, registro y validación en tiempo real de colaboradores y visitas, control de aforo, geolocalización de paraderos, generación de manifiestos y una cola de sincronización asíncrona visible en un banner de conectividad dinámico.

---

## 🏗️ Estado del Roadmap de Implementación

Actualmente, **todas las fases principales han sido implementadas** en su lógica de negocio de cliente y simuladores funcionales en el frontend, completamente cubiertas por pruebas automatizadas:

| Fase | Descripción | Estado | Detalle |
| :--- | :--- | :--- | :--- |
| **Fase 1** | **Arquitectura Base** | 🟢 **Completado** | Estructuración inicial, configuración de base de datos local Drift, contenedor de dependencias (`GetIt`), cliente Dio configurado con interceptores, sistema de rutas base (`GoRouter`) y utilitarios principales. |
| **Fase 2** | **Autenticación (Auth)** | 🟢 **Completado** | Flujo de login online y offline, validación de credenciales locales y PIN, almacenamiento encriptado de tokens y sesión persistente (`SecureStorage`), redirecciones reactivas. |
| **Fase 3** | **Gestión de Viajes (Trip)** | 🟢 **Completado** | Visualización de viajes pendientes y del día actual en el Dashboard del conductor. Control de estados de viajes ("Programado", "En viaje", "Finalizado"), captura de kilometraje (odómetro inicial/final) con diálogos de confirmación y firmas lógicas de cierre. |
| **Fase 4** | **Captura de Pasajeros** | 🟢 **Completado** | Interfaz para escaneo y registro manual de código de barras/DNI/Fotocheck en la vista de Embarque (`BoardingView`). Soporte para simulación de lectura. |
| **Fase 5** | **Validación Laboral** | 🟢 **Completado** | Evaluación local de reglas críticas del colaborador: vigencia de examen médico (EMO), inducción de seguridad anual aprobada, y ausencia de bloqueos administrativos. Alertas visuales destacadas (amarillo/rojo) en caso de discrepancia. |
| **Fase 6** | **Geolocalización (GPS)** | 🟢 **Completado** | Control geolocalizado de paraderos de abordaje autorizados en tránsito. Permite abordar solo en rango del paradero activo con indicador interactivo de GPS y fallback para rutas tradicionales sin paraderos. |
| **Fase 7** | **Control de Aforo** | 🟢 **Completado** | Contador visual dinámico de aforo a bordo en tiempo real, bloqueos y alertas cuando se excede la capacidad máxima del bus, y validación contra registros duplicados. |
| **Fase 8** | **Emisión de Manifiestos** | 🟢 **Completado** | Visualización detallada del manifiesto de pasajeros del viaje actual en la pestaña "Manifiestos" o "Historial", mostrando la información del viaje, conductor y listado de colaboradores a bordo. |
| **Fase 9** | **Sincronización en Background** | 🟢 **Completado** | Cola de sincronización local FIFO. Incorpora un banner reactivo de conectividad (`ConnectivityBar`) que monitoriza el estado de la red y el conteo de registros locales pendientes de envío. |
| **Fase 10** | **Reportes y Auditoría** | 🟢 **Completado** | Historial de auditoría local en base de datos. Pestaña de perfil del conductor que detalla sus estadísticas acumuladas (viajes, pasajeros) y un calendario semanal interactivo. |

---

## 📂 Estructura del Código Fuente y Archivos Creados

### 🌟 Archivo Principal
* [main.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/main.dart): Punto de entrada. Inicializa enlaces de Flutter, configura variables de entorno, carga dependencias en el localizador y levanta la app envuelta en `ProviderScope` con enrutamiento reactivo de `GoRouter`.

### 🔌 Componentes Base e Infraestructura (`lib/core/`)

1. **Configuración de Entorno**
   * [env_config.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/constants/env_config.dart): Modela la configuración de red y timeouts según el entorno activo (`dev`, `staging` o `prod`).

2. **Base de Datos Local (Offline Engine)**
   * [app_database.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/database/app_database.dart): Definición relacional de SQLite administrada por Drift. Cuenta con tablas para usuarios, conductores, buses, rutas, servicios, paraderos, viajes, pasajeros, registros de abordaje, cola de sincronización y logs de auditoría.

3. **Inyección de Dependencias**
   * [injection_container.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/di/injection_container.dart): Inicializa y expone el contenedor de dependencias global utilizando [get_it](https://pub.dev/packages/get_it).

4. **Cliente de Red HTTP**
   * [dio_client.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/network/dio_client.dart): Cliente `Dio` configurado con interceptores para inyección automática de tokens JWT (`_AuthInterceptor`) y auditoría detallada en logs de depuración (`_LoggingInterceptor`).

5. **Navegación y Enrutamiento**
   * [app_router.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/router/app_router.dart): Define la navegación principal y de sub-vistas con redirección reactiva asociada al estado de inicio de sesión:
     - `/`: Vista de carga inicial (`SplashView`).
     - `/login`: Formulario de acceso (`LoginView`).
     - `/dashboard`: Panel central (`HomeView`), con sub-rutas `/dashboard/boarding/:tripId` y `/dashboard/manifest/:tripId`.
     - `/design-system-preview`: Catálogo interactivo de componentes visuales.

6. **Almacenamiento Seguro**
   * [secure_storage.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/storage/secure_storage.dart): Wrapper de `FlutterSecureStorage` para resguardar tokens JWT y credenciales locales de usuario de forma cifrada.

7. **Estilo y Temas Visuales**
   * [app_theme.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/theme/app_theme.dart): Centraliza la configuración de temas del sistema (Light y Dark).

8. **Utilitarios del Sistema**
   * [logger.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/utils/logger.dart): Logger personalizado para la app.
   * [result.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/utils/result.dart): Encapsula retornos exitosos o fallas del negocio (`Failure` y sus subclases).
   * [date_formatter.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/utils/date_formatter.dart): Formateador estandarizado de fechas y horas del sistema.
   * [sync_provider.dart](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/lib/core/utils/sync_provider.dart): Proveedor reactivo de sincronización y conteo de cola local.

### 🎨 Componentes Compartidos (`lib/shared/`)

1. **Sistema de Diseño (`lib/shared/design_system/`)**
   * Define tokens consistentes de colores (`design_colors.dart`), elevación (`design_elevation.dart`), bordes (`design_radius.dart`), espaciados (`design_spacing.dart`), tipografías (`design_typography.dart`) y animaciones de UI (`design_animations.dart`).
   * Contiene widgets personalizados corporativos:
     - `DesignButton` (botones de acción principal, secundaria y contorno).
     - `DesignCard` (tarjetas elevadas y de borde suave para UI de viajes y estados).
     - `DesignInputField` (inputs estilizados de texto y password con validaciones visuales).
     - `DesignBottomNavigation` (barra de navegación inferior personalizada con transiciones de color de acento).
     - `DesignFeedback` (banners de error, carga e indicadores de estado).

### 🚀 Características de Negocio (`lib/features/`)

1. **Módulo de Autenticación (`lib/features/auth/`)**
   * Proporciona la lógica de inicio de sesión online/offline y persistencia de sesión:
     - `data/`: Implementación de repositorios y datasources de red/locales (`AuthLocalDataSource`, `AuthRemoteDataSource`).
     - `domain/`: Casos de uso (`LoginUseCase`, `LogoutUseCase`, `CheckSessionUseCase`, `GetCurrentUserUseCase`).
     - `presentation/`: Vistas de login, splash, catálogo de componentes y modelo de vista reactivo (`LoginViewModel`).

2. **Módulo de Dashboard y Embarque (`lib/features/home/`)**
   * Orquesta la interfaz de usuario diaria del conductor:
     - `domain/`: Casos de uso de carga de datos (`GetDashboardSummaryUseCase`, `GetDriverInfoUseCase`, `RegisterPassengerUseCase`, `CheckCollaboratorUseCase`).
     - `presentation/`:
       - `HomeView`: Panel principal estructurado en 4 secciones o pestañas principales: **Inicio** (Resumen de aforo global, estado de la cola y botón de sincronizar), **Viajes** (Listado de viajes asignados pendientes y completados con odómetro), **Manifiestos** (Acceso a las listas de pasajeros de viajes del día) y **Perfil** (Información del conductor, calendario interactivo de la semana).
       - `BoardingView`: Interfaz de control de embarque. Gestiona la cámara de escaneo (simulada), la entrada manual de DNI, la verificación de reglas de negocio en base de datos local y el control de cupo máximo.
       - `ManifestDetailView`: Detalle del manifiesto con buscador integrado de pasajeros y reporte de viaje.

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

Consulte los siguientes documentos de especificación técnica y de arquitectura para detalles adicionales:

### Guías de Diseño e Integración
* **Análisis de APIs e Integración**: [analisis_apis.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/analisis_apis.md)
* **Sistema de Diseño Visual**: [design-system.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/design-system.md)
* **Reglas de Embarque y Pasajeros Externos**: [seguimiento_reglas.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/seguimiento_reglas.md)
* **Contexto Técnico Principal**: [project-context.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/project-context.md)

### Arquitectura
* **Clean Architecture**: [clean-architecture.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/clean-architecture.md)
* **Contrato de APIs**: [api-contracts.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/api-contracts.md)
* **Diseño de Base de Datos**: [database-design.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/database-design.md)
* **Modelo de Dominio**: [domain-model.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/domain-model.md)
* **Estrategia Offline-First**: [offline-first.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/offline-first.md)
* **Estrategia de Sincronización**: [sync-strategy.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/sync-strategy.md)
* **Estrategia de Testing**: [testing-strategy.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/testing-strategy.md)

### Requerimientos de Producto
* **Criterios de Aceptación**: [acceptance-criteria.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/acceptance-criteria.md)
* **Reglas de Negocio**: [business-rules.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/business-rules.md)
* **Requerimientos Funcionales**: [functional-requirements.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/functional-requirements.md)
* **Resumen del Proyecto**: [project-overview.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/project-overview.md)
* **Matriz de Trazabilidad**: [traceability-matrix.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/traceability-matrix.md)
* **Casos de Uso**: [use-cases.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/use-cases.md)
* **Flujos de Usuario**: [user-flows.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/user-flows.md)

### Decisiones de Arquitectura (ADR)
* **Base de Datos Local**: [0001-choice-of-local-database.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/adr/0001-choice-of-local-database.md)
* **Gestor de Estado**: [0002-choice-of-state-manager.md](file:///c:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/adr/0002-choice-of-state-manager.md)
