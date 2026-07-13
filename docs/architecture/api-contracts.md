# Contratos de API: Integración con Backend (.NET Framework)

Este documento define las especificaciones del contrato de API REST (RPC-style) para la comunicación entre la aplicación móvil y el backend corporativo en .NET. 

Todas las peticiones (a excepción del Login) viajan por el método **POST**, y la autenticación se valida pasando las claves `usuario` y `token` directamente en el cuerpo del JSON de la solicitud en lugar de usar cabeceras HTTP estándar.

---

## 1. Estructura de Respuesta Estándar (.NET Wrapper)

Todas las respuestas del backend siguen el patrón de envoltura corporativa:

```json
{
  "Success": true,
  "Message": "Mensaje informativo o de error descriptivo",
  "Data": { ... } // Objeto o arreglo con la información solicitada
}
```

---

## 2. Inventario de Endpoints

### 2.1 Módulo de Autenticación

#### `POST /api/Auth/Login`
Autentica al chofer y registra la información técnica del dispositivo.

* **Request Body**:
```json
{
  "usuario": "pbeltran",
  "pass": "TU_PASSWORD",
  "deviceUid": "DEV-0042",
  "modelo": "Samsung A54",
  "lat": -5.194490,
  "lng": -80.632820
}
```

* **Response Body (200 OK)**:
```json
{
  "Success": true,
  "Message": "Login exitoso",
  "Data": {
    "Token": "jwt_token_generado_por_el_servidor_aqui...",
    "User": {
      "id": "DRV-998",
      "username": "pbeltran",
      "fullName": "Pedro Beltrán",
      "role": "DRIVER"
    }
  }
}
```

---

### 2.2 Módulo de Catálogos (Sincronización para Operación Offline)

#### `POST /api/Catalogo/Bootstrap`
Descarga de manera agrupada todos los maestros necesarios para la persistencia local de SQLite (Drift).

* **Request Body**:
```json
{
  "usuario": "pbeltran",
  "token": "jwt_token_de_sesion"
}
```

* **Response Body (200 OK)**:
```json
{
  "Success": true,
  "Message": "Carga de catálogos completada",
  "Data": {
    "Rutas": [
      { "id": 1, "nombre": "Ruta Piura - Mina Miski Mayo", "distanciaKm": 120.5 }
    ],
    "Servicios": [
      { "id": 1, "nombre": "Servicio de Personal de Guardia" }
    ],
    "Horarios": [
      { "id": 1, "horaSalida": "06:00:00" }
    ],
    "Buses": [
      { "id": 1, "placa": "F5T-980", "capacidad": 44, "modelo": "Mercedes Benz" }
    ],
    "Paraderos": [
      {
        "id": 1,
        "nombre": "Óvalo Grau (Piura)",
        "latitud": -5.194490,
        "longitud": -80.632820,
        "radioPermitido": 50.0, // Radio en metros para permitir el abordaje
        "orden": 1 // Secuencia en la ruta
      }
    ]
  }
}
```

*(Nota: También se exponen los endpoints específicos `POST /api/Catalogo/Rutas`, `POST /api/Catalogo/Servicios`, `POST /api/Catalogo/Horarios`, `POST /api/Catalogo/Paraderos` y `POST /api/Catalogo/Buses` con la misma estructura de request y response según sea requerido).*

---

### 2.3 Módulo de Gestión de Viajes

#### `POST /api/Viaje/Aperturar`
Crea un registro de viaje activo para el chofer y el vehículo.

* **Request Body**:
```json
{
  "usuario": "pbeltran",
  "token": "jwt_token_de_sesion",
  "uidCliente": "11111111-1111-1111-1111-111111111111",
  "rutaId": 1,
  "servicioId": 1,
  "horarioId": 1,
  "busId": 1,
  "fechaServicio": "2026-06-22",
  "deviceUid": "DEV-0042"
}
```

* **Response Body (200 OK)**:
```json
{
  "Success": true,
  "Message": "Viaje aperturado exitosamente",
  "Data": {
    "ViajeId": 128
  }
}
```

#### `POST /api/Viaje/Obtener`
Consulta el estado actual, pasajeros a bordo y la lista de paraderos autorizados específicos del viaje.

* **Request Body**:
```json
{
  "usuario": "pbeltran",
  "token": "jwt_token_de_sesion",
  "viajeId": 128
}
```

* **Response Body (200 OK)**:
```json
{
  "Success": true,
  "Message": "Detalle de viaje obtenido",
  "Data": {
    "ViajeId": 128,
    "AforoActual": 24,
    "CapacidadMax": 44,
    "Estado": "IN_PROGRESS",
    "ParaderosAutorizados": [
      {
        "id": 1,
        "nombre": "Óvalo Grau",
        "latitud": -5.194490,
        "longitud": -80.632820,
        "radioPermitido": 50.0,
        "orden": 1
      },
      {
        "id": 2,
        "nombre": "Catacaos",
        "latitud": -5.265000,
        "longitud": -80.678000,
        "radioPermitido": 30.0,
        "orden": 2
      }
    ]
  }
}
```

