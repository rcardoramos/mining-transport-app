# Arquitectura de Software: Clean Architecture + MVVM

Este documento describe la estructura y las directrices arquitectónicas para el desarrollo de la aplicación "APP Buses", asegurando desacoplamiento, mantenibilidad y facilidad de prueba.

---

## 1. Capas de la Arquitectura
La aplicación sigue estrictamente las tres capas de **Clean Architecture**, divididas con un enfoque **Feature-First** (por funcionalidad):

```
+-------------------------------------------------------------+
|                     PRESENTATION LAYER                      |
|  Widgets (UI)  <--->  ViewModels (Riverpod)  <---> States   |
+-------------------------------------------------------------+
                              |
                              v (Llama a)
+-------------------------------------------------------------+
|                        DOMAIN LAYER                         |
|  Use Cases  <--->  Entities  <--->  Repository Interfaces   |
+-------------------------------------------------------------+
                              ^
                              | (Implementa)
+-------------------------------------------------------------+
|                         DATA LAYER                          |
|  Repositories  <--->  DataSources (Local/Remote) <---> DTOs  |
+-------------------------------------------------------------+
```

### Capa de Dominio (Domain Layer)
* Es el núcleo de la aplicación, completamente independiente de cualquier detalle tecnológico (Flutter, Drift, Dio, etc.). Contiene la lógica pura de negocio.
* **Componentes**:
  * **Entities**: Modelos de datos del negocio (diseñados usando `freezed`).
  * **Use Cases (Casos de Uso)**: Lógica específica de un flujo de negocio (ej. `OpenTripUseCase`, `ValidatePassengerUseCase`). Cada caso de uso realiza una única tarea.
  * **Repository Contracts**: Interfaces que definen qué operaciones de datos se necesitan, sin especificar cómo se obtienen.

### Capa de Datos (Data Layer)
* Implementa las interfaces de la capa de dominio y se comunica con fuentes externas o locales.
* **Componentes**:
  * **Repository Implementations**: Coordina la estrategia Offline First (ej. consultar primero localmente, registrar en cola y retornar resultados).
  * **DataSources**:
    * **LocalDataSource**: Interactúa directamente con la base de datos Drift (`AppDatabase`).
    * **RemoteDataSource**: Consume servicios web (REST API de ADRYAN) usando Dio.
  * **Models / DTOs (Data Transfer Objects)**: Representaciones de datos específicos para base de datos u endpoints API (con serialización de Freezed y JsonSerializable).

### Capa de Presentación (Presentation Layer)
* Se encarga de la interfaz gráfica y de reaccionar al estado de la aplicación.
* **Componentes**:
  * **Views (Widgets)**: UI pura construida en Flutter. Tienen estrictamente prohibido contener lógica de negocio.
  * **ViewModels (Riverpod StateNotifiers)**: Administran el estado de la pantalla. Consumen casos de uso del dominio y exponen estados inmutables a las vistas.
  * **States**: Clases inmutables que representan de forma precisa el estado actual de la interfaz (ej. `Loading`, `Success`, `Error`).

---

## 2. Flujo de Datos y Control
1. El usuario interactúa con un **Widget** (ej. presiona "Escanear Pasajero").
2. El Widget invoca un método del **ViewModel** (Riverpod Notifier).
3. El ViewModel activa el **UseCase** correspondiente (ej. `ValidatePassengerUseCase`).
4. El UseCase ejecuta las reglas de negocio (ej. verificar aforo y vigencias) consultando el **Repository**.
5. El **Repository** interactúa con el **LocalDataSource** (Drift) para buscar los datos maestros descargados.
6. El resultado fluye de regreso al UseCase envoltura en un tipo de respuesta estructurado (ej. `Result<Passenger, Failure>`).
7. El UseCase retorna el resultado al ViewModel, quien actualiza el **State** de la UI.
8. La **UI** se redibuja de manera reactiva según el nuevo estado.

---

## 3. Reglas de Desarrollo Obligatorias

### A. Inyección de Dependencias
* Se utiliza **GetIt** para el registro e inyección de servicios singleton globales e independientes del árbol de widgets (ej. `AppDatabase`, `DioClient`, `SecureStorage`, `SyncManager`).
* **Riverpod** se utiliza exclusivamente para la inyección de ViewModels en la capa de presentación y la lectura reactiva del estado.

### B. Manejo de Errores Tipados (Result Pattern)
* Prohibido lanzar excepciones incontroladas (`throw`) a través de las capas.
* Todos los métodos de Repositorios y Casos de Uso deben retornar un objeto `Result<S, F>` (donde `S` es el éxito y `F` es una subclase de `Failure` específica, ej. `DatabaseFailure`, `NetworkFailure`, `ValidationError`).

### C. Inmutabilidad de Estados
* Todo estado expuesto a la vista debe ser inmutable.
* Se prohíbe reasignar propiedades internas directamente. Las modificaciones de estado se realizan utilizando la función `.copyWith(...)` de Freezed.
