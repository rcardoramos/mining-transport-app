import 'package:mining_transport_app/core/utils/result.dart';
import '../entities/passenger_entity.dart';
import '../repositories/home_dashboard_repository.dart';

/// Caso de uso para obtener la lista de pasajeros registrados a bordo de un viaje.
class GetPassengersOnBoardUseCase {
  final HomeDashboardRepository _repository;

  GetPassengersOnBoardUseCase(this._repository);

  Future<Result<List<PassengerEntity>, Failure>> call(String tripId) {
    return _repository.getPassengersOnBoard(tripId);
  }
}