#### `POST /api/Viaje/Historial`
Retorna el historial de viajes realizados por el conductor logueado.

* **Request Body**:
```json
{
  "usuario": "pbeltran",
  "token": "jwt_token_de_sesion",
  "estado": "COMPLETED", // Filtrar por estado (opcional)
  "desde": "2026-06-01T00:00:00Z", // Opcional
  "hasta": "2026-06-30T23:59:59Z" // Opcional
}
```

#### `POST /api/Viaje/Cerrar`
Cierra el viaje activo y bloquea el aforo.

* **Request Body**:
```json
{
  "usuario": "pbeltran",
  "token": "jwt_token_de_sesion",
  "viajeId": 128,
  "paraderoCierreId": 4,
  "lat": -5.833000,
  "lng": -81.050000
}
```

---

### 2.4 Módulo de Pasajeros y Validaciones (Embarque)

#### `POST /api/Pasajero/Validar`
Consulta el estado de aptitud médica e inducciones de un colaborador (DNI/Fotocheck).

* **Request Body**:
```json
{
  "usuario": "pbeltran",
  "token": "jwt_token_de_sesion",
  "dni": "44556677",
  "codigo": null // Se puede enviar código de fotocheck o DNI
}
```

* **Response Body (200 OK - Autorizado)**:
```json
{
  "Success": true,
  "Message": "Colaborador apto",
  "Data": {
    "Dni": "44556677",
    "NombreCompleto": "Juan Pérez Gómez",
    "Empresa": "MISKI MAYO",
    "EstadoLaboral": "OK", // OK, VACACIONES, CESADO, LICENCIA, DESCANSO_MEDICO
    "AptoParaAbordar": true
  }
}
```

* **Response Body (200 OK - No Autorizado/Excepción)**:
```json
{
  "Success": true,
  "Message": "Colaborador de vacaciones",
  "Data": {
    "Dni": "44556677",
    "NombreCompleto": "Juan Pérez Gómez",
    "Empresa": "MISKI MAYO",
    "EstadoLaboral": "VACACIONES",
    "AptoParaAbordar": false // Activa alerta sonora en la app
  }
}
```

#### `POST /api/Pasajero/ResolverParadero`
Resuelve cuál es el paradero autorizado de la ruta más cercano a la ubicación GPS actual del bus.

* **Request Body**:
```json
{
  "usuario": "pbeltran",
  "token": "jwt_token_de_sesion",
  "lat": -5.265000,
  "lng": -80.678000
}
```

* **Response Body (200 OK)**:
```json
{
  "Success": true,
  "Message": "Paradero resuelto",
  "Data": {
    "ParaderoId": 2,
    "Nombre": "Catacaos",
    "DistanciaMetros": 12.5
  }
}
```

#### `POST /api/Pasajero/Registrar`
Registra el abordaje oficial de un colaborador regular de Miski Mayo.

* **Request Body**:
```json
{
  "usuario": "pbeltran",
  "token": "jwt_token_de_sesion",
  "viajeId": 128,
  "uidCliente": "22222222-2222-2222-2222-222222222222",
  "codigoUnico": "EMP-9081",
  "dni": "44556677",
  "nombreCompleto": "Juan Pérez Gómez",
  "empresa": "MISKI MAYO",
  "puesto": "Operario de Planta",
  "unidad": "Fosfatos",
  "tipoPasajero": "MISKI_MAYO", // MISKI_MAYO, VISITA
  "estadoLaboral": "OK",
  "resultado": "ABORDO", // ABORDO, RECHAZADO, EXCEPCION
  "observacion": null,
  "paraderoId": 1,
  "lugarSubida": "Óvalo Grau",
  "lat": -5.194490,
  "lng": -80.632820
}
```

#### `POST /api/Pasajero/RegistrarVisita`
Registra el abordaje de una visita externa o contratista con justificaciones y autorizaciones.

* **Request Body**:
```json
{
  "usuario": "pbeltran",
  "token": "jwt_token_de_sesion",
  "viajeId": 128,
  "uidCliente": "33333333-3333-3333-3333-333333333333",
  "dni": "99887766",
  "nombreCompleto": "VISITANTE EXTERNO SAC",
  "empresa": "Terceros Metalmecánica",
  "tipoPasajero": "VISITA",
  "estadoLaboral": "NO_REGISTRADO",
  "resultado": "ABORDO_CON_OBS",
  "observacion": "Ingreso autorizado para inspección de seguridad",
  "lugarSubida": "Catacaos",
  "lat": -5.265000,
  "lng": -80.678000,
  "motivoVisita": "Inspección técnica de mantenimiento",
  "autorizadoPor": "Supervisor Juan Alva"
}
```

#### `POST /api/Pasajero/Lista`
Obtiene la lista de pasajeros actualmente abordados en el viaje para visualización del chofer.

* **Request Body**:
```json
{
  "usuario": "pbeltran",
  "token": "jwt_token_de_sesion",
  "viajeId": 128,
  "buscar": null, // Cadena de búsqueda (nombre o DNI)
  "filtro": "TODOS" // TODOS, COLABORADORES, VISITAS
}
```
