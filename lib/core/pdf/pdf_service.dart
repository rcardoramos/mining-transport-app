import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/passenger/domain/entities/passenger_entity.dart';
import 'package:mining_transport_app/core/utils/date_formatter.dart';

class PdfService {
  Future<Uint8List> generateManifestPdf({
    required TripEntity trip,
    required List<PassengerEntity> passengers,
    required String driverName,
    String? driverDni,
    String? driverLicense,
    String? tripStatusLabel,
    DateTime? generatedAt,
  }) async {
    final pdf = pw.Document();
    final status = tripStatusLabel ??
        (trip.status == TripStatus.completed ? 'FINALIZADO' : 'EN CURSO');
    final generated = generatedAt ?? DateTime.now();

    final hasLicense =
        driverLicense != null && driverLicense.trim().isNotEmpty;
    final hasDni = driverDni != null && driverDni.trim().isNotEmpty;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'COMPANIA MINERA MISKI MAYO',
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'MANIFIESTO DE PASAJEROS',
                    style: pw.TextStyle(
                      fontSize: 13,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Divider(thickness: 1.2, color: PdfColors.grey700),
                ],
              ),
            ),
            pw.SizedBox(height: 10),

            // DATOS DEL CONDUCTOR
            _sectionHeader('DATOS DEL CONDUCTOR'),
            _borderedGrid(
              children: [
                _fieldCell(
                  'NOMBRES Y APELLIDOS:',
                  driverName,
                  flex: 3,
                ),
                if (hasLicense)
                  _fieldCell(
                    'LICENCIA DE CONDUCIR N°:',
                    driverLicense!.trim(),
                    flex: 2,
                  ),
                if (hasDni)
                  _fieldCell(
                    'DNI CHOFER:',
                    driverDni!.trim(),
                    flex: 2,
                  ),
                if (!hasLicense && !hasDni)
                  _fieldCell('LICENCIA / DNI:', '—', flex: 2),
              ],
            ),
            pw.SizedBox(height: 8),

            // DATOS DEL VEHÍCULO
            _sectionHeader('DATOS DEL VEHÍCULO'),
            _borderedGrid(
              children: [
                _fieldCell('PLACA:', trip.unitCode, flex: 2),
                _fieldCell(
                  'CAPACIDAD:',
                  '${passengers.length} de ${trip.capacity} pax',
                  flex: 2,
                ),
                _fieldCell('VIAJE:', trip.id, flex: 2),
                _fieldCell('ESTADO:', status, flex: 2),
              ],
            ),
            pw.SizedBox(height: 8),

            // DATOS DEL VIAJE
            _sectionHeader('DATOS DEL VIAJE'),
            _borderedGrid(
              children: [
                _fieldCell('RUTA:', trip.route, flex: 3),
                _fieldCell(
                  'FECHA:',
                  PeruDateFormatter.formatDate(trip.scheduledTime),
                  flex: 2,
                ),
              ],
            ),
            _borderedGrid(
              children: [
                _fieldCell('SERVICIO:', 'Operativo', flex: 2),
                _fieldCell(
                  'HORARIO:',
                  '${trip.shift} ${PeruDateFormatter.formatTime(trip.scheduledTime)}',
                  flex: 2,
                ),
                _fieldCell(
                  'APERTURA:',
                  PeruDateFormatter.formatTime12(trip.startedAt),
                  flex: 2,
                ),
                _fieldCell(
                  'CIERRE:',
                  PeruDateFormatter.formatTime12(trip.completedAt),
                  flex: 2,
                ),
              ],
            ),
            _borderedGrid(
              children: [
                _fieldCell(
                  'GENERADO:',
                  '${PeruDateFormatter.formatDate(generated)} ${PeruDateFormatter.formatTime(generated)}',
                  flex: 1,
                ),
              ],
            ),
            pw.SizedBox(height: 12),

            // DATOS GENERALES (pasajeros)
            _sectionHeader(
              'DATOS GENERALES — PASAJEROS REGISTRADOS (${passengers.length})',
            ),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey700, width: 0.7),
              columnWidths: const {
                0: pw.FixedColumnWidth(32),
                1: pw.FlexColumnWidth(3.2),
                2: pw.FixedColumnWidth(68),
                3: pw.FlexColumnWidth(1.6),
                4: pw.FixedColumnWidth(58),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _buildCell('ITEM', isHeader: true),
                    _buildCell('NOMBRES Y APELLIDOS', isHeader: true),
                    _buildCell('D.N.I.', isHeader: true),
                    _buildCell('COMPAÑÍA', isHeader: true),
                    _buildCell('HORA', isHeader: true),
                  ],
                ),
                if (passengers.isEmpty)
                  pw.TableRow(
                    children: [
                      _buildCell('—'),
                      _buildCell('Sin pasajeros registrados'),
                      _buildCell('—'),
                      _buildCell('—'),
                      _buildCell('—'),
                    ],
                  )
                else
                  ...List.generate(passengers.length, (index) {
                    final p = passengers[index];
                    return pw.TableRow(
                      children: [
                        _buildCell('${index + 1}'),
                        _buildCell(p.fullName),
                        _buildCell(p.dni),
                        _buildCell(p.category),
                        _buildCell(PeruDateFormatter.formatTime(p.boardedAt)),
                      ],
                    );
                  }),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _sectionHeader(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey700,
        border: pw.Border(
          left: pw.BorderSide(color: PdfColors.grey800, width: 0.7),
          right: pw.BorderSide(color: PdfColors.grey800, width: 0.7),
          top: pw.BorderSide(color: PdfColors.grey800, width: 0.7),
        ),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _borderedGrid({required List<pw.Widget> children}) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey700, width: 0.7),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  pw.Widget _fieldCell(
    String label,
    String value, {
    int flex = 1,
  }) {
    return pw.Expanded(
      flex: flex,
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: const pw.BoxDecoration(
          border: pw.Border(
            right: pw.BorderSide(color: PdfColors.grey400, width: 0.4),
          ),
        ),
        child: pw.RichText(
          text: pw.TextSpan(
            children: [
              pw.TextSpan(
                text: '$label ',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.TextSpan(
                text: value,
                style: const pw.TextStyle(fontSize: 8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  pw.Widget _buildCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 8 : 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
