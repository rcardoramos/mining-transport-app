import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';

/// Pantalla de escaneo de códigos QR y códigos de barras (DNI/Fotocheck).
/// Implementa un visor de cámara nativo con overlays animados de alta gama.
class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController(
    formats: [
      BarcodeFormat.qrCode,
      BarcodeFormat.pdf417,
    ],
    detectionSpeed: DetectionSpeed.unrestricted,
  );
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _extractDni(String rawCode) {
    // Buscar la primera secuencia de 8 dígitos consecutivos (DNI estándar de Perú)
    final regex = RegExp(r'\d{8}');
    final match = regex.firstMatch(rawCode);
    if (match != null) {
      return match.group(0)!;
    }
    return rawCode;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? DesignColors.primaryDark : DesignColors.primaryLight;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Visor de Cámara de MobileScanner
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  final String code = barcode.rawValue!.trim();
                  if (code.isNotEmpty) {
                    final cleanCode = _extractDni(code);
                    Navigator.pop(context, cleanCode);
                    break;
                  }
                }
              }
            },
          ),

          // 2. Máscara de sombreado y visor de escaneo premium
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;
                final size = width * 0.72; // Tamaño del recuadro
                final left = (width - size) / 2;
                final top = (height - size) / 2;

                return Stack(
                  children: [
                    // Capa translúcida exterior para centrar la atención en el recuadro
                    CustomPaint(
                      size: Size(width, height),
                      painter: ScannerOverlayPainter(
                        cutoutRect: Rect.fromLTWH(left, top, size, size),
                        borderRadius: 24,
                        overlayColor: Colors.black.withOpacity(0.65),
                      ),
                    ),

                    // Marco guía iluminado con bordes redondeados
                    Positioned(
                      left: left - 2,
                      top: top - 2,
                      width: size + 4,
                      height: size + 4,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: primaryColor,
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),

                    // Línea láser animada de barrido de escaneo
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        final laserTop = top + (size * _animation.value);
                        return Positioned(
                          left: left + 16,
                          top: laserTop,
                          width: size - 32,
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

                    // Texto de guía al usuario
                    Positioned(
                      left: 32,
                      right: 32,
                      top: top - 80,
                      child: Center(
                        child: Text(
                          'Ubica el código QR o código de barras de tu Fotocheck dentro del recuadro para escanear',
                          textAlign: TextAlign.center,
                          style: DesignTypography.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 3. Controles superiores (Atrás, Linterna y Voltear Cámara)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botón Cerrar/Atrás
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(
                    backgroundColor: Colors.black54,
                    radius: 20,
                    child: Icon(Icons.close_rounded, color: Colors.white, size: 22),
                  ),
                ),
                
                // Controles de cámara
                Row(
                  children: [
                    // Botón para alternar la Linterna (Flash)
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
                              isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                              color: isFlashOn ? Colors.yellow : Colors.white,
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    
                    // Botón para rotar de cámara (Frontal/Trasera)
                    GestureDetector(
                      onTap: () => controller.switchCamera(),
                      child: const CircleAvatar(
                        backgroundColor: Colors.black54,
                        radius: 20,
                        child: Icon(Icons.flip_camera_ios_rounded, color: Colors.white, size: 18),
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

    final outerPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final innerPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        cutoutRect,
        Radius.circular(borderRadius),
      ));

    // Path.combine con PathOperation.difference sustrae el rectángulo interior del exterior,
    // garantizando un área de corte 100% transparente en cualquier dispositivo.
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
