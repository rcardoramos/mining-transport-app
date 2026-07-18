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
  final MobileScannerController controller = MobileScannerController();
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
                    Navigator.pop(context, code);
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
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.65),
                        BlendMode.srcOut,
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ],
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
