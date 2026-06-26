# ADR 0001: Selección de Base de Datos Local para Operación Offline First

* **Estado**: Aprobado
* **Fecha**: 2026-06-10
* **Autor**: Principal Software Architect

---

## Contexto y Problema
El sistema de control de embarque requiere almacenar de forma persistente y local a miles de trabajadores, conductores, vehículos y paraderos descargados de ADRYAN. Se debe poder realizar búsquedas complejas en tiempo récord (ej. validar si un DNI escaneado existe y comprobar múltiples vigencias laborales en < 100ms) y gestionar de forma consistente una cola de transacciones persistente (`SyncQueue`) que garantice el procesamiento FIFO.

Teníamos tres opciones principales de base de datos local en Flutter:
1. **Hive / Isar**: Base de datos NoSQL clave-valor / documental rápida.
2. **Drift (SQLite)**: Base de datos SQL relacional robusta con tipado estático en Dart.
3. **SharedPreferences / SecureStorage**: Almacenamiento básico clave-valor (inviable para grandes volúmenes).

---

## Decisión
Hemos decidido utilizar **Drift** como el motor de base de datos local principal para los datos relacionales y transaccionales del sistema.

---

## Justificación

1. **Integridad Relacional (Claves Foráneas y ACID)**: 
   Las transacciones de embarque dependen de relaciones fuertes (`BoardingRecord` vincula a `Trip`, `Passenger` y `BusStop`). SQLite garantiza transacciones ACID nativas y restricciones de clave foránea (`FOREIGN KEY`), evitando la corrupción de datos o la huérfana de registros durante inserciones offline masivas.
2. **Capacidad de Indexación Avanzada**:
   Permite la creación de índices compuestos (`CREATE INDEX idx_boarding_records_trip_passenger`) que aseguran la prevención de doble embarque de forma inmediata mediante consultas SQL optimizadas, manteniendo un rendimiento estable con más de 10,000 registros de personal.
3. **Migraciones Esquematizadas**:
   Drift ofrece un potente soporte para migraciones de esquema con validaciones de tipado estático durante la compilación. Dado que el sistema corporativo ADRYAN puede evolucionar y requerir nuevos campos en el futuro, Drift facilita migraciones seguras paso a paso.
4. **Programación Reactiva**:
   Drift proporciona streams reactivos de manera nativa. Cualquier inserción en la base de datos se refleja automáticamente en los observadores del UI (a través de Riverpod), facilitando la actualización inmediata del aforo del bus sin recarga manual.

---

## Consecuencias
* **Positivas**:
  * Alta consistencia y prevención de pérdida de datos.
  * Consultas rápidas y optimizadas con el motor SQLite C-engine subyacente.
  * Código tipado y generación de clases automáticas integradas con Drift.
* **Negativas / Desafíos**:
  * Requiere paso adicional de compilación mediante `build_runner`.
  * La curva de aprendizaje para definir relaciones y joins en Dart con Drift es ligeramente mayor que en bases de datos NoSQL simples.
