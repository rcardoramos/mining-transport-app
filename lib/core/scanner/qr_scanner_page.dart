import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mining_transport_app/shared/design_system/design_system.dart';

/// Resultado de un abordaje disparado desde el escáner continuo.
class ContinuousScanFeedback {
  const ContinuousScanFeedback({
    required this.success,
    required this.message,
    this.detail,
  });

  final bool success;
  final String message;
  final String? detail;
}

/// Pantalla de escaneo de códigos QR y códigos de barras (DNI/Fotocheck).
///
/// Mitiga lecturas erróneas del DNI peruano (PDF417 / Code39) exigiendo
/// consenso entre varios frames antes de aceptar el código.
///
/// Con [continuous] = true la cámara permanece abierta y llama a
/// [onContinuousScan] en cada lectura válida.
class QrScannerPage extends StatefulWidget {
  const QrScannerPage({
    super.key,
    this.continuous = false,
    this.onContinuousScan,
  });

  /// Si es true, no cierra la pantalla tras cada lectura.
  final bool continuous;

  /// Procesa el código y devuelve feedback para mostrar sobre la cámara.
  final Future<ContinuousScanFeedback> Function(String code)? onContinuousScan;

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage>
    with SingleTickerProviderStateMixin {
  /// Resolución baja (640x480) es el default de Android en mobile_scanner y
  /// provoca lecturas corruptas en barcodes del DNIe (ej. 1→8, 7→4).
  final MobileScannerController controller = MobileScannerController(
    facing: CameraFacing.back,
    // unrestricted: más frames → consenso de votos más rápido.
    // El cooldown propio evita re-aceptar el mismo código al instante.
    detectionSpeed: DetectionSpeed.unrestricted,
    detectionTimeoutMs: 50,
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
  bool _isProcessing = false;
  ContinuousScanFeedback? _lastFeedback;
  String? _lastAcceptedCode;
  DateTime? _lastAcceptedAt;

  /// 2 frames consistentes: más rápido que 3, aún evita lecturas sueltas.
  static const int _requiredVotes = 2;
  static const Duration _sameCodeCooldown = Duration(milliseconds: 2200);
  static const Duration _successBanner = Duration(milliseconds: 900);
  static const Duration _errorBanner = Duration(milliseconds: 1300);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1600),
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

  /// Extrae un identificador usable según el formato del código leído.
  String? _extractDni(String rawCode, BarcodeFormat format) {
    final clean = rawCode.trim();
    if (clean.isEmpty) return null;

    final digitsOnly = clean.replaceAll(RegExp(r'[^0-9]'), '');

    if (format == BarcodeFormat.qrCode ||
        format == BarcodeFormat.code39 ||
        format == BarcodeFormat.code128) {
      if (RegExp(r'^\d{8}$').hasMatch(clean)) return clean;
      if (RegExp(r'^\d{8}$').hasMatch(digitsOnly)) return digitsOnly;

      if (format == BarcodeFormat.code39 || format == BarcodeFormat.code128) {
        if (RegExp(r'^\d{4,10}$').hasMatch(clean)) return clean;
        if (clean.length <= 16 && RegExp(r'^\d{4,10}$').hasMatch(digitsOnly)) {
          return digitsOnly;
        }
      }
    }

    final isPdf417 = format == BarcodeFormat.pdf417 || clean.length > 50;
    if (isPdf417) {
      final anchored = RegExp(r'^01(\d{8})').firstMatch(clean);
      if (anchored != null) return anchored.group(1)!;

      final looseStart = RegExp(r'^\s*01(\d{8})').firstMatch(clean);
      if (looseStart != null && clean.length > 80) {
        return looseStart.group(1)!;
      }
    }

    if (clean.length == 8 && RegExp(r'^\d{8}$').hasMatch(clean)) {
      return clean;
    }

    final mrzMatch = RegExp(r'I<PER(\d{8})').firstMatch(clean);
    if (mrzMatch != null) return mrzMatch.group(1)!;

    if (clean.length <= 24) {
      final match = RegExp(
        r'\d{8}',
      ).firstMatch(digitsOnly.isNotEmpty ? digitsOnly : clean);
      if (match != null) return match.group(0)!;
    }

    return null;
  }

  int _formatPriority(BarcodeFormat format) {
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

  void _resetVotes() {
    _dniVotes.clear();
    _leadingCandidate = null;
    _leadingVotes = 0;
  }

  bool _isInSameCodeCooldown(String code) {
    if (_lastAcceptedCode != code || _lastAcceptedAt == null) return false;
    return DateTime.now().difference(_lastAcceptedAt!) < _sameCodeCooldown;
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isHandling || !mounted) return;

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
    if (_isInSameCodeCooldown(bestDni)) return;

    final votes = (_dniVotes[bestDni] ?? 0) + 1;
    _dniVotes[bestDni] = votes;

    if (votes > _leadingVotes) {
      _leadingCandidate = bestDni;
      _leadingVotes = votes;
      if (mounted) setState(() {});
    }

    if (votes < _requiredVotes) return;

    _isHandling = true;
    _lastAcceptedCode = bestDni;
    _lastAcceptedAt = DateTime.now();
    _resetVotes();

    if (widget.continuous && widget.onContinuousScan != null) {
      await _handleContinuousAccept(bestDni);
      return;
    }

    await controller.stop();
    if (!mounted) return;
    Navigator.pop(context, bestDni);
  }

  Future<void> _handleContinuousAccept(String code) async {
    HapticFeedback.lightImpact();
    if (mounted) {
      setState(() {
        _isProcessing = true;
        _lastFeedback = null;
      });
    }

    ContinuousScanFeedback feedback;
    final processSw = Stopwatch()..start();
    try {
      feedback = await widget.onContinuousScan!(code);
    } catch (_) {
      feedback = const ContinuousScanFeedback(
        success: false,
        message: 'Error al procesar el escaneo',
      );
    }
    processSw.stop();
    debugPrint(
      '[BOARDING_TIMING] scanner_callback code=$code '
      'success=${feedback.success} process=${processSw.elapsedMilliseconds}ms',
    );

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
      _lastFeedback = feedback;
    });

    if (feedback.success) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }

    await Future<void>.delayed(
      feedback.success ? _successBanner : _errorBanner,
    );

    if (!mounted) return;
    setState(() => _lastFeedback = null);
    _isHandling = false;
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
                          widget.continuous
                              ? 'Escáner continuo: enfoca DNI o fotocheck. Cierra con X al terminar.'
                              : 'Enfoca el PDF417 del DNI o el código de barras del fotocheck. Evita reflejos.',
                          textAlign: TextAlign.center,
                          style: DesignTypography.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),

                    if (_leadingCandidate != null &&
                        !_isHandling &&
                        !_isProcessing)
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

          if (_isProcessing || _lastFeedback != null)
            Positioned(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).padding.bottom + 28,
              child: _buildStatusBanner(),
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
                if (widget.continuous)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'MODO CONTINUO',
                      style: DesignTypography.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4,
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

  Widget _buildStatusBanner() {
    if (_isProcessing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Validando colaborador…',
                style: DesignTypography.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final feedback = _lastFeedback!;
    final bg = feedback.success
        ? const Color(0xFF1B5E20)
        : const Color(0xFFB71C1C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            feedback.success
                ? Icons.check_circle_rounded
                : Icons.error_outline_rounded,
            color: Colors.white,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  feedback.message,
                  style: DesignTypography.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (feedback.detail != null &&
                    feedback.detail!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    feedback.detail!,
                    style: DesignTypography.caption.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
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
