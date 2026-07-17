import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';

part 'trip_state.freezed.dart';

/// Estado inmutable de la pantalla de gestión de viajes.
@freezed
class TripState with _$TripState {
  const factory TripState({
    /// Carga inicial de la lista de viajes.
    @Default(true) bool isLoading,

    /// Indicador de una acción en curso (apertura/cierre de viaje).
    @Default(false) bool isActionLoading,

    /// Mensaje de error a mostrar al usuario, si aplica.
    String? errorMessage,

    /// Lista de viajes del día en curso.
    @Default([]) List<TripEntity> todayTrips,

    /// Lista de viajes pendientes de días futuros.
    @Default([]) List<TripEntity> pendingTrips,

    /// Viaje actualmente seleccionado para ver su detalle.
    TripEntity? selectedTrip,

    /// Kilometraje de apertura del viaje activo (para validación de cierre).
    int? activeStartKm,
  }) = _TripState;

  /// Computado: retorna el viaje activo (en embarque o en tránsito), si existe.
  const TripState._();

  TripEntity? get activeTrip {
    final all = [...todayTrips, ...pendingTrips];
    return all.where((t) =>
      t.status == TripStatus.inProgress || t.status == TripStatus.travelling
    ).firstOrNull;
  }

  bool get hasActiveTrip => activeTrip != null;
}
