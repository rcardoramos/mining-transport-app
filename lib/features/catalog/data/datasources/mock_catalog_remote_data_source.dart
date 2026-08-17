import 'package:mining_transport_app/features/catalog/data/datasources/catalog_remote_data_source.dart';
import 'package:mining_transport_app/features/catalog/data/models/catalog_models.dart';

class MockCatalogRemoteDataSource implements CatalogRemoteDataSource {
  @override
  Future<CatalogBootstrapModel> fetchBootstrap() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return CatalogBootstrapModel.fromJson({
      'Rutas': [
        {'id': 1, 'nombre': 'Piura / Bayovar', 'distanciaKm': 120},
        {'id': 2, 'nombre': 'Catacaos / Mina', 'distanciaKm': 80},
      ],
      'Servicios': [
        {'id': 1, 'nombre': 'Administrativo'},
        {'id': 2, 'nombre': 'Operativo'},
      ],
      'Horarios': [
        {'id': 1, 'horaSalida': '06:00:00'},
        {'id': 2, 'horaSalida': '14:00:00'},
        {'id': 3, 'horaSalida': '22:00:00'},
      ],
      'Buses': [
        {
          'id': 1,
          'placa': 'ABC-123',
          'capacidad': 40,
          'modelo': 'Mercedes Benz',
        },
        {
          'id': 2,
          'placa': 'TOU-450',
          'capacidad': 44,
          'modelo': 'Volvo',
        },
      ],
      'Paraderos': [
        {
          'id': 5,
          'nombre': 'Óvalo Grau',
          'latitud': -5.19449,
          'longitud': -80.63282,
          'radioPermitido': 50,
          'orden': 1,
          'rutaId': 1,
        },
        {
          'id': 6,
          'nombre': 'Catacaos',
          'latitud': -5.265,
          'longitud': -80.678,
          'radioPermitido': 50,
          'orden': 2,
          'rutaId': 1,
        },
        {
          'id': 7,
          'nombre': 'La Arena',
          'latitud': -5.35,
          'longitud': -80.7,
          'radioPermitido': 50,
          'orden': 1,
          'rutaId': 2,
        },
      ],
    });
  }
}
