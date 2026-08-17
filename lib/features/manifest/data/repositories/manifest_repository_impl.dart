import 'package:dio/dio.dart';
import 'package:mining_transport_app/core/utils/logger.dart';
import 'package:mining_transport_app/core/utils/result.dart';
import 'package:mining_transport_app/features/home/domain/repositories/home_dashboard_repository.dart';
import 'package:mining_transport_app/features/manifest/data/datasources/manifest_remote_data_source.dart';
import 'package:mining_transport_app/features/manifest/domain/entities/manifest_snapshot.dart';
import 'package:mining_transport_app/features/manifest/domain/repositories/manifest_repository.dart';

class ManifestRepositoryImpl implements ManifestRepository {
  ManifestRepositoryImpl(
    this._remote,
    this._homeRepository,
    this._logger,
  );

  final ManifestRemoteDataSource _remote;
  final HomeDashboardRepository _homeRepository;
  final AppLogger _logger;

  @override
  Future<Result<ManifestSnapshot, Failure>> fetchManifest(
    String tripId, {
    required bool isOnline,
  }) async {
    if (isOnline) {
      try {
        final dto = await _remote.fetchViajeManifiesto(tripId);
        return Success(dto.toSnapshot(tripId));
      } on DioException catch (e) {
        final failure = _mapDio(e);
        // No workaround silencioso si el backend solo admite viajes cerrados.
        if (_isClosedTripOnlyRestriction(failure)) {
          _logger.e(
            'Viaje/Manifiesto rechazó consulta (posible solo viajes cerrados)',
            e,
          );
          return FailureResult(failure);
        }
        _logger.e('Viaje/Manifiesto falló; intentando Pasajero/Lista', e);
        final fallback = await _fromPassengersList(tripId);
        if (fallback.isSuccess) return fallback;
        return FailureResult(failure);
      } catch (e) {
        _logger.e('Viaje/Manifiesto error inesperado', e);
        final fallback = await _fromPassengersList(tripId);
        if (fallback.isSuccess) return fallback;
        return FailureResult(
          UnknownFailure(
            'No pudimos generar el manifiesto. Inténtelo nuevamente.',
            e,
          ),
        );
      }
    }

    // Offline: lista local vía repository.
    return _fromPassengersList(tripId);
  }

  Future<Result<ManifestSnapshot, Failure>> _fromPassengersList(
    String tripId,
  ) async {
    final result = await _homeRepository.getPassengersOnBoard(tripId);
    if (result.isFailure) {
      return FailureResult(
        result.failureOrNull ??
            const UnknownFailure(
              'No pudimos generar el manifiesto. Inténtelo nuevamente.',
            ),
      );
    }
    return Success(
      ManifestSnapshot(
        tripId: tripId,
        passengers: result.successOrNull ?? const [],
        source: ManifestDataSource.passengersList,
      ),
    );
  }

  bool _isClosedTripOnlyRestriction(Failure failure) {
    return _looksLikeClosedOnly(failure.message);
  }

  Failure _mapDio(DioException e) {
    final data = e.response?.data;
    String? msg;
    if (data is Map) {
      msg = (data['Message'] ?? data['message'])?.toString();
    }
    msg ??= e.message;
    if (_looksLikeClosedOnly(msg)) {
      return ServerFailure(
        msg?.isNotEmpty == true
            ? msg!
            : 'El backend solo permite manifiestos de viajes cerrados. '
                'Se requiere ajuste para viajes en curso.',
        e.response?.statusCode,
        e,
      );
    }
    return ServerFailure(
      msg?.isNotEmpty == true
          ? msg!
          : 'No pudimos generar el manifiesto. Inténtelo nuevamente.',
      e.response?.statusCode,
      e,
    );
  }

  /// Heurística: backend exige viaje cerrado/finalizado (sin fallback silencioso).
  bool _looksLikeClosedOnly(String? msg) {
    final lower = (msg ?? '').toLowerCase();
    final mentionsClosed =
        lower.contains('cerrad') || lower.contains('finalizad');
    final mentionsRestriction = lower.contains('solo') ||
        lower.contains('debe') ||
        lower.contains('requiere') ||
        lower.contains('no se puede') ||
        lower.contains('no permitido') ||
        lower.contains('no disponible') ||
        lower.contains('no admite');
    return mentionsClosed && mentionsRestriction;
  }
}
