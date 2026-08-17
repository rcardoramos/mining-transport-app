import 'package:mining_transport_app/features/catalog/data/models/catalog_models.dart';

abstract class CatalogRemoteDataSource {
  Future<CatalogBootstrapModel> fetchBootstrap();
}
