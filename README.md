# Mining Transport App 🚌⛏️

Aplicación móvil corporativa para el control de embarque y transporte de pasajeros en operaciones mineras (Mina Miski Mayo). 

El sistema permite a los conductores controlar los abordajes de colaboradores en tiempo real, validar reglas laborales críticas de acceso (seguridad, EMO, inducciones), registrar coordenadas GPS de auditoría, sincronizar datos de forma offline/online, y generar manifiestos de pasajeros firmados digitalmente.

---

## 🚀 Guía de Arranque por Entorno

El proyecto utiliza configuración dinámica basada en argumentos de compilación. Para definir el entorno de ejecución, utiliza el parámetro `--dart-define=ENV=...` al ejecutar la aplicación.

### 1. Entorno de Desarrollo (DEV)
Este modo utiliza un **simulador de datos local completo (Mocks)**. Permite probar la aplicación de forma ágil sin depender de un servidor backend activo o de un GPS físico.
* **Bypass de Login**: Cualquier credencial es válida y simulará el perfil del conductor.
* **Simulador de GPS**: Permite forzar estar "Dentro" o "Fuera" de rango de los paraderos activos.
* **Simulador de QR**: Permite seleccionar DNI simulados sin necesidad de contar con fotochecks reales.
```bash
flutter run --dart-define=ENV=dev
```

### 2. Entorno de Staging (Pruebas con APIs)
Este entorno conecta el dispositivo con el servidor de pruebas / pre-producción del cliente para verificar integraciones, geolocalización y sincronización.
```bash
flutter run --dart-define=ENV=staging
```

### 3. Entorno de Producción (PROD)
Este entorno compila la aplicación apuntando directamente a las APIs finales del cliente. Cuenta con restricciones de seguridad de producción, validaciones estrictas y deshabilita todo componente simulado.
```bash
flutter run --dart-define=ENV=prod
```

---

## 🏗️ Arquitectura del Proyecto

El proyecto está estructurado siguiendo principios de **Clean Architecture** estructurado por características (**Feature-First**), facilitando el mantenimiento y la escalabilidad.

### Capas principales (`lib/`):
* 📂 **`core/`**: Componentes globales e infraestructura base.
  * `database/`: Conectividad local relacional (Drift).
  * `network/`: Cliente HTTP base (Dio) con interceptores de seguridad.
  * `gps/`: Integración nativa con sensores de geolocalización.
  * `sync/`: Gestor de sincronización offline (SyncQueue y SyncWorker).
  * `scanner/`: Control y decodificación nativa de códigos QR.
* 📂 **`features/`**: Módulos funcionales de negocio (Feature-First):
  * `auth/`: Autenticación de usuarios online/offline.
  * `trip/`: Apertura, tránsito, historial y cierre de viajes.
  * `passenger/`: Captura, escaneo y listado de colaboradores a bordo.
  * `validation/`: Reglas de validación laboral (EMO, inducciones, estados).
  * `geolocation/`: Geofencing de paraderos y auditorías de distancia.
  * `occupancy/`: Control de aforo máximo de la unidad de transporte.
  * `manifest/`: Visualización, descarga e impresión en PDF del manifiesto.
  * `sync/`: Monitoreo y estado de sincronización de datos locales pendientes.
* 📂 **`shared/`**: Sistema de diseño corporativo y componentes UI comunes.

---

## 📜 Reglas de Negocio Clave

La aplicación implementa las siguientes validaciones automatizadas durante el flujo de abordaje:

1. **Geofencing Estricto (`RN-GEO-04-01`)**:
   * Los métodos de registro (Escaneo QR / Ingreso Manual) se habilitan **únicamente** cuando la coordenada GPS del bus está dentro del radio permitido del paradero activo.
   * Si el bus sale del radio o está en tránsito, la UI se atenúa al 50% y los botones se deshabilitan.
2. **Precisión GPS Mínima (`RN-GEO-04-02`)**:
   * Se requiere una precisión del sensor GPS de **30 metros o mejor** para poder registrar un pasajero, garantizando la fiabilidad de las auditorías de geolocalización.
3. **Validación Laboral (`RN-VAL-01`)**:
   * **Bloqueos de Seguridad/Ceses**: Deniegan el abordaje con alerta sonora y visual.
   * **Examen Médico (EMO) / Inducciones Anuales**: Bloquean el embarque si están vencidos.
   * **Excepciones (Vacaciones/Descanso Médico/Licencias)**: Emiten una alerta y requieren confirmación manual del operador para permitir o denegar el abordaje.
4. **Validación de Horarios**:
   * Al aperturar un viaje con más de **15 minutos de desfase** (temprano o tarde) con respecto a la hora programada (`scheduledTime`), la aplicación solicitará confirmación previa al conductor.

---

## 🛠️ Comandos Útiles de Desarrollo

### Instalación de dependencias
```bash
flutter pub get
```

### Generación de código (Build Runner)
Este proyecto utiliza `freezed`, `json_serializable` y `drift` para autogeneración de modelos y persistencia local. Ejecuta este comando tras realizar cambios en entidades o esquemas:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Ejecutar Pruebas Unitarias e Integración
```bash
flutter test
```

### Compilación del APK para Distribución

Para generar los instaladores (.apk) optimizados para producción o pruebas, utiliza los siguientes comandos:

#### Generar APK para Producción (Consumo de APIs Reales)
```bash
flutter build apk --release --dart-define=ENV=prod
```

#### Generar APK para Desarrollo / Pruebas de QA (Con Simuladores y Mocks locales)
```bash
flutter build apk --release --dart-define=ENV=dev
```

> [!TIP]
> Si deseas reducir el tamaño del APK resultante y generar archivos específicos por arquitectura (ABI), puedes añadir el flag `--split-per-abi`:
> ```bash
> flutter build apk --release --dart-define=ENV=prod --split-per-abi
> ```

