import 'package:mining_transport_app/core/utils/result.dart';
import '../../domain/entities/driver_entity.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/entities/passenger_entity.dart';
import '../../domain/entities/collaborator_entity.dart';
import '../../domain/repositories/home_dashboard_repository.dart';
import '../datasources/home_dashboard_remote_data_source.dart';
import '../models/passenger_model.dart';
import '../models/collaborator_model.dart';

/// Implementación concreta del Repositorio de Home Dashboard.
class HomeDashboardRepositoryImpl implements HomeDashboardRepository {
  final HomeDashboardRemoteDataSource _remoteDataSource;

  HomeDashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<DriverEntity, Failure>> getDriverInfo() async {
    try {
      final model = await _remoteDataSource.getDriverInfo();
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TripEntity>, Failure>> getTodayTrips() async {
    try {
      final models = await _remoteDataSource.getTodayTrips();
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<TripEntity>, Failure>> getPendingTrips() async {
    try {
      final models = await _remoteDataSource.getPendingTrips();
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<DashboardSummaryEntity, Failure>> getDashboardSummary() async {
    try {
      final model = await _remoteDataSource.getDashboardSummary();
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TripEntity, Failure>> updateTripStatus(String id, TripStatus status) async {
    try {
      final model = await _remoteDataSource.updateTripStatus(id, status.name);
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TripEntity, Failure>> registerPassenger(String id, String dni, [CollaboratorStatus? status, String? category, String? registrationMethod, double? lat, double? lng, String? justification]) async {
    try {
      final model = await _remoteDataSource.registerPassenger(id, dni, status?.name, category, registrationMethod, lat, lng, justification);
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<PassengerEntity>, Failure>> getPassengersOnBoard(String tripId) async {
    try {
      final models = await _remoteDataSource.getPassengersOnBoard(tripId);
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<CollaboratorEntity, Failure>> checkCollaborator(String dni) async {
    try {
      final model = await _remoteDataSource.checkCollaborator(dni);
      return Success(model.toEntity());
    } catch (e) {
      if (e.toString().contains('not_found')) {
        return FailureResult(CollaboratorNotFoundFailure(e.toString()));
      }
      return FailureResult(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<TripEntity, Failure>> completeStop(String tripId, String stopId) async {
    try {
      final model = await _remoteDataSource.completeStop(tripId, stopId);
      return Success(model.toEntity());
    } catch (e) {
      return FailureResult(UnknownFailure(e.toString()));
    }
  }
}
