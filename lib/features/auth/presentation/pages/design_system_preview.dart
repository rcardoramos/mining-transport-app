import 'package:flutter/material.dart';
import '../../../../shared/design_system/design_system.dart';

/// Pantalla catálogo interactiva que permite previsualizar y probar
/// todos los componentes y animaciones del Design System en modo Light y Dark.
class DesignSystemPreview extends StatefulWidget {
  const DesignSystemPreview({super.key});

  @override
  State<DesignSystemPreview> createState() => _DesignSystemPreviewState();
}

class _DesignSystemPreviewState extends State<DesignSystemPreview> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isDarkMode = false;
  
  // Input states
  final _textController = TextEditingController(text: 'Texto de prueba');
  final _searchController = TextEditingController();
  String? _selectedValue = 'Opción 1';
  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime = const TimeOfDay(hour: 8, minute: 30);
  bool _switchVal = true;
  bool _checkVal = false;
  String _radioVal = 'A';

  // Loading overlay state
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Aplicamos el tema dinámicamente según la selección en el catálogo
    final themeData = _isDarkMode ? AppDesignTheme.darkTheme : AppDesignTheme.lightTheme;

    return Theme(
      data: themeData,
      child: Builder(
        builder: (context) {
          final customColors = Theme.of(context).extension<DesignThemeExtension>()!;

          return DesignLoadingOverlay(
            isLoading: _showOverlay,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Design System Preview'),
                centerTitle: false,
                actions: [
                  Row(
                    children: [
                      Text(_isDarkMode ? 'Modo Oscuro' : 'Modo Claro'),
                      Switch.adaptive(
                        value: _isDarkMode,
                        onChanged: (val) => setState(() => _isDarkMode = val),
                      ),
                    ],
                  ),
                ],
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'Tokens'),
                    Tab(text: 'Botones'),
                    Tab(text: 'Inputs'),
                    Tab(text: 'Cards'),
                    Tab(text: 'Feedback'),
                    Tab(text: 'Navegación'),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: [
                  _buildTokensTab(context, customColors),
                  _buildButtonsTab(),
                  _buildInputsTab(),
                  _buildCardsTab(customColors),
                  _buildFeedbackTab(context, customColors),
                  _buildNavigationTab(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTokensTab(BuildContext context, DesignThemeExtension colors) {
    return ListView(
      padding: DesignSpacing.allM,
      children: [
        const DesignSectionHeader(title: 'Paleta de Colores'),
        _buildColorTile('Primary (Teal)', Theme.of(context).primaryColor),
        _buildColorTile('Secondary (Industrial)', Theme.of(context).colorScheme.secondary),
        _buildColorTile('Success', colors.success),
        _buildColorTile('Warning', colors.warning),
        _buildColorTile('Danger', colors.danger),
        _buildColorTile('Info', colors.info),
        _buildColorTile('Background', Theme.of(context).scaffoldBackgroundColor),
        _buildColorTile('Surface', Theme.of(context).colorScheme.surface),
        _buildColorTile('Border', colors.border),
        _buildColorTile('Text Primary', colors.textPrimary),
        _buildColorTile('Text Secondary', colors.textSecondary),
        DesignSpacing.spacerV24,
        const DesignSectionHeader(title: 'Tipografía'),
        Text('Display Large (36px)', style: DesignTypography.display),
        DesignSpacing.spacerV8,
        Text('Headline Large (28px)', style: DesignTypography.headline),
        DesignSpacing.spacerV8,
        Text('Title Large (22px)', style: DesignTypography.titleLarge),
        DesignSpacing.spacerV8,
        Text('Title Medium (18px)', style: DesignTypography.titleMedium),
        DesignSpacing.spacerV8,
        Text('Body Large (16px)', style: DesignTypography.bodyLarge),
        DesignSpacing.spacerV8,
        Text('Body Medium (14px)', style: DesignTypography.bodyMedium),
        DesignSpacing.spacerV8,
        Text('Label Large (14px)', style: DesignTypography.labelLarge),
        DesignSpacing.spacerV8,
        Text('Label Medium (12px)', style: DesignTypography.labelMedium),
        DesignSpacing.spacerV8,
        Text('Caption (11px)', style: DesignTypography.caption),
      ],
    );
  }

  Widget _buildColorTile(String name, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: DesignRadius.allMedium,
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
        ),
        title: Text(name, style: DesignTypography.bodyLarge),
        subtitle: Text(
          'HEX: #${color.value.toRadixString(16).substring(2).toUpperCase()}',
          style: DesignTypography.caption,
        ),
      ),
    );
  }

  Widget _buildButtonsTab() {
    return ListView(
      padding: DesignSpacing.allM,
      children: [
        const DesignSectionHeader(title: 'Botones de Acción'),
        DesignButton.primary(
          text: 'Primary Button',
          onTap: () {},
        ),
        DesignSpacing.spacerV12,
        DesignButton.secondary(
          text: 'Secondary Button',
          onTap: () {},
        ),
        DesignSpacing.spacerV12,
        DesignButton.outlined(
          text: 'Outlined Button',
          onTap: () {},
        ),
        DesignSpacing.spacerV12,
        DesignButton.text(
          text: 'Text Button',
          onTap: () {},
        ),
        DesignSpacing.spacerV12,
        DesignButton.primary(
          text: 'Primary Loading',
          onTap: () {},
          isLoading: true,
        ),
        DesignSpacing.spacerV12,
        const DesignButton.primary(
          text: 'Disabled Button',
          onTap: null,
        ),
        DesignSpacing.spacerV24,
        const DesignSectionHeader(title: 'Botones con Iconos'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DesignIconButton(
              icon: Icons.add_rounded,
              onTap: () {},
              tooltip: 'Agregar',
            ),
            DesignIconButton(
              icon: Icons.edit_rounded,
              onTap: () {},
              tooltip: 'Editar',
            ),
            DesignIconButton(
              icon: Icons.delete_rounded,
              onTap: () {},
              tooltip: 'Eliminar',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputsTab() {
    return ListView(
      padding: DesignSpacing.allM,
      children: [
        const DesignSectionHeader(title: 'Campos de Texto'),
        DesignTextField(
          labelText: 'Nombre Completo',
          hintText: 'Ej. Juan Pérez',
          controller: _textController,
        ),
        DesignSpacing.spacerV12,
        const DesignPasswordField(
          labelText: 'Contraseña',
          hintText: 'Ingresa tu clave',
        ),
        DesignSpacing.spacerV12,
        DesignSearchField(
          labelText: 'Buscar elemento',
          controller: _searchController,
          onChanged: (val) => setState(() {}),
        ),
        DesignSpacing.spacerV24,
        const DesignSectionHeader(title: 'Selectores'),
        DesignDropdown<String>(
          labelText: 'Selección de Opción',
          value: _selectedValue,
          items: const [
            DropdownMenuItem(value: 'Opción 1', child: Text('Opción 1')),
            DropdownMenuItem(value: 'Opción 2', child: Text('Opción 2')),
            DropdownMenuItem(value: 'Opción 3', child: Text('Opción 3')),
          ],
          onChanged: (val) => setState(() => _selectedValue = val),
        ),
        DesignSpacing.spacerV12,
        DesignDatePicker(
          labelText: 'Selecciona una fecha',
          selectedDate: _selectedDate,
          onDateSelected: (date) => setState(() => _selectedDate = date),
        ),
        DesignSpacing.spacerV12,
        DesignTimePicker(
          labelText: 'Selecciona una hora',
          selectedTime: _selectedTime,
          onTimeSelected: (time) => setState(() => _selectedTime = time),
        ),
        DesignSpacing.spacerV24,
        const DesignSectionHeader(title: 'Interruptores y Casillas'),
        DesignSwitch(
          value: _switchVal,
          label: 'Habilitar notificaciones',
          onChanged: (val) => setState(() => _switchVal = val),
        ),
        DesignSpacing.spacerV12,
        DesignCheckbox(
          value: _checkVal,
          label: 'Acepto los términos y condiciones',
          onChanged: (val) => setState(() => _checkVal = val ?? false),
        ),
        DesignSpacing.spacerV12,
        Row(
          children: [
            Expanded(
              child: DesignRadioButton<String>(
                value: 'A',
                groupValue: _radioVal,
                label: 'Opción A',
                onChanged: (val) => setState(() => _radioVal = val!),
              ),
            ),
            Expanded(
              child: DesignRadioButton<String>(
                value: 'B',
                groupValue: _radioVal,
                label: 'Opción B',
                onChanged: (val) => setState(() => _radioVal = val!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardsTab(DesignThemeExtension colors) {
    return ListView(
      padding: DesignSpacing.allM,
      children: [
        const DesignSectionHeader(title: 'Tarjetas Básicas'),
        DesignCard.basic(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tarjeta Básica', style: DesignTypography.titleMedium),
              DesignSpacing.spacerV8,
              Text('Tarjeta con bordes sutiles sin sombra.', style: DesignTypography.bodyMedium),
            ],
          ),
        ),
        DesignSpacing.spacerV16,
        DesignCard.elevated(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tarjeta Elevada', style: DesignTypography.titleMedium),
              DesignSpacing.spacerV8,
              Text('Tarjeta con elevación y sombras suaves.', style: DesignTypography.bodyMedium),
            ],
          ),
        ),
        DesignSpacing.spacerV24,
        const DesignSectionHeader(title: 'Tarjetas Contextuales'),
        DesignCard.info(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tarjeta Informativa', style: DesignTypography.titleMedium),
              DesignSpacing.spacerV8,
              Text('Tarjeta con fondo azul claro decorado.', style: DesignTypography.bodyMedium),
            ],
          ),
        ),
        DesignSpacing.spacerV16,
        DesignCard.status(
          statusColor: colors.success,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tarjeta de Estatus Exitoso', style: DesignTypography.titleMedium),
              DesignSpacing.spacerV8,
              Text('Tarjeta con borde verde de éxito.', style: DesignTypography.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackTab(BuildContext context, DesignThemeExtension colors) {
    return ListView(
      padding: DesignSpacing.allM,
      children: [
        const DesignSectionHeader(title: 'Chips e Insignias'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            const DesignChip(label: 'Etiqueta'),
            const DesignChip(label: 'Seleccionado', selected: true),
            const DesignChip(label: 'Con Icono', icon: Icons.tag_rounded),
            DesignBadge(label: 'Aprobado', color: colors.success),
            DesignBadge(label: 'Pendiente', color: colors.warning),
            DesignBadge(label: 'Cancelado', color: colors.danger),
          ],
        ),
        DesignSpacing.spacerV24,
        const DesignSectionHeader(title: 'Mensajes e Interacciones'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () => DesignSnackbar.showSuccess(context, 'Operación exitosa'),
              child: const Text('Snackbar Éxito'),
            ),
            ElevatedButton(
              onPressed: () => DesignSnackbar.showError(context, 'Ocurrió un error inesperado'),
              child: const Text('Snackbar Error'),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => DesignDialog(
                    title: 'Confirmar Acción',
                    content: '¿Estás seguro de que deseas procesar la orden actual?',
                    confirmLabel: 'Aceptar',
                    cancelLabel: 'Cancelar',
                    onConfirm: () {},
                  ),
                );
              },
              child: const Text('Mostrar Diálogo'),
            ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => DesignBottomSheet(
                    title: 'Opciones de Cuenta',
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_rounded),
                          title: const Text('Ver Perfil'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings_rounded),
                          title: const Text('Ajustes'),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Text('Mostrar Bottom Sheet'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => _showOverlay = true);
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) setState(() => _showOverlay = false);
                });
              },
              child: const Text('Probar Loading Overlay (2s)'),
            ),
          ],
        ),
        DesignSpacing.spacerV24,
        const DesignSectionHeader(title: 'Efectos de Carga (Skeleton)'),
        const DesignSkeletonLoader(height: 20),
        DesignSpacing.spacerV8,
        const DesignSkeletonLoader(height: 60),
        DesignSpacing.spacerV24,
        const DesignSectionHeader(title: 'Estados de Interfaz'),
        SizedBox(
          height: 220,
          child: const DesignEmptyState(
            title: 'No hay reportes disponibles',
            description: 'Intenta registrar un reporte de buses desde la pantalla principal.',
            icon: Icons.history_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationTab(BuildContext context) {
    return ListView(
      padding: DesignSpacing.allM,
      children: [
        const DesignSectionHeader(title: 'Elementos de Lista'),
        DesignListTile(
          title: 'Conductor Principal',
          subtitle: 'Ricardo Ramos - ID 48102',
          leading: const DesignAvatar(name: 'Ricardo Ramos'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () {},
        ),
        DesignSpacing.spacerV8,
        DesignListTile(
          title: 'Supervisor de Campo',
          subtitle: 'María Gómez - Activa',
          leading: const DesignAvatar(name: 'María Gómez'),
          trailing: const Icon(Icons.check_circle_rounded, color: Colors.green),
          onTap: () {},
        ),
        DesignSpacing.spacerV24,
        const DesignSectionHeader(title: 'Avatares'),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DesignAvatar(name: 'Usuario 1', size: 30),
            DesignAvatar(name: 'Usuario 2', size: 45),
            DesignAvatar(name: 'Usuario 3', size: 60),
          ],
        ),
        DesignSpacing.spacerV24,
        const DesignSectionHeader(title: 'Divisor Sutil'),
        const DesignDivider(),
      ],
    );
  }
}
