import 'package:mining_transport_app/core/database/app_database.dart';

/// Interfaz para el data source local que interactúa con Drift para consultar datos de pasajeros.
abstract class ValidationLocalDataSource {
  /// Busca un pasajero (colaborador) por su DNI.
  Future<Passenger?> getPassengerByDni(String dni);

  /// Guarda o actualiza un pasajero en la base de datos local.
  Future<void> savePassenger(Passenger passenger);
}

/// Implementación concreta de [ValidationLocalDataSource] usando Drift.
class ValidationLocalDataSourceImpl implements ValidationLocalDataSource {
  final AppDatabase _database;

  ValidationLocalDataSourceImpl(this._database);

  @override
  Future<Passenger?> getPassengerByDni(String dni) {
    return (_database.select(_database.passengers)..where((tbl) => tbl.docNumber.equals(dni))).getSingleOrNull();
  }

  @override
  Future<void> savePassenger(Passenger passenger) {
    return _database.into(_database.passengers).insertOnConflictUpdate(passenger);
  }
}
