import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';

/// Pantalla de escaneo de códigos QR y códigos de barras (DNI/Fotocheck).
///
/// Mitiga lecturas erróneas del DNI peruano (PDF417 / Code39) exigiendo
/// consenso entre varios frames antes de devolver el DNI.
class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage>
    with SingleTickerProviderStateMixin {
  /// Resolución baja (640x480) es el default de Android en mobile_scanner y
  /// provoca lecturas corruptas en barcodes del DNIe (ej. 1→8, 7→4).
  final MobileScannerController controller = MobileScannerController(
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.normal,
    detectionTimeoutMs: 120,
    cameraResolution: const Size(1920, 1080),
    formats: const [
      BarcodeFormat.pdf417,
      BarcodeFormat.qrCode,
      BarcodeFormat.code39,
      BarcodeFormat.code128,
    ],
  );

  late AnimationController _animationController;
  late Animation<double> _animation;

  /// Conteos por DNI extraído para exigir lecturas consistentes.
  final Map<String, int> _dniVotes = <String, int>{};
  String? _leadingCandidate;
  int _leadingVotes = 0;

  bool _isHandling = false;
  static const int _requiredVotes = 3;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Extrae un DNI de 8 dígitos según el formato del código leído.
  ///
  /// Devuelve `null` si el payload no es confiable (evita aceptar basura).
  String? _extractDni(String rawCode, BarcodeFormat format) {
    final clean = rawCode.trim();
    if (clean.isEmpty) return null;

    // Caso 1: QR / Code39 / Code128 limpio de 8 dígitos (fotocheck o CUI lineal)
    final digitsOnly = clean.replaceAll(RegExp(r'[^0-9]'), '');
    if (format == BarcodeFormat.qrCode ||
        format == BarcodeFormat.code39 ||
        format == BarcodeFormat.code128) {
      if (RegExp(r'^\d{8}$').hasMatch(clean)) return clean;
      // Code39 a veces viene con asteriscos u otros separadores.
      if (RegExp(r'^\d{8}$').hasMatch(digitsOnly)) return digitsOnly;
    }

    // Caso 2: PDF417 RENIEC — empieza con tipo doc "01" + DNI (8 dígitos).
    // El payload real mide cientos de caracteres; anclar al inicio evita
    // capturar un "01########" falso dentro de un decode corrupto.
    final isPdf417 = format == BarcodeFormat.pdf417 || clean.length > 50;
    if (isPdf417) {
      final anchored = RegExp(r'^01(\d{8})').firstMatch(clean);
      if (anchored != null) return anchored.group(1)!;

      // Algunos lectores insertan BOM/espacios al inicio.
      final looseStart = RegExp(r'^\s*01(\d{8})').firstMatch(clean);
      if (looseStart != null && clean.length > 80) {
        return looseStart.group(1)!;
      }
    }

    // Caso 3: QR/fotocheck exacto de 8 dígitos (formato desconocido)
    if (clean.length == 8 && RegExp(r'^\d{8}$').hasMatch(clean)) {
      return clean;
    }

    // Caso 4: MRZ (I<PER########...)
    final mrzMatch = RegExp(r'I<PER(\d{8})').firstMatch(clean);
    if (mrzMatch != null) return mrzMatch.group(1)!;

    // Caso 5: Fallback solo en payloads cortos (no en PDF417 parcial/corrupto)
    if (clean.length <= 24) {
      final match = RegExp(
        r'\d{8}',
      ).firstMatch(digitsOnly.isNotEmpty ? digitsOnly : clean);
      if (match != null) return match.group(0)!;
    }

    return null;
  }

  int _formatPriority(BarcodeFormat format) {
    // Preferir PDF417 (RF-PSG-01) sobre el Code39 lineal, que es más propenso
    // a lecturas erróneas con reflejo / baja resolución.
    switch (format) {
      case BarcodeFormat.pdf417:
        return 3;
      case BarcodeFormat.qrCode:
        return 2;
      case BarcodeFormat.code39:
      case BarcodeFormat.code128:
        return 1;
      default:
        return 0;
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isHandling || !mounted) return;

    // Elegir el mejor barcode del frame (PDF417 > QR > 1D).
    Barcode? best;
    String? bestDni;
    var bestPriority = -1;

    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue?.trim();
      if (raw == null || raw.isEmpty) continue;

      final dni = _extractDni(raw, barcode.format);
      if (dni == null) continue;

      final priority = _formatPriority(barcode.format);
      if (priority > bestPriority) {
        bestPriority = priority;
        best = barcode;
        bestDni = dni;
      }
    }

    if (best == null || bestDni == null) return;

    final votes = (_dniVotes[bestDni] ?? 0) + 1;
    _dniVotes[bestDni] = votes;

    if (votes > _leadingVotes) {
      _leadingCandidate = bestDni;
      _leadingVotes = votes;
      if (mounted) setState(() {});
    }

    if (votes < _requiredVotes) return;

    _isHandling = true;
    await controller.stop();

    if (!mounted) return;
    Navigator.pop(context, bestDni);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? DesignColors.primaryDark
        : DesignColors.primaryLight;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(controller: controller, onDetect: _onDetect),

          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;
                // Ventana ancha: el PDF417 del DNIe es horizontal, no cuadrado.
                final cutoutWidth = width * 0.88;
                final cutoutHeight = cutoutWidth * 0.55;
                final left = (width - cutoutWidth) / 2;
                final top = (height - cutoutHeight) / 2;

                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(width, height),
                      painter: ScannerOverlayPainter(
                        cutoutRect: Rect.fromLTWH(
                          left,
                          top,
                          cutoutWidth,
                          cutoutHeight,
                        ),
                        borderRadius: 20,
                        overlayColor: Colors.black.withOpacity(0.65),
                      ),
                    ),

                    Positioned(
                      left: left - 2,
                      top: top - 2,
                      width: cutoutWidth + 4,
                      height: cutoutHeight + 4,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: primaryColor, width: 3.0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        final laserTop =
                            top + (cutoutHeight * _animation.value);
                        return Positioned(
                          left: left + 16,
                          top: laserTop,
                          width: cutoutWidth - 32,
                          height: 3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.6),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    Positioned(
                      left: 32,
                      right: 32,
                      top: top - 96,
                      child: Center(
                        child: Text(
                          'Enfoca el código PDF417 o el código de barras del DNI / fotocheck. Evita reflejos.',
                          textAlign: TextAlign.center,
                          style: DesignTypography.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),

                    if (_leadingCandidate != null && !_isHandling)
                      Positioned(
                        left: 32,
                        right: 32,
                        top: top + cutoutHeight + 24,
                        child: Center(
                          child: Text(
                            'Leyendo $_leadingCandidate ($_leadingVotes/$_requiredVotes)',
                            textAlign: TextAlign.center,
                            style: DesignTypography.bodyMedium.copyWith(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 20,
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                Row(
                  children: [
                    ValueListenableBuilder<MobileScannerState>(
                      valueListenable: controller,
                      builder: (context, state, child) {
                        final isFlashOn = state.torchState == TorchState.on;
                        return GestureDetector(
                          onTap: () => controller.toggleTorch(),
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 20,
                            child: Icon(
                              isFlashOn
                                  ? Icons.flash_on_rounded
                                  : Icons.flash_off_rounded,
                              color: isFlashOn ? Colors.yellow : Colors.white,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => controller.switchCamera(),
                      child: const CircleAvatar(
                        backgroundColor: Colors.black54,
                        radius: 20,
                        child: Icon(
                          Icons.flip_camera_ios_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final Rect cutoutRect;
  final double borderRadius;
  final Color overlayColor;

  ScannerOverlayPainter({
    required this.cutoutRect,
    required this.borderRadius,
    required this.overlayColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    final outerPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final innerPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(cutoutRect, Radius.circular(borderRadius)),
      );

    final path = Path.combine(PathOperation.difference, outerPath, innerPath);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return oldDelegate.cutoutRect != cutoutRect ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.overlayColor != overlayColor;
  }
}
