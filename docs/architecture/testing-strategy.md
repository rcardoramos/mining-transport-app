# Estrategia de Pruebas (Testing Strategy)

Este documento establece la estrategia y las mejores prácticas para las pruebas de software en la aplicación "APP Buses".

---

## 1. Niveles de Pruebas

```
     +-----------------------------------------+
     |             Golden & UI Tests           |  <- Validar flujos de navegación y alertas visuales
     +-----------------------------------------+
                         |
     +-----------------------------------------+
     |             ViewModel Tests             |  <- Pruebas de estado Riverpod (Notifier/States)
     +-----------------------------------------+
                         |
     +-----------------------------------------+
     |   UseCases, Repositories & DB Tests     |  <- Drift in-memory y reglas de negocio puras
     +-----------------------------------------+
```

### 1.1 Pruebas Unitarias (Unit Tests)
* **Objetivo**: Probar componentes aislados de manera determinista (sin dependencias externas).
* **Foco**:
  * **Casos de Uso**: Validar reglas de negocio individuales (`ValidatePassengerUseCase`, `OpenTripUseCase`).
  * **Repositorios**: Verificar la lógica de derivación (Offline-First): si hay caché local se lee local, si se escribe se guarda local y se mete a `SyncQueue`.
  * **Base de Datos Drift**: Probar las consultas relacionales y las restricciones de base de datos usando una base de datos Drift en memoria (`DatabaseConnection.inMemory()`).

### 1.2 Pruebas de ViewModel y Estado (ViewModel Tests)
* **Objetivo**: Asegurar que los ViewModels expongan el estado inmutable adecuado ante eventos de entrada.
* **Técnica**:
  * Mockear los Casos de Uso del Dominio usando `Mocktail`.
  * Escuchar el `StateNotifier` de Riverpod y capturar el historial de transiciones de estados (ej. `[InitialState, LoadingState, SuccessState]`).

### 1.3 Pruebas de Integración y Sincronización
* **Objetivo**: Validar el flujo de sincronización del `SyncWorker` y la persistencia de cola.
* **Técnica**:
  * Registrar abordajes offline y simular respuestas fallidas del backend (timeout).
  * Verificar que el worker aplique la fórmula del backoff exponencial y detenga el procesamiento de la cola ante un error crítico HTTP 400.

---

## 2. Configuración y Mocks con Mocktail

Se utiliza la librería `Mocktail` para la creación de dobles de prueba (mocks).

### Ejemplo Base de Prueba Unitaria para un Repositorio:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_type/result_type.dart';

// Clases de prueba
class MockLocalDataSource extends Mock implements TripLocalDataSource {}
class MockRemoteDataSource extends Mock implements TripRemoteDataSource {}

void main() {
  late TripRepositoryImpl repository;
  late MockLocalDataSource mockLocalDataSource;
  late MockRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = TripRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  test('Debería retornar éxito al guardar un viaje de forma local', () async {
    // Arrange
    final testTrip = TripEntity(id: '1', startKm: 100);
    when(() => mockLocalDataSource.insertTrip(any())).thenAnswer((_) async => true);
    when(() => mockLocalDataSource.insertSyncQueue(any())).thenAnswer((_) async => 1);

    // Act
    final result = await repository.openTrip(testTrip);

    // Assert
    expect(result.isSuccess, true);
    verify(() => mockLocalDataSource.insertTrip(any())).called(1);
    verify(() => mockLocalDataSource.insertSyncQueue(any())).called(1);
  });
}
```

---

## 3. Cobertura de Código Mínima (Code Coverage)
* **Capa de Dominio**: Mínimo **90%** de cobertura (UseCases y Entidades).
* **Capa de Datos**: Mínimo **80%** (Repositories y DataSources).
* **Capa de Presentación**: Mínimo **60%** (ViewModels).
* **General del Proyecto**: Cobertura combinada mínima del **80%**.
* Se ejecutarán herramientas de reporte en el pipeline de CI:
  `flutter test --coverage`
