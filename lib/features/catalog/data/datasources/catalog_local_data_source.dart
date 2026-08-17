import 'package:mining_transport_app/core/database/app_database.dart';
import 'package:mining_transport_app/features/catalog/domain/entities/catalog_entities.dart';

/// Persistencia local de maestros (Drift) para Offline First de catálogos.
class CatalogLocalDataSource {
  CatalogLocalDataSource(this._db);

  final AppDatabase _db;

  CatalogBundle? _memoryCache;

  CatalogBundle? get memoryCache => _memoryCache;

  void setMemoryCache(CatalogBundle bundle) => _memoryCache = bundle;

  Future<void> saveBundle(CatalogBundle bundle) async {
    _memoryCache = bundle;
    await _db.batch((batch) {
      batch.deleteAll(_db.routes);
      batch.deleteAll(_db.services);
      batch.deleteAll(_db.buses);
      // BusStops exige routeId FK; solo persistimos si hay ruta asociada.
      batch.deleteAll(_db.busStops);

      batch.insertAll(
        _db.routes,
        bundle.routes.map(
          (r) => RoutesCompanion.insert(
            id: '${r.id}',
            name: r.name,
            origin: r.origin ?? '',
            destination: r.destination ?? '',
            distanceKm: r.distanceKm ?? 0,
          ),
        ),
      );

      batch.insertAll(
        _db.services,
        bundle.services.map(
          (s) => ServicesCompanion.insert(
            id: '${s.id}',
            name: s.name,
            code: s.name,
          ),
        ),
      );

      batch.insertAll(
        _db.buses,
        bundle.buses.map(
          (b) => BusesCompanion.insert(
            id: '${b.id}',
            plateNumber: b.plate,
            capacity: b.capacity,
            model: b.model,
            isActive: true,
          ),
        ),
      );

      final stopsWithRoute =
          bundle.stops.where((s) => s.routeId != null && s.routeId! > 0);
      batch.insertAll(
        _db.busStops,
        stopsWithRoute.map(
          (s) => BusStopsCompanion.insert(
            id: '${s.id}',
            routeId: '${s.routeId}',
            name: s.name,
            latitude: s.latitude,
            longitude: s.longitude,
          ),
        ),
      );
    });
  }

  Future<CatalogBundle?> readFromDrift() async {
    if (_memoryCache != null) return _memoryCache;

    final routesRows = await _db.select(_db.routes).get();
    final servicesRows = await _db.select(_db.services).get();
    final busesRows = await _db.select(_db.buses).get();
    final stopsRows = await _db.select(_db.busStops).get();

    if (routesRows.isEmpty && busesRows.isEmpty && servicesRows.isEmpty) {
      return null;
    }

    // Horarios no tienen tabla Drift dedicada: solo memoria.
    final bundle = CatalogBundle(
      routes: routesRows
          .map(
            (r) => CatalogRoute(
              id: int.tryParse(r.id) ?? 0,
              name: r.name,
              distanceKm: r.distanceKm,
              origin: r.origin,
              destination: r.destination,
            ),
          )
          .where((e) => e.id > 0)
          .toList(),
      services: servicesRows
          .map(
            (s) => CatalogService(
              id: int.tryParse(s.id) ?? 0,
              name: s.name,
            ),
          )
          .where((e) => e.id > 0)
          .toList(),
      schedules: const [],
      buses: busesRows
          .map(
            (b) => CatalogBus(
              id: int.tryParse(b.id) ?? 0,
              plate: b.plateNumber,
              capacity: b.capacity,
              model: b.model,
            ),
          )
          .where((e) => e.id > 0)
          .toList(),
      stops: stopsRows
          .map(
            (s) => CatalogStop(
              id: int.tryParse(s.id) ?? 0,
              name: s.name,
              latitude: s.latitude,
              longitude: s.longitude,
              allowedRadiusMeters: 50,
              order: 0,
              routeId: int.tryParse(s.routeId),
            ),
          )
          .where((e) => e.id > 0)
          .toList(),
    );
    _memoryCache = bundle;
    return bundle;
  }
}
