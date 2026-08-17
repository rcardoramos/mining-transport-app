/// Utilidades de presentación de nombres de persona.
class PersonNameFormatter {
  PersonNameFormatter._();

  /// Saludo corto: "PAUL ESTUARDO BELTRAN MIÑAN" → "Paul Beltran".
  ///
  /// - 1 parte: solo ese nombre
  /// - 2 partes: Nombre Apellido
  /// - 3+: primer nombre + primer apellido (penúltima palabra en nombres latinos)
  static String shortDisplayName(String fullName) {
    final parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return fullName.trim();
    if (parts.length == 1) return _toTitleCase(parts.first);
    if (parts.length == 2) {
      return '${_toTitleCase(parts[0])} ${_toTitleCase(parts[1])}';
    }
    return '${_toTitleCase(parts.first)} ${_toTitleCase(parts[parts.length - 2])}';
  }

  static String _toTitleCase(String value) {
    final lower = value.toLowerCase();
    if (lower.isEmpty) return value;
    return '${lower[0].toUpperCase()}${lower.substring(1)}';
  }
}
