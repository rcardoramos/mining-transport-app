# Análisis e Integración de APIs (Postman Collection)

Este documento contiene el análisis de la colección de APIs de Postman en **.NET Framework 4.7.2** para el sistema de control de transporte de **Buses Miski Mayo**. Servirá como guía técnica para las siguientes fases de desarrollo.

---

## 1. Configuración de Variables Globales (Postman)

*   `baseUrl`: URL base del servidor backend (Ej. `https://localhost:44393` o servidor de pruebas/producción).
*   `usuario`: Identificador del chofer logueado (Ej. `pbeltran`).
*   `pass`: Contraseña del chofer.
*   `token`: Token JWT temporal de sesión (se obtiene en el Login y se inyecta en las peticiones subsiguientes).
*   `viajeId`: Identificador incremental del viaje en curso (obtenido tras la apertura de viaje).

---

## 2. Inventario de Endpoints y Mapeo Lógico

### A. Módulo de Autenticación
#### `POST /api/Auth/Login`
*   **Request Body**:
    ```json
    {
      "usuario": "{{usuario}}",
      "pass": "{{pass}}",
      "deviceUid": "DEV-0042",
      "modelo": "Samsung A54",
      "lat": -5.194490,
      "lng": -80.632820
    }
    ```
*   **Comportamiento**: Autentica al chofer, guarda telemetría básica del terminal y devuelve el Token de sesión (`json.Data.Token`).
*   **Mapeo en APP**: [login_form.dart](file:///c:/Users/RICARDO%20Ramos/OneDrive/Escritorio/mining-transport-app/lib/features/auth/presentation/widgets/login_form.dart) y `AuthRepository`.

---

### B. Módulo de Catálogos (Carga Offline / SQLite)
Estas APIs permiten descargar los maestros de datos locales para el correcto funcionamiento en zonas sin cobertura de internet (Modo Offline).
*   **`POST /api/Catalogo/Bootstrap`**: Descarga agregada de todos los catálogos en una sola petición HTTP.
*   **`POST /api/Catalogo/Rutas`**: Descarga de rutas y tramos configurados.
*   **`POST /api/Catalogo/Servicios`**: Descarga de tipos de servicios de buses.
*   **`POST /api/Catalogo/Horarios`**: Descarga de turnos y franjas horarias.
*   **`POST /api/Catalogo/Paraderos`**: Descarga de paraderos físicos con geolocalización.
*   **`POST /api/Catalogo/Buses`**: Descarga de flota vehicular habilitada.
*   **Mapeo en APP**: Alimentará el `SyncProvider` de SQLite/Drift para persistencia local.

---

### C. Módulo de Gestión de Viajes
#### `POST /api/Viaje/Aperturar`
*   **Request Body**:
    ```json
    {
      "usuario": "{{usuario}}",
      "token": "{{token}}",
      "uidCliente": "11111111-1111-1111-1111-111111111111",
      "rutaId": 1,
      "servicioId": 1,
      "horarioId": 1,
      "busId": 1,
      "fechaServicio": "2026-06-22",
      "deviceUid": "DEV-0042"
    }
    ```
*   **Comportamiento**: Inicializa un viaje en el servidor y retorna el `ViajeId` único.
*   **Mapeo en APP**: Acción "Aperturar Viaje" en la tarjeta de viaje en el Dashboard principal.

#### `POST /api/Viaje/Obtener`
*   **Comportamiento**: Consulta el estado en tiempo real del aforo del viaje (`viajeId`).
*   **Mapeo en APP**: Indicador visual de progreso de ocupación en la tarjeta de viaje en curso.

#### `POST /api/Viaje/Historial`
*   **Comportamiento**: Retorna el historial de viajes realizados por el chofer para alimentar estadísticas.
*   **Mapeo en APP**: Vista de turnos e historial en la sección Perfil.

#### `POST /api/Viaje/Manifiesto`
*   **Comportamiento**: Retorna los datos de los pasajeros embarcados en el viaje actual.
*   **Mapeo en APP**: Vista detallada de pasajeros en [manifest_detail_view.dart](file:///c:/Users/RICARDO%20Ramos/OneDrive/Escritorio/mining-transport-app/lib/features/home/presentation/pages/manifest_detail_view.dart).

#### `POST /api/Viaje/Cerrar`
*   **Comportamiento**: Finaliza el viaje y bloquea nuevos registros de pasajeros.
*   **Mapeo en APP**: Botón de cierre de viaje y confirmación GPS en el simulador o fin de ruta.

---

### D. Módulo de Registro y Validación de Pasajeros
#### `POST /api/Pasajero/Validar`
*   **Comportamiento**: Valida en el backend el estado laboral de un colaborador (DNI/código) devolviendo si está apto (ej. no cesado, no con descanso médico).
*   **Mapeo en APP**: Flujo de escaneo QR de la cámara o ingreso manual en la pantalla de Embarque.

#### `POST /api/Pasajero/ResolverParadero`
*   **Comportamiento**: Envía lat/lng del GPS y devuelve cuál es el paradero físico más cercano correspondiente a la ruta.
*   **Mapeo en APP**: Resuelve automáticamente el paradero actual del bus en segundo plano.

#### `POST /api/Pasajero/Registrar`
*   **Comportamiento**: Registra oficialmente el abordaje de un colaborador regular de *Miski Mayo*.
*   **Mapeo en APP**: Almacenamiento en cola de sincronización o envío directo a la API en el embarque.

#### `POST /api/Pasajero/RegistrarVisita`
*   **Comportamiento**: Registra el abordaje de un visitante externo con datos extendidos (motivo de visita, supervisor que autorizó).
*   **Mapeo en APP**: Flujo de abordaje de visitas externas.

#### `POST /api/Pasajero/Lista`
*   **Comportamiento**: Obtiene los pasajeros a bordo filtrados por texto o tipo de estatus.
*   **Mapeo en APP**: Buscador de pasajeros en la pantalla de embarque.

---

## 3. Próximos Pasos para la Integración

1.  **Capa de Datos**:
    *   Crear modelos request/response en Dart que coincidan exactamente con la estructura de la colección (usando `json_serializable`).
    *   Implementar clientes HTTP (`Dio` o `HttpClient`) configurando interceptores para inyectar automáticamente el `token` guardado en la memoria segura del dispositivo (`flutter_secure_storage`).
2.  **Sincronización Offline**:
    *   Configurar Drift (SQLite) para encolar las llamadas fallidas por conectividad a `POST /api/Pasajero/Registrar` y `POST /api/Pasajero/RegistrarVisita`.
    *   Consumir secuencialmente esta cola cuando el `connectivity_plus` cambie a estado conectado.
