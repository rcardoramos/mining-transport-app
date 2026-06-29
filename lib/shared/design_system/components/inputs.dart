import 'package:flutter/material.dart';
import '../tokens/colors/design_colors.dart';
import '../tokens/radius/design_radius.dart';
import '../tokens/spacing/design_spacing.dart';
import '../tokens/typography/design_typography.dart';

/// Campo de Texto corporativo estilizado con validaciones visuales.
class DesignTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final BorderRadius? borderRadius;

  const DesignTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeRadius = borderRadius ?? DesignRadius.allInput;
    final inputBgColor = isDark ? const Color(0xFF1E1E24) : const Color(0xFFF3F4F6);
    final subtleBorderColor = isDark ? const Color(0xFF2E2E38) : const Color(0xFFE5E7EB);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      style: DesignTypography.bodyLarge.copyWith(
        color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? IconTheme(
                data: IconThemeData(
                  color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
                  size: 20,
                ),
                child: prefixIcon!,
              )
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: inputBgColor,
        labelStyle: DesignTypography.bodyMedium.copyWith(
          color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
        ),
        hintStyle: DesignTypography.bodyMedium.copyWith(
          color: isDark ? Colors.white30 : Colors.black26,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: activeRadius,
          borderSide: BorderSide(
            color: subtleBorderColor,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: activeRadius,
          borderSide: BorderSide(
            color: subtleBorderColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: activeRadius,
          borderSide: BorderSide(
            color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: activeRadius,
          borderSide: BorderSide(
            color: isDark ? DesignColors.dangerDark : DesignColors.dangerLight,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: activeRadius,
          borderSide: BorderSide(
            color: isDark ? DesignColors.dangerDark : DesignColors.dangerLight,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

/// Campo de Contraseña corporativo con botón de visibilidad incorporado.
class DesignPasswordField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final BorderRadius? borderRadius;

  const DesignPasswordField({
    super.key,
    required this.labelText,
    this.hintText,
    this.controller,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.borderRadius,
  });

  @override
  State<DesignPasswordField> createState() => _DesignPasswordFieldState();
}

class _DesignPasswordFieldState extends State<DesignPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return DesignTextField(
      labelText: widget.labelText,
      hintText: widget.hintText,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: TextInputType.visiblePassword,
      validator: widget.validator,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      borderRadius: widget.borderRadius,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Theme.of(context).brightness == Brightness.dark
              ? DesignColors.textSecondaryDark
              : DesignColors.textSecondaryLight,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}

/// Campo de Búsqueda corporativo con icono de lupa y botón para borrar texto.
class DesignSearchField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function()? onClear;

  const DesignSearchField({
    super.key,
    required this.labelText,
    this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return DesignTextField(
      labelText: labelText,
      controller: controller,
      onChanged: onChanged,
      prefixIcon: const Icon(Icons.search_rounded),
      suffixIcon: controller != null && controller!.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                controller!.clear();
                if (onClear != null) onClear!();
              },
            )
          : null,
    );
  }
}

/// Selector de menú desplegable (Dropdown) personalizado.
class DesignDropdown<T> extends StatelessWidget {
  final String labelText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const DesignDropdown({
    super.key,
    required this.labelText,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      style: DesignTypography.bodyLarge.copyWith(
        color: isDark ? DesignColors.textPrimaryDark : DesignColors.textPrimaryLight,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        fillColor: isDark ? DesignColors.surfaceDark : DesignColors.surfaceLight,
        labelStyle: DesignTypography.bodyMedium.copyWith(
          color: isDark ? DesignColors.textSecondaryDark : DesignColors.textSecondaryLight,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: DesignRadius.allMedium,
          borderSide: BorderSide(
            color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: DesignRadius.allMedium,
          borderSide: BorderSide(
            color: isDark ? DesignColors.borderDark : DesignColors.borderLight,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: DesignRadius.allMedium,
          borderSide: BorderSide(
            color: isDark ? DesignColors.primaryDark : DesignColors.primaryLight,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}

/// Selector de Fecha corporativo.
class DesignDatePicker extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final void Function(DateTime) onDateSelected;

  const DesignDatePicker({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final text = selectedDate != null
        ? '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}'
        : '';

    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: IgnorePointer(
        child: DesignTextField(
          labelText: labelText,
          controller: TextEditingController(text: text),
          suffixIcon: const Icon(Icons.calendar_today_rounded),
        ),
      ),
    );
  }
}

/// Selector de Hora corporativo.
class DesignTimePicker extends StatelessWidget {
  final String labelText;
  final TimeOfDay? selectedTime;
  final void Function(TimeOfDay) onTimeSelected;

  const DesignTimePicker({
    super.key,
    required this.labelText,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final text = selectedTime != null
        ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
        : '';

    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: selectedTime ?? TimeOfDay.now(),
        );
        if (time != null) {
          onTimeSelected(time);
        }
      },
      child: IgnorePointer(
        child: DesignTextField(
          labelText: labelText,
          controller: TextEditingController(text: text),
          suffixIcon: const Icon(Icons.access_time_rounded),
        ),
      ),
    );
  }
}

/// Interruptor (Switch) corporativo con etiqueta descriptiva opcional.
class DesignSwitch extends StatelessWidget {
  final bool value;
  final void Function(bool) onChanged;
  final String? label;

  const DesignSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;

    Widget switchWidget = Switch.adaptive(
      value: value,
      onChanged: onChanged,
      activeColor: activeColor,
    );

    if (label != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label!,
            style: DesignTypography.bodyLarge,
          ),
          switchWidget,
        ],
      );
    }

    return switchWidget;
  }
}

/// Casilla de Verificación (Checkbox) corporativa.
class DesignCheckbox extends StatelessWidget {
  final bool value;
  final void Function(bool?) onChanged;
  final String label;

  const DesignCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;

    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor,
              shape: RoundedRectangleBorder(
                borderRadius: DesignRadius.allSmall,
              ),
            ),
            DesignSpacing.spacerH8,
            Expanded(
              child: Text(
                label,
                style: DesignTypography.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Botón de Selección (Radio) corporativo.
class DesignRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final void Function(T?) onChanged;
  final String label;

  const DesignRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;

    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: activeColor,
            ),
            DesignSpacing.spacerH8,
            Expanded(
              child: Text(
                label,
                style: DesignTypography.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
