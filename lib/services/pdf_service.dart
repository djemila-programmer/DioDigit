import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../services/history_service.dart';
import '../services/anomaly_service.dart';
import '../services/farm_service.dart';

/// Real PDF report generation service for biodigester monitoring reports.
class PdfService {
  /// Generate a full biodigester report as PDF.
  Future<pw.Document> generateReport({
    required FarmData farm,
    required ProductionSummary production,
    required AnomalyReport anomaly,
    required List<HistoryPoint> historyData,
    required String period, // daily, weekly, monthly, annual
  }) async {
    final pdf = pw.Document();
    final now = DateFormat('dd/MM/yyyy HH:mm', 'fr_FR').format(DateTime.now());
    final periodLabel = _periodLabel(period);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          // ─── Header ─────────────────────────────────────────────────
          pw.Header(
            level: 0,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('BioSmart Africa',
                        style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Rapport Biodigesteur — $periodLabel',
                        style: const pw.TextStyle(fontSize: 14)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Généré le $now', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text('Plateau Central, Burkina Faso',
                        style: const pw.TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),

          // ─── Farm Information ───────────────────────────────────────
          pw.Header(level: 1, text: '1. Informations de la Ferme'),
          pw.Paragraph(text: 'Nom: ${farm.name}'),
          pw.Paragraph(text: 'Localisation: ${farm.location}'),
          pw.Paragraph(text: 'Type de biodigesteur: ${farm.biodigesterType}'),
          pw.Paragraph(text: 'Capacité: ${farm.biodigesterCapacity} m³'),
          pw.Paragraph(text: 'Statut: ${farm.status}'),
          pw.SizedBox(height: 10),

          // ─── Production Summary ─────────────────────────────────────
          pw.Header(level: 1, text: '2. Production de Biogaz'),
          pw.Table.fromTextArray(
            headers: ['Métrique', 'Valeur', 'Unité'],
            data: [
              ['Volume produit', production.volume.toStringAsFixed(1), 'm³'],
              ['Efficacité', production.efficiency.toStringAsFixed(1), '%'],
              ['Énergie générée', production.energyGenerated.toStringAsFixed(1), 'kWh'],
              ['Réduction CO₂', production.co2Reduction.toStringAsFixed(2), 'tons'],
              ['Nombre de relevés', production.readingCount.toString(), ''],
            ],
          ),
          pw.SizedBox(height: 10),

          // ─── Sensor Summary ─────────────────────────────────────────
          pw.Header(level: 1, text: '3. Analyse des Capteurs'),
          pw.Table.fromTextArray(
            headers: ['Capteur', 'Valeur', 'Statut', 'Message'],
            data: anomaly.sensorResults.map((r) => [
              '${r.sensorName} (${r.sensorId})',
              '${r.value.toStringAsFixed(1)} ${r.unit}',
              r.status,
              r.message,
            ]).toList(),
          ),
          pw.SizedBox(height: 10),

          // ─── Anomaly Analysis ───────────────────────────────────────
          pw.Header(level: 1, text: '4. Détection d\'Anomalies'),
          pw.Paragraph(text: 'Score de santé: ${anomaly.healthScore}/100'),
          pw.Paragraph(text: 'Score de risque: ${anomaly.riskScore}/100'),
          pw.Paragraph(text: 'Niveau de sévérité: ${anomaly.severityLevel}'),
          pw.Paragraph(text: 'Confiance de prédiction: ${anomaly.predictionConfidence.toStringAsFixed(1)}%'),
          pw.Paragraph(text: 'Anomalies détectées: ${anomaly.sensorAnomalies}'),
          pw.SizedBox(height: 10),

          // ─── Recommended Actions ────────────────────────────────────
          pw.Header(level: 1, text: '5. Actions Recommandées'),
          ...anomaly.actions.map((action) => pw.Paragraph(
            text: '• [${action.priority}] ${action.title} — ${action.description}',
          )),
          pw.SizedBox(height: 10),

          // ─── Livestock ──────────────────────────────────────────────
          pw.Header(level: 1, text: '6. Bétail'),
          pw.Table.fromTextArray(
            headers: ['Type', 'Quantité'],
            data: [
              ['Vaches', farm.cows.toString()],
              ['Porcs', farm.pigs.toString()],
              ['Chèvres', farm.goats.toString()],
              ['Volaille', farm.poultry.toString()],
            ],
          ),
          pw.SizedBox(height: 20),

          // ─── History Data Table (last 20 readings) ──────────────────
          if (historyData.isNotEmpty) ...[
            pw.Header(level: 1, text: '7. Historique des Relevés'),
            pw.Table.fromTextArray(
              headers: ['Date/Heure', 'Temp (°C)', 'Pression (bar)', 'CH₄ (ppm)', 'Lisier (%)'],
              data: historyData.take(20).map((h) => [
                DateFormat('dd/MM HH:mm').format(h.timestamp),
                h.temperature.toStringAsFixed(1),
                h.pressure.toStringAsFixed(2),
                h.methane.toStringAsFixed(0),
                h.slurryLevel.toStringAsFixed(1),
              ]).toList(),
            ),
          ],

          // ─── Footer ─────────────────────────────────────────────────
          pw.SizedBox(height: 30),
          pw.Divider(),
          pw.Paragraph(
            text: 'BioSmart Africa — Système IoT de monitoring de biodigesteur\n'
                'Plateau Central, Burkina Faso • Devise: XOF\n'
                'Conception et mise en œuvre d\'un système IoT intelligent de monitoring\n'
                'd\'un biodigesteur avec détection d\'anomalies.',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
          ),
        ],
      ),
    );

    return pdf;
  }

  /// Save PDF to device and return file path.
  Future<String> savePdf(pw.Document pdf, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  /// Share PDF file.
  Future<void> sharePdf(String filePath) async {
    await Share.shareXFiles([XFile(filePath)], text: 'BioSmart Biodigester Report');
  }

  /// Print PDF.
  Future<void> printPdf(pw.Document pdf) async {
    await Printing.layoutPdf(
      onLayout: (format) async => await pdf.save(),
    );
  }

  String _periodLabel(String period) {
    switch (period) {
      case 'daily': return 'Journalier';
      case 'weekly': return 'Hebdomadaire';
      case 'monthly': return 'Mensuel';
      case 'annual': return 'Annuel';
      default: return period;
    }
  }
}
