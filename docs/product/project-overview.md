# Descripción General del Proyecto: APP Buses (Miski Mayo)

## Cliente
Compañía Minera Miski Mayo

## Objetivo del Proyecto
Desarrollar una aplicación móvil corporativa para el control de embarque y la generación de manifiestos de transporte del personal minero. La aplicación debe operar de manera 100% autónoma en zonas sin cobertura (Offline First), sincronizarse automáticamente en segundo plano con el ERP corporativo (ADRYAN), y permitir la emisión física de manifiestos mediante impresoras portátiles (vía Bluetooth o Wi-Fi).

## Métricas Clave del Negocio
1. **Pérdida de Datos Cero (Zero Data Loss)**: Todo registro de embarque debe ser guardado de forma persistente y local, garantizando su posterior sincronización cuando haya conectividad.
2. **Alta Velocidad de Validación**: El escaneo del código de barras del DNI o del fotocheck de un trabajador debe ser procesado y validado en menos de 1 segundo en el dispositivo.
3. **Disponibilidad Total**: El 100% de las funciones críticas para la apertura de viajes, control de aforo y registro de embarque deben estar operativas sin internet.

## Mapa Documental
Esta documentación técnica se compone de las siguientes áreas:
* **Producto (Negocio)**:
  * [Reglas de Negocio](file:///C:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/business-rules.md): Validaciones laborales e integridad de datos.
  * [Requerimientos Funcionales](file:///C:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/functional-requirements.md): Detalle de funcionalidades por módulos.
  * [Criterios de Aceptación](file:///C:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/acceptance-criteria.md): Escenarios de prueba y validación.
  * [Casos de Uso](file:///C:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/use-cases.md): Interacciones del usuario con la app.
  * [Flujos de Usuario](file:///C:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/user-flows.md): Caminos de navegación críticos.
  * [Matriz de Trazabilidad](file:///C:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/product/traceability-matrix.md): Alineación entre negocio y requerimientos.
* **Arquitectura (Técnica)**:
  * [Clean Architecture](file:///C:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/clean-architecture.md): Capas del sistema y diseño MVVM.
  * [Modelo de Dominio](file:///C:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/domain-model.md): Entidades y agregados bajo DDD.
  * [Diseño de Base de Datos](file:///C:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/database-design.md): Esquema relacional optimizado en Drift.
  * [Estrategia Offline First](file:///C:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/offline-first.md): Gestión de caché local y conectividad.
  * [Estrategia de Sincronización](file:///C:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/sync-strategy.md): Motor de cola persistente (`SyncQueue`) y resolución de conflictos.
  * [Contratos de API](file:///C:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/api-contracts.md): Especificación REST para ADRYAN.
  * [Estrategia de Pruebas](file:///C:/Users/RICARDO%20RAMOS/OneDrive/Escritorio/mining-transport-app/docs/architecture/testing-strategy.md): Cobertura unitaria, de integración y UI.
