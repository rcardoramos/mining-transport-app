import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get username => text()();
  TextColumn get fullName => text()();
  TextColumn get role => text()();
  TextColumn get token => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Drivers extends Table {
  TextColumn get id => text()();
  TextColumn get code => text()();
  TextColumn get fullName => text()();
  TextColumn get licenseNumber => text()();
  DateTimeColumn get licenseExpiration => dateTime()();
  BoolColumn get isActive => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class Buses extends Table {
  TextColumn get id => text()();
  TextColumn get plateNumber => text()();
  IntColumn get capacity => integer()();
  TextColumn get model => text()();
  BoolColumn get isActive => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class Routes extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get origin => text()();
  TextColumn get destination => text()();
  RealColumn get distanceKm => real()();

  @override
  Set<Column> get primaryKey => {id};
}

class Services extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get code => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class BusStops extends Table {
  TextColumn get id => text()();
  TextColumn get routeId => text().references(Routes, #id)();
  TextColumn get name => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();

  @override
  Set<Column> get primaryKey => {id};
}

class Trips extends Table {
  TextColumn get id => text()();
  TextColumn get driverId => text().references(Drivers, #id)();
  TextColumn get busId => text().references(Buses, #id)();
  TextColumn get routeId => text().references(Routes, #id)();
  TextColumn get serviceId => text().references(Services, #id)();
  IntColumn get startKm => integer()();
  IntColumn get endKm => integer().nullable()();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  TextColumn get status => text()(); // Open, Closed, Syncing, Synced
  TextColumn get syncStatus => text()(); // Pending, Synced, Error

  @override
  Set<Column> get primaryKey => {id};
}

class Passengers extends Table {
  TextColumn get id => text()();
  TextColumn get docNumber => text()(); // DNI
  TextColumn get code => text()(); // Employee/Contactor code
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get companyName => text()();
  TextColumn get status => text()(); // Active, Inactive
  DateTimeColumn get emoExpirationDate => dateTime()();
  DateTimeColumn get inductionExpirationDate => dateTime()();
  BoolColumn get hasSecurityBlock => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

class BoardingRecords extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().references(Trips, #id)();
  TextColumn get passengerId => text().references(Passengers, #id)();
  TextColumn get busStopId => text().references(BusStops, #id)();
  TextColumn get scanType => text()(); // DNI, FOTOCHECK, MANUAL
  DateTimeColumn get scanTimestamp => dateTime()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get status => text()(); // Boarded, Cancelled
  TextColumn get justification => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get actionType => text()(); // CREATE_TRIP, BOARD_PASSENGER, CLOSE_TRIP
  TextColumn get payloadJson => text()();
  TextColumn get status => text()(); // Pending, Synced, Error
  TextColumn get errorDetails => text().nullable()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
}

class AuditLogs extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get action => text()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get details => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Users,
  Drivers,
  Buses,
  Routes,
  Services,
  BusStops,
  Trips,
  Passengers,
  BoardingRecords,
  SyncQueue,
  AuditLogs
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // Habilitar claves foráneas en SQLite
        await customStatement('PRAGMA foreign_keys = ON;');
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'mining_transport.db'));
    return NativeDatabase.createInBackground(file);
  });
}
