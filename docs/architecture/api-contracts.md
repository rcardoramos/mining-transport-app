# Contratos de API: Integración con ERP ADRYAN

Este documento define la interfaz de programación (REST API v1) para la comunicación entre la aplicación móvil "APP Buses" y el backend corporativo de ADRYAN.

---

## 1. Cabeceras Comunes (Headers)
* `Content-Type: application/json`
* `Accept: application/json`
* `Authorization: Bearer <JWT_TOKEN>` (Requerido para todos los endpoints excepto `/auth/login`)

---

## 2. Definición de Endpoints

### 2.1 POST /api/v1/auth/login
Inicia sesión de usuario y retorna el token de acceso.

* **Request**:
```json
{
  "username": "dispatcher_01",
  "password": "SecurePassword123"
}
```
* **Response (200 OK)**:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "a6b1c8d2-4321-9876-bcde-5f4e3d2c1b0a",
    "username": "dispatcher_01",
    "fullName": "Ricardo Ramos Julca",
    "role": "DISPATCHER"
  }
}
```
* **Errors**:
  * `401 Unauthorized`: Usuario o contraseña incorrectos.
  * `423 Locked`: Usuario bloqueado administrativamente.

---

### 2.2 GET /api/v1/sync/masters
Descarga el padrón maestro completo para la operación offline.

* **Query Parameters**:
  * `last_sync`: DateTime (ISO 8601, ej. `2026-06-10T12:00:00Z`). Permite descargas incrementales de maestros modificados desde la última fecha.
* **Response (200 OK)**:
```json
{
  "lastSyncTimestamp": "2026-06-10T19:00:00Z",
  "drivers": [
    {
      "id": "d1e2f3g4-5678-90ab-cdef-1234567890ab",
      "code": "COND-045",
      "fullName": "Carlos Mendoza",
      "licenseNumber": "Q-44556677",
      "licenseExpiration": "2028-12-31",
      "isActive": true
    }
  ],
  "buses": [
    {
      "id": "b1c2d3e4-5678-90ab-cdef-1234567890ab",
      "plateNumber": "F5T-980",
      "capacity": 44,
      "model": "Mercedes Benz",
      "isActive": true
    }
  ],
  "routes": [
    {
      "id": "r1s2t3u4-5678-90ab-cdef-1234567890ab",
      "name": "Ruta Interna Mina - Campamento",
      "origin": "Garita Principal",
      "destination": "Campamento Oasis",
      "distanceKm": 15.5
    }
  ],
  "passengers": [
    {
      "id": "p1q2r3s4-5678-90ab-cdef-1234567890ab",
      "docNumber": "44556677",
      "code": "EMP-9081",
      "firstName": "Juan",
      "lastName": "Pérez",
      "companyName": "Minera Miski Mayo",
      "status": "Active",
      "emoExpirationDate": "2027-05-15",
      "inductionExpirationDate": "2027-02-28",
      "hasSecurityBlock": false
    }
  ]
}
```

---

### 2.3 POST /api/v1/trips
Apertura un viaje en el servidor.

* **Request**:
```json
{
  "id": "t1r2i3p4-5678-90ab-cdef-1234567890ab",
  "driverId": "d1e2f3g4-5678-90ab-cdef-1234567890ab",
  "busId": "b1c2d3e4-5678-90ab-cdef-1234567890ab",
  "routeId": "r1s2t3u4-5678-90ab-cdef-1234567890ab",
  "serviceId": "s1e2r3v4-5678-90ab-cdef-1234567890ab",
  "startKm": 120500,
  "startTime": "2026-06-10T14:30:00Z"
}
```
* **Response (201 Created)**:
```json
{
  "id": "t1r2i3p4-5678-90ab-cdef-1234567890ab",
  "status": "Open",
  "syncStatus": "Synced"
}
```

---

### 2.4 POST /api/v1/trips/{tripId}/boarding
Registra el abordaje de un pasajero en el viaje.

* **Request**:
```json
{
  "id": "br123456-5678-90ab-cdef-1234567890ab",
  "passengerId": "p1q2r3s4-5678-90ab-cdef-1234567890ab",
  "busStopId": "bs987654-5678-90ab-cdef-1234567890ab",
  "scanType": "DNI",
  "scanTimestamp": "2026-06-10T14:35:12Z",
  "latitude": -5.123456,
  "longitude": -80.654321,
  "status": "Boarded",
  "justification": null
}
```
* **Response (201 Created)**:
```json
{
  "id": "br123456-5678-90ab-cdef-1234567890ab",
  "status": "Boarded"
}
```
* **Response (409 Conflict)**:
  * Ocurre si el abordaje ya se encuentra registrado en el servidor (ej. reintento de sync).

---

### 2.5 POST /api/v1/trips/{tripId}/close
Cierra un viaje en el servidor y procesa las firmas.

* **Request**:
```json
{
  "endKm": 120515,
  "endTime": "2026-06-10T15:10:00Z",
  "signatures": {
    "dispatcherSignatureBase64": "data:image/png;base64,iVBORw0KGgo...",
    "driverSignatureBase64": "data:image/png;base64,iVBORw0KGgo..."
  }
}
```
* **Response (200 OK)**:
```json
{
  "id": "t1r2i3p4-5678-90ab-cdef-1234567890ab",
  "status": "Closed",
  "manifestUrl": "https://api.miskimayo.pe/manifests/t1r2i3p4.pdf"
}
```
