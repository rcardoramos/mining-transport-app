/// Contexto opcional para cerrar viaje sin un `Viaje/Obtener` extra.
///
/// Embarque ya conoce el paradero activo; reutilizarlo acelera el cierre.
class TripCloseContext {
  final int? paraderoId;
  final String? paraderoName;
  final double? lat;
  final double? lng;

  const TripCloseContext({
    this.paraderoId,
    this.paraderoName,
    this.lat,
    this.lng,
  });
}
