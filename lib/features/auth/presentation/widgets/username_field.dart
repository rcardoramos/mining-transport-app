import 'package:flutter/material.dart';

/// Campo de texto personalizado para el ingreso de usuario.
class UsernameField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const UsernameField({
    super.key,
    required this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'DNI',
        hintText: 'Ingrese su DNI',
        prefixIcon: const Icon(Icons.badge_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'El DNI es requerido';
        }
        return null;
      },
    );
  }
}
