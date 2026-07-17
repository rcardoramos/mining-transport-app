import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:mining_transport_app/features/home/domain/entities/trip_entity.dart';
import 'package:mining_transport_app/features/home/domain/entities/passenger_entity.dart';
import 'package:mining_transport_app/core/utils/date_formatter.dart';

class PdfService {
  Future<Uint8List> generateManifestPdf({
    required TripEntity trip,
    required List<PassengerEntity> passengers,
    required String driverName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'COMPANIA MINERA MISKI MAYO',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'MANIFIESTO DE PASAJEROS',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Divider(thickness: 1.5),
                ],
              ),
            ),
            pw.SizedBox(height: 12),

            // Metadata Table
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400, width: 1),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildMetaRow('Ruta:', trip.route),
                  _buildMetaRow('Fecha:', PeruDateFormatter.formatDate(trip.scheduledTime)),
                  _buildMetaRow('Servicio:', 'Operativo'),
                  _buildMetaRow('Horario:', '${trip.shift} ${PeruDateFormatter.formatTime(trip.scheduledTime)}'),
                  _buildMetaRow('Placa:', trip.unitCode),
                  _buildMetaRow('Capacidad:', '${trip.passengerCount} de ${trip.capacity} pax'),
                  _buildMetaRow('Chofer:', driverName),
                  _buildMetaRow('Apertura:', PeruDateFormatter.formatTime12(trip.startedAt)),
                  _buildMetaRow('Cierre:', PeruDateFormatter.formatTime12(trip.completedAt)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Passengers Title
            pw.Text(
              'Pasajeros Registrados (${passengers.length})',
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),

            // Passengers Table
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
              columnWidths: const {
                0: pw.FixedColumnWidth(30), // N°
                1: pw.FlexColumnWidth(3),   // Nombre
                2: pw.FixedColumnWidth(70), // DNI
                3: pw.FlexColumnWidth(1.5), // Categoria
                4: pw.FixedColumnWidth(60), // Hora
              },
              children: [
                // Header Row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _buildCell('N°', isHeader: true),
                    _buildCell('Nombre Completo', isHeader: true),
                    _buildCell('DNI', isHeader: true),
                    _buildCell('Categoría', isHeader: true),
                    _buildCell('Hora de Abordaje', isHeader: true),
                  ],
                ),
                // Data Rows
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

  pw.Widget _buildMetaRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 80,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: const pw.TextStyle(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 9 : 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }
}
