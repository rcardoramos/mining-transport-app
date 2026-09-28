/// Mapeo de empresa/categoría desde Validar hacia UI y Registrar.
///
/// Evita el bug de tratar *cualquier* código numérico como Miski Mayo
/// (p. ej. `11` = Terceros).
class EmpresaCategoryMapper {
  EmpresaCategoryMapper._();

  /// Códigos de empresa conocidos (Validar / padrón).
  static const Map<String, String> empresaCodes = {
    '01': 'Miski Mayo',
    '1': 'Miski Mayo',
    '11': 'Terceros',
  };

  /// Categoría de UI/negocio a partir de Empresa + señales de Validar.
  static String normalizeCategory({
    String? empresaOrCategory,
    String? unidad,
    String? estadoLaboral,
  }) {
    final fromSignals = categoryFromLaborSignals(
      unidad: unidad,
      estadoLaboral: estadoLaboral,
    );
    if (fromSignals != null) return fromSignals;

    final clean = (empresaOrCategory ?? '').trim();
    if (clean.isEmpty) return 'Miski Mayo';

    final byCode = empresaCodes[clean];
    if (byCode != null) return byCode;

    // Códigos numéricos desconocidos: no asumir Miski Mayo.
    if (RegExp(r'^\d+$').hasMatch(clean)) {
      return 'Terceros';
    }

    return canonicalizeCategoryName(clean);
  }

  /// Valor de `empresa` para Registrar / RegistrarVisita.
  static String normalizeEmpresaForRegister({
    String? empresaOrCategory,
    String? unidad,
    String? estadoLaboral,
    bool isVisita = false,
  }) {
    if (isVisita) {
      final raw = (empresaOrCategory ?? '').trim();
      if (raw.isEmpty) return 'TERCEROS';
      final category = normalizeCategory(
        empresaOrCategory: raw,
        unidad: unidad,
        estadoLaboral: estadoLaboral,
      );
      return empresaLabelForRegister(category);
    }

    final category = normalizeCategory(
      empresaOrCategory: empresaOrCategory,
      unidad: unidad,
      estadoLaboral: estadoLaboral,
    );
    return empresaLabelForRegister(category);
  }

  /// `tipoPasajero` según categoría resuelta.
  static String tipoPasajeroFor(String? category) {
    switch (canonicalizeCategoryName(category ?? '')) {
      case 'Visita':
        return 'VISITA';
      case 'Terceros':
        return 'TERCEROS';
      case 'Contratista':
        return 'CONTRATISTA';
      default:
        return 'MISKI_MAYO';
    }
  }

  static String? categoryFromLaborSignals({
    String? unidad,
    String? estadoLaboral,
  }) {
    final u = (unidad ?? '').trim().toUpperCase();
    final e = (estadoLaboral ?? '').trim().toUpperCase();

    if (u.contains('TERCER') || e.contains('TERCER')) {
      return 'Terceros';
    }
    if (u.contains('CONTRAT') || e.contains('CONTRAT')) {
      return 'Contratista';
    }
    if (u.contains('VISIT') || e.contains('VISIT')) {
      return 'Visita';
    }
    return null;
  }

  static String canonicalizeCategoryName(String raw) {
    final clean = raw.trim();
    if (clean.isEmpty) return 'Miski Mayo';
    final upper = clean.toUpperCase().replaceAll('_', ' ');

    if (upper == 'MISKI MAYO' ||
        upper == 'MISKI_MAYO' ||
        upper.contains('MISKI')) {
      return 'Miski Mayo';
    }
    if (upper == 'TERCEROS' || upper.contains('TERCER')) {
      return 'Terceros';
    }
    if (upper == 'CONTRATISTA' || upper.contains('CONTRAT')) {
      return 'Contratista';
    }
    if (upper == 'VISITA' || upper.contains('VISIT')) {
      return 'Visita';
    }
    return clean;
  }

  static String empresaLabelForRegister(String category) {
    switch (canonicalizeCategoryName(category)) {
      case 'Visita':
      case 'Terceros':
        return 'TERCEROS';
      case 'Contratista':
        return 'CONTRATISTA';
      default:
        return 'MISKI MAYO';
    }
  }
}
