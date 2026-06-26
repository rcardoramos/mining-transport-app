# ADR 0002: Selección de Gestor de Estado Riverpod para la Capa de Presentación

* **Estado**: Aprobado
* **Fecha**: 2026-06-10
* **Autor**: Principal Software Architect

---

## Contexto y Problema
La aplicación móvil "APP Buses" debe manejar estados complejos y asíncronos en tiempo real: estados de conexión de red, aforo en curso, escaneo continuo de pasajeros, cola de sincronización pendiente, y previsualizaciones de PDF.
Necesitamos un gestor de estado que sea:
1. **Desacoplado del árbol de widgets** de Flutter (para facilitar testing unitario de controladores sin montar widgets).
2. **Seguro contra errores en tiempo de ejecución** (evitar `ProviderNotFoundException`).
3. **Reactivo y eficiente**, reduciendo redibujados innecesarios en la UI.
4. Altamente compatible con la inyección de dependencias de Casos de Uso.

---

## Decisión
Hemos decidido utilizar **Riverpod (v2.x)** como el gestor de estado principal y proveedor de dependencias para la capa de presentación (MVVM).

---

## Justificación

1. **Independencia de BuildContext**:
   A diferencia de Provider, Riverpod no depende de `BuildContext` para la lectura u obtención de proveedores. Esto permite inyectar dependencias y leer estados dentro de clases puras de Dart (como servicios de sincronización o repositorios) de forma directa y segura.
2. **Seguridad en Tiempo de Compilación**:
   Riverpod resuelve las dependencias en tiempo de compilación. Si un proveedor requiere de otro, el compilador de Dart valida la coherencia, eliminando por completo los errores silenciosos en tiempo de ejecución muy comunes en Provider.
3. **Excelente Soporte para Asincronía (`FutureProvider` / `StreamProvider`)**:
   La descarga de catálogos maestros y la monitorización de la cola de sincronización se modelan de manera natural con los proveedores asíncronos de Riverpod, que manejan automáticamente los estados de `AsyncValue` (data, error, loading).
4. **Mantenibilidad y MVVM**:
   Permite estructurar los ViewModels como `StateNotifier` o la nueva sintaxis `@riverpod` (Notifier), exponiendo clases de estado inmutables generadas con `Freezed`. Esto encaja perfectamente en el patrón MVVM exigido en el proyecto.

---

## Consecuencias
* **Positivas**:
  * Código altamente testeable; se pueden mockear proveedores fácilmente en las pruebas unitarias utilizando overrides:
    `ProviderContainer(overrides: [...])`
  * Desacoplamiento total entre lógica de presentación y la UI de Flutter.
  * Manejo automático del ciclo de vida de los estados (autodispose de ViewModels no visibles).
* **Negativas / Desafíos**:
  * Introduce un nuevo paradigma de lectura de estado (`WidgetRef`, `ConsumerWidget`, `ConsumerStatefulWidget`).
  * Requiere familiaridad del equipo de desarrollo con la sintaxis de generación de código de Riverpod (`riverpod_generator`).
