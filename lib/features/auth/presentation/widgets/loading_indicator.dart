import 'package:flutter/material.dart';

/// Indicador de carga centrado reutilizable para el módulo.
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
      ),
    );
  }
}
