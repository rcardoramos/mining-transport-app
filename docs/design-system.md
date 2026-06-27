# Sistema de Diseño Corporativo - APP Buses

Este documento detalla la arquitectura visual, los tokens de diseño y los componentes reutilizables que conforman la identidad visual de la aplicación **APP Buses (Miski Mayo)**. 

El sistema de diseño ha sido desarrollado desde cero para ser escalable, accesible para conductores y supervisores en campo, rápido (animaciones bajo los 300ms) y altamente profesional.

---

## 1. Filosofía de Diseño

Inspirado en los principios de simplicidad y calidad de **Apple Human Interface Guidelines**, la robustez visual de **Uber Mobile**, la precisión de **Linear** y el flujo estructurado de **Rappi**:
* **Claridad**: Jerarquía visual fuerte y contraste maximizado (esencial para operaciones mineras a plena luz del día o nocturnas).
* **Rapidez**: Transiciones suaves y microinteracciones de presión que reducen la fricción cognitiva.
* **Seguridad y Confianza**: Colores corporativos sobrios combinados con alertas semánticas claras (Verde Aprobado, Naranja de Seguridad Industrial, Amarillo Advertencia, Rojo Peligro).

---

## 2. Tokens de Diseño (`lib/shared/design_system/tokens/`)

### A. Colores (`design_colors.dart`)
El sistema soporta de manera nativa y dinámica los temas **Light** y **Dark**:

| Nombre | Color Light | Color Dark | Uso |
| :--- | :--- | :--- | :--- |
| **Primary** | `0xFF0F4C5C` (Teal) | `0xFF1A6B7E` (Teal Claro) | Cabeceras, acciones principales, marca corporativa |
| **Secondary** | `0xFFE36414` (Safety Orange) | `0xFFF07B3F` (Orange) | Acciones de alerta, botones secundarios |
| **Success** | `0xFF2D6A4F` (Verde) | `0xFF27AE60` (Verde Claro) | Validaciones exitosas, check-ins de buses |
| **Warning** | `0xFFF5B041` (Amarillo) | `0xFFF39C12` (Amarillo Claro) | Alertas preventivas, retrasos leves |
| **Danger** | `0xFFC32F27` (Rojo) | `0xFFE74C3C` (Rojo Claro) | Errores críticos, cancelaciones de buses |
| **Info** | `0xFF2471A3` (Azul) | `0xFF2980B9` (Azul Claro) | Notas informativas, estados neutrales |
| **Background** | `0xFFF8F9FA` | `0xFF121212` | Fondo de pantallas |
| **Surface** | `Colors.white` | `0xFF1E1E1E` | Fondo de tarjetas, campos y menús |
| **Border** | `0xFFE5E8E8` | `0xFF2C3E50` | Líneas de división y bordes de inputs |

### B. Tipografía (`design_typography.dart`)
Utiliza la fuente del sistema de manera consistente para máxima legibilidad sin sobrecargar la memoria.

* **Display**: `36px`, negrita, altura de línea `1.2`. (Para pantallas de bienvenida o resúmenes grandes).
* **Headline**: `28px`, negrita, altura de línea `1.25`. (Títulos principales de pantalla).
* **Title Large**: `22px`, seminegrita, altura de línea `1.3`. (Títulos de tarjetas grandes).
* **Title Medium**: `18px`, seminegrita, altura de línea `1.3`. (Encabezados de sección y listas).
* **Body Large**: `16px`, normal, altura de línea `1.5`. (Texto principal de lectura).
* **Body Medium**: `14px`, normal, altura de línea `1.45`. (Texto secundario e inputs).
* **Label Large**: `14px`, seminegrita, altura de línea `1.2`. (Botones y enlaces).
* **Label Medium**: `12px`, mediana, altura de línea `1.2`. (Chips, etiquetas cortas).
* **Caption**: `11px`, normal, altura de línea `1.3`. (Notas pequeñas, horas y metadatos).

### C. Espaciado (`design_spacing.dart`)
Basado en un sistema proporcional a **múltiplos de 4**:
* `xs`: 4.0 | `s`: 8.0 | `sm`: 12.0 | `m`: 16.0 | `ml`: 20.0 | `l`: 24.0 | `xl`: 32.0 | `xxl`: 40.0 | `xxxl`: 48.0 | `huge`: 64.0
* Proporciona espaciadores verticales/horizontales rápidos: `DesignSpacing.spacerV16` o paddings predefinidos como `DesignSpacing.allM`.

### D. Bordes Redondeados (`design_radius.dart`)
* `small`: 4.0 (Checkboxes, badges cortas)
* `medium`: 8.0 (Botones, campos de texto, inputs)
* `large`: 12.0 (Tarjetas, cuadros de diálogo, bottom sheets)
* `extraLarge`: 16.0 (Componentes especiales o modales superiores)
* `circular`: 999.0 (Avatares, pastillas de estatus)

