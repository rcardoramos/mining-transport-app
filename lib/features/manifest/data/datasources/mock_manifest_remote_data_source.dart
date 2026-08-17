import 'package:mining_transport_app/features/manifest/data/datasources/manifest_remote_data_source.dart';
import 'package:mining_transport_app/features/manifest/data/models/manifest_dto.dart';

class MockManifestRemoteDataSource implements ManifestRemoteDataSource {
  @override
  Future<ManifestDto> fetchViajeManifiesto(String tripId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return ManifestDto.fromJson({
      'cabecera': {
        'Ruta': 'Piura / Bayovar',
        'Placa': 'ABC-123',
        'Chofer': 'Chofer Mock',
        'Horario': 'Noche',
        'Servicio': 'Operativo',
        'Estado': 'IN_PROGRESS',
      },
      'pasajeros': [
        {
          'Dni': '12345678',
          'NombreCompleto': 'Pasajero Mock',
          'Empresa': 'MISKI MAYO',
          'HoraSubida': DateTime.now().toUtc().toIso8601String(),
          'EstadoLaboral': 'OK',
        },
      ],
    });
  }
}
