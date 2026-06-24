import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../services/providers.dart';

class AnomalyDetection extends StatefulWidget {
  const AnomalyDetection({super.key});

  @override
  State<AnomalyDetection> createState() => _AnomalyDetectionState();
}

class _AnomalyDetectionState extends State<AnomalyDetection> {
  @override
  void initState() {
    super.initState();
    // Run anomaly analysis on latest sensor reading
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sensorProv = context.read<SensorProvider>();
      if (sensorProv.latestReading != null) {
        context.read<AnomalyProvider>().analyze(sensorProv.latestReading!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const AppHeader(title: 'AI Anomaly Detection'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.containerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero - Health Score
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, AppTheme.primaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: const Text('AI-POWERED ANALYSIS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                            ),
                            const SizedBox(height: 12),
                            const Text('System Health Score', style: TextStyle(fontSize: 16, color: Colors.white70)),
                            const SizedBox(height: 4),
                            const Text('Excellent', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
                          ],
                        ),
                      ),
                      // Donut
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                value: 0.94,
                                strokeWidth: 10,
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('94%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
                                Text('Health', style: TextStyle(fontSize: 10, color: Colors.white70)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Risk Score + Prediction Confidence cards
            Row(
              children: [
                Expanded(
                  child: _scoreCard(
                    'Risk Score',
                    '12%',
                    'Low',
                    Icons.shield,
                    const Color(0xFF1B5E20),
                    0.12,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _scoreCard(
                    'Prediction Confidence',
                    '96.8%',
                    'High',
                    Icons.auto_graph,
                    AppTheme.tertiary,
                    0.968,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _scoreCard(
                    'Sensor Anomalies',
                    '2',
                    'Detected',
                    Icons.sensors,
                    AppTheme.secondary,
                    0.2,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _scoreCard(
                    'Recommended Actions',
                    '5',
                    'Pending',
                    Icons.assignment,
                    const Color(0xFFF57F17),
                    0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Active Anomalies
            Text('Active Anomalies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
            const SizedBox(height: 12),
            _anomalyCard(
              icon: Icons.warning,
              title: 'Methane Pressure Spike',
              risk: 82,
              riskLabel: 'High Risk',
              description: 'Unusual pressure pattern detected in Tank A. AI model predicts potential valve failure within 48 hours if unaddressed.',
              color: AppTheme.error,
              tags: ['Pressure', 'Tank A', 'Urgent'],
            ),
            _anomalyCard(
              icon: Icons.thermostat,
              title: 'Substrate Temperature Drop',
              risk: 45,
              riskLabel: 'Medium Risk',
              description: 'Gradual temperature decline in East Sector digester. May indicate reduced microbial activity.',
              color: const Color(0xFFF57F17),
              tags: ['Temperature', 'East Sector'],
            ),
            const SizedBox(height: 24),
            // Pressure Analysis Chart
            Text('Pressure Analysis (7 Days)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
            const SizedBox(height: 12),
            Container(
              height: 180,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.2)),
              ),
              child: CustomPaint(
                size: const Size(double.infinity, 150),
                painter: _PressureBarChartPainter(),
              ),
            ),
            const SizedBox(height: 24),
            // AI Insights
            Text('AI Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
            const SizedBox(height: 12),
            _insightCard(
              Icons.psychology,
              'Pattern Recognition',
              'The AI model has identified 3 recurring pressure anomalies correlating with feed schedule changes. Consider adjusting input timing.',
              AppTheme.tertiary,
            ),
            _insightCard(
              Icons.auto_graph,
              'Predictive Maintenance',
              'Based on current trends, MQ-4 sensor in Tank A is likely to require recalibration in approximately 5 days.',
              AppTheme.secondary,
            ),
            _insightCard(
              Icons.eco,
              'Efficiency Optimization',
              'Reducing agitation frequency by 10% during night cycles could improve overall methane yield by 3.2%.',
              AppTheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreCard(String label, String value, String subtitle, IconData icon, Color color, double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.outline)),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.onSurface)),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(9999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppTheme.surfaceContainer,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _anomalyCard({
    required IconData icon,
    required String title,
    required int risk,
    required String riskLabel,
    required String description,
    required Color color,
    required List<String> tags,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
                    Text(riskLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color)),
                  ],
                ),
              ),
              // Risk indicator
              Column(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            value: risk / 100,
                            strokeWidth: 5,
                            backgroundColor: AppTheme.surfaceContainerHigh,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Text('$risk%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color)),
                      ],
                    ),
                  ),
                  Text('Risk', style: TextStyle(fontSize: 9, color: color)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(description, style: const TextStyle(fontSize: 13, color: AppTheme.onSurfaceVariant, height: 1.5)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags.map((tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(tag, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: color)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _insightCard(IconData icon, String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PressureBarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final normalPaint = Paint()..color = AppTheme.primary.withValues(alpha: 0.3);
    final anomalyPaint = Paint()..color = AppTheme.error;
    final thresholdPaint = Paint()
      ..color = AppTheme.error.withValues(alpha: 0.5)
      ..strokeWidth = 1.5;

    final data = [0.5, 0.55, 0.6, 0.58, 0.85, 0.9, 0.65];
    final barWidth = (size.width - 20) / data.length - 8;
    final chartHeight = size.height - 24;

    // Threshold line
    final thresholdY = chartHeight * 0.25;
    canvas.drawLine(Offset(0, thresholdY), Offset(size.width, thresholdY), thresholdPaint);

    for (int i = 0; i < data.length; i++) {
      final x = i * ((size.width - 20) / data.length) + 10;
      final barHeight = data[i] * chartHeight;
      final isAnomaly = data[i] > 0.75;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, chartHeight - barHeight, barWidth, barHeight),
          const Radius.circular(4),
        ),
        isAnomaly ? anomalyPaint : normalPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
