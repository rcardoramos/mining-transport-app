# Flujos de Usuario: APP Buses (Miski Mayo)

Este documento contiene los flujos visuales y de interacción humana con la aplicación móvil en formato secuencial y diagramas Mermaid.

## 1. Flujo de Autenticación e Inicio de Sesión
Este flujo muestra el ciclo de vida del inicio de sesión, permitiendo la operación offline basada en credenciales previamente validadas.

```mermaid
graph TD
    A[Inicio de la App] --> B{¿Tiene Red?}
    B -- Sí --> C[Ingreso de Credenciales Online]
    C --> D[Validación con API ADRYAN]
    D -- Válido --> E[Guardar Credenciales en Secure Storage]
    E --> F[Descarga de Catálogos Maestros]
    F --> G[Navegar al Dashboard Principal]
    D -- Inválido --> H[Mostrar Error de Credenciales]
    B -- No --> I[Ingreso de Credenciales Offline]
    I --> J{¿Existe Hash en Secure Storage?}
    J -- Sí --> K{¿Contraseña Coincide?}
    K -- Sí --> G
    K -- No --> H
    J -- No --> L[Mostrar Error: Requiere primer login online]
```

---

## 2. Ciclo de Vida del Viaje (Trip Lifecycle)
El flujo que sigue el operador para abrir, gestionar el aforo y cerrar un viaje.

```mermaid
graph TD
    A[Dashboard Principal] --> B[Seleccionar Apertura de Viaje]
    B --> C[Seleccionar Bus, Conductor, Ruta y Servicio]
    C --> D[Digitar Kilometraje Inicial]
    D --> E[Presionar Iniciar Viaje]
    E --> F[Guardar Trip localmente en Drift]
    F --> G[Agregar 'Open' a SyncQueue]
    G --> H[Pantalla de Control de Embarque]
    H --> I[Registro de Pasajeros]
    I --> J{¿Operador presiona Cerrar Viaje?}
    J -- Sí --> K[Digitar Kilometraje Final]
    K --> L[Firmar operador y conductor en pantalla]
    L --> M[Guardar 'Closed' en Drift]
    M --> N[Agregar 'Close' a SyncQueue]
    N --> O[Pantalla Previsualización y Generación de PDF]
    O --> P[Imprimir Ticketera Bluetooth]
```

---

## 3. Flujo del Control de Abordaje (Escaneo de Pasajero)
Flujo detallado de validación de cada pasajero al escanear o buscar manualmente su DNI/Fotocheck.

```mermaid
graph TD
    A[Pantalla de Embarque] --> B{¿Límite de Aforo Alcanzado?}
    B -- Sí --> C[Bloquear interfaz de registro e indicar Aforo Completo]
    B -- No --> D[Activar Cámara / Buscar Manual]
    D --> E[Obtener DNI / Código de Empleado]
    E --> F[Consultar Pasajero en BD Local Drift]
    F --> G{¿Trabajador existe?}
    G -- No --> H[Pantalla de Error: Pasajero no registrado en padrón]
    G -- Sí --> I{¿Estado es Activo?}
    I -- No --> J[Pantalla Roja: Trabajador inactivo]
    I -- Sí --> K{¿Examen Médico EMO Vigente?}
    K -- No --> L[Pantalla Roja: Examen Médico vencido]
    K -- Sí --> M{¿Inducción de Seguridad Vigente?}
    M -- No --> N[Pantalla Roja: Inducción vencida]
    M -- Sí --> O{¿Ya abordó en este u otro viaje activo hoy?}
    O -- Sí --> P[Pantalla Amarilla: Doble Embarque detectado]
    O -- No --> Q[Obtener Coordenadas GPS del dispositivo]
    Q --> R{¿Distancia al Paradero > 100m?}
    R -- Sí --> S[Mostrar Advertencia de paradero y pedir justificación]
    S --> T[Guardar Abordaje con Justificación]
    R -- No --> U[Guardar Abordaje directo]
    T & U --> V[Generar BoardingRecord y SyncQueue local]
    V --> W[Pantalla Verde: APROBADO + Sonido Agudo]
    W --> X[Actualizar Aforo en pantalla y reanudar]
```
