import 'package:dio/dio.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/catalog/data/datasources/catalog_local_data_source.dart';
import 'package:mining_transport_app/features/catalog/data/datasources/catalog_remote_data_source.dart';
import 'package:mining_transport_app/features/catalog/domain/entities/catalog_entities.dart';
import 'package:mining_transport_app/features/catalog/domain/repositories/catalog_repository.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  CatalogRepositoryImpl(this._remote, this._local);

  final CatalogRemoteDataSource _remote;
  final CatalogLocalDataSource _local;

  @override
  Future<Result<CatalogBundle, Failure>> fetchBootstrap({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh) {
      final cached = _local.memoryCache ?? await _local.readFromDrift();
      if (cached != null && !cached.isEmpty) {
        // Horarios vacíos en Drift → forzar red si faltan schedules.
        if (cached.schedules.isNotEmpty) {
          return Success(cached);
        }
      }
    }

    try {
      final model = await _remote.fetchBootstrap();
      final bundle = model.toEntity();
      await _local.saveBundle(bundle);
      return Success(bundle);
    } on DioException catch (e) {
      final cached = _local.memoryCache ?? await _local.readFromDrift();
      if (cached != null && !cached.isEmpty) {
        return Success(cached);
      }
      return FailureResult(_mapDio(e));
    } catch (e) {
      final cached = _local.memoryCache ?? await _local.readFromDrift();
      if (cached != null && !cached.isEmpty) {
        return Success(cached);
      }
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<CatalogBundle, Failure>> getCachedCatalogs() async {
    final cached = _local.memoryCache ?? await _local.readFromDrift();
    if (cached == null) {
      return const FailureResult(
        CacheFailure('No hay catálogos en caché local.'),
      );
    }
    return Success(cached);
  }

  Failure _mapDio(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final msg = data['Message'] ?? data['message'];
      if (msg != null && '$msg'.isNotEmpty) {
        return ServerFailure('$msg', e.response?.statusCode, e);
      }
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return NetworkFailure(
        'La solicitud tardó demasiado. Inténtelo nuevamente.',
        e,
      );
    }
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure(
        'Sin conexión. No se pudieron cargar los catálogos.',
      );
    }
    return NetworkFailure(
      e.message ?? 'No se pudieron cargar los catálogos.',
      e,
    );
  }
}
