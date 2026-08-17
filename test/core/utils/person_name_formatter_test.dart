import 'package:flutter_test/flutter_test.dart';
import 'package:mining_transport_app/core/utils/person_name_formatter.dart';

void main() {
  group('PersonNameFormatter.shortDisplayName', () {
    test('acorta nombre completo peruano a Nombre + Apellido', () {
      expect(
        PersonNameFormatter.shortDisplayName('PAUL ESTUARDO BELTRAN MIÑAN'),
        'Paul Beltran',
      );
    });

    test('dos partes queda Nombre Apellido', () {
      expect(
        PersonNameFormatter.shortDisplayName('juan perez'),
        'Juan Perez',
      );
    });

    test('una sola parte', () {
      expect(PersonNameFormatter.shortDisplayName('PAUL'), 'Paul');
    });
  });
}