### E. Elevación (`design_elevation.dart`)
Sombras optimizadas y sutiles para jerarquizar capas:
* `none`: Sin sombras (Diseño plano minimalista).
* `level1`: Sombra extremadamente sutil para elementos interactivos en reposo.
* `level2`: Sombra media para tarjetas y cabeceras flotantes.
* `level3`: Sombra pronunciada para cuadros de diálogo y modales interactivos.

---

## 3. Componentes Reutilizables

Todos los componentes son **Stateless**, desacoplados de la lógica de negocio y se importan fácilmente mediante el archivo barril.

### Botones (`buttons.dart`)
* `DesignButton.primary`: Botón principal con fondo de color primary de la aplicación.
* `DesignButton.secondary`: Botón de acción secundaria o alertas.
* `DesignButton.outlined`: Botón transparente con bordes de color principal.
* `DesignButton.text`: Botón minimalista de solo texto.
* `DesignIconButton`: Botón circular con icono con microinteracción de escala.

### Tarjetas (`cards.dart`)
* `DesignCard.basic`: Borde sutil sin sombras.
* `DesignCard.elevated`: Bordes redondeados con sombra de `level2`.
* `DesignCard.info`: Fondo y bordes en tonos celestes corporativos.
* `DesignCard.status`: Recibe un `statusColor` y colorea sutilmente el borde y el fondo para representar estatus (Aprobado, Cancelado, etc.).

### Entradas de Datos (`inputs.dart`)
* `DesignTextField`: Campo de entrada de texto optimizado.
* `DesignPasswordField`: Incorpora el botón de mostrar/ocultar contraseña.
* `DesignSearchField`: Campo de búsqueda con icono de lupa y botón para borrar texto.
* `DesignDropdown`: Campo selector de menú desplegable.
* `DesignDatePicker` / `DesignTimePicker`: Selectores nativos envueltos en la estética de inputs de la aplicación.
* `DesignSwitch` / `DesignCheckbox` / `DesignRadioButton`: Interruptores y selectores unificados.

### Retroalimentación (`feedback.dart`)
* `DesignChip`: Etiquetas interactivas redondeadas.
* `DesignBadge`: Etiquetas informativas de estatus coloreadas.
* `DesignSnackbar`: Notificaciones flotantes tipo banner (`showSuccess`, `showError`, `showWarning`, `showInfo`).
* `DesignDialog`: Ventanas modales de alerta o confirmación de doble acción.
* `DesignBottomSheet`: Paneles deslizantes inferiores con tirador de arrastre integrado.
* `DesignLoadingOverlay`: Velo bloqueador de pantalla completa con cargador circular.
* `DesignSkeletonLoader`: Caja shimmer simuladora de carga de datos.
* `DesignEmptyState` / `DesignErrorState` / `DesignSuccessState`: Pantallas prediseñadas para flujos sin datos, errores o finalización de procesos.

---

## 4. Animaciones (`lib/shared/design_system/animations/`)

Todas las animaciones están limitadas a un tiempo máximo de **300ms a 350ms** para evitar la fatiga visual del usuario en campo:
1. **FadeInAnimation**: Desvanecimiento suave en la carga de componentes.
2. **SlideInAnimation**: Desplazamiento desde una posición offset hacia su posición final.
3. **ScaleAnimation**: Entrada en escala estilo modal de iOS.
4. **ButtonPressAnimation**: Microinteracción que escala el widget a `0.95` al presionarse para dar una sensación táctil realista.
5. **ShimmerAnimation**: Barrido de degradado infinito para esqueletos de carga.

---

## 5. Instrucciones de Uso y Ejemplo Práctico

Para implementar componentes en cualquier pantalla futura de la aplicación, solo necesitas realizar una importación simple:

```dart
import 'package:mining_transport_app/shared/design_system/design_system.dart';

// Ejemplo de formulario con componentes del sistema
class FormularioBus extends StatelessWidget {
  const FormularioBus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DesignAppBar(title: 'Registrar Bus'),
      body: SingleChildScrollView(
        padding: DesignSpacing.allM,
        child: Column(
          children: [
            const DesignTextField(
              labelText: 'Placa del Bus',
              hintText: 'Ej. ABC-123',
            ),
            DesignSpacing.spacerV16,
            DesignButton.primary(
              text: 'Guardar Registro',
              onTap: () {
                DesignSnackbar.showSuccess(context, 'Bus registrado correctamente');
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 6. Catálogo Interactivo (Preview)
Puedes ver y probar la colección completa de componentes, verificar contrastes e interactuar con los modos claro y oscuro en tiempo real en la siguiente ruta:
* **Ruta de previsualización**: `/design-system-preview`
* **Definición en**: `lib/features/auth/presentation/pages/design_system_preview.dart`
