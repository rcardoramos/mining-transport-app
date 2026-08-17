import '../entities/catalog_entities.dart';
import 'package:mining_transport_app/core/utils/result.dart';

abstract class CatalogRepository {
  /// Carga catálogos desde API (Bootstrap) y actualiza caché local.
  Future<Result<CatalogBundle, Failure>> fetchBootstrap({bool forceRefresh = false});

  /// Lee la última caché en memoria/Drift sin forzar red.
  Future<Result<CatalogBundle, Failure>> getCachedCatalogs();
}
