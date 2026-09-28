import 'package:flutter_test/flutter_test.dart';
import 'package:mining_transport_app/features/passenger/data/mappers/empresa_category_mapper.dart';
import 'package:mining_transport_app/features/passenger/data/models/collaborator_model.dart';

void main() {
  group('EmpresaCategoryMapper', () {
    test('01 / 1 → Miski Mayo', () {
      expect(
        EmpresaCategoryMapper.normalizeCategory(empresaOrCategory: '01'),
        'Miski Mayo',
      );
      expect(
        EmpresaCategoryMapper.normalizeCategory(empresaOrCategory: '1'),
        'Miski Mayo',
      );
    });

    test('11 → Terceros (no Miski Mayo)', () {
      expect(
        EmpresaCategoryMapper.normalizeCategory(empresaOrCategory: '11'),
        'Terceros',
      );
    });

    test('Unidad/Estado TERCEROS fuerza categoría Terceros', () {
      expect(
        EmpresaCategoryMapper.normalizeCategory(
          empresaOrCategory: '01',
          unidad: 'TERCEROS',
        ),
        'Terceros',
      );
      expect(
        EmpresaCategoryMapper.normalizeCategory(
          empresaOrCategory: '',
          estadoLaboral: 'ACTIVO_TERCERO',
        ),
        'Terceros',
      );
    });

    test('Registrar usa empresa y tipoPasajero correctos para tercero', () {
      expect(
        EmpresaCategoryMapper.normalizeEmpresaForRegister(
          empresaOrCategory: '11',
          unidad: 'TERCEROS',
        ),
        'TERCEROS',
      );
      expect(
        EmpresaCategoryMapper.tipoPasajeroFor('Terceros'),
        'TERCEROS',
      );
    });
  });

  group('CollaboratorModel.fromJson', () {
    test('parsea tercero con Empresa 11 y ACTIVO_TERCERO', () {
      final model = CollaboratorModel.fromJson({
        'Dni': '03498666',
        'NombreCompleto': 'FELIX MISAEL BENITES FERNANDEZ',
        'Empresa': '11',
        'Puesto': 'COCINERO',
        'Unidad': 'TERCEROS',
        'EstadoLaboral': 'ACTIVO_TERCERO',
        'PuedeAbordar': 1,
      });

      expect(model.category, 'Terceros');
      expect(model.unidad, 'TERCEROS');
      expect(model.toEntity().status.name, 'ok');
    });
  });
}
