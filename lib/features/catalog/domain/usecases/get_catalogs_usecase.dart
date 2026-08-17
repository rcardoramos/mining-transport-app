import 'package:mining_transport_app/core/utils/result.dart';
import '../entities/catalog_entities.dart';
import '../repositories/catalog_repository.dart';

class GetCatalogsUseCase {
  GetCatalogsUseCase(this._repository);

  final CatalogRepository _repository;

  Future<Result<CatalogBundle, Failure>> execute({bool forceRefresh = true}) {
    return _repository.fetchBootstrap(forceRefresh: forceRefresh);
  }
}
