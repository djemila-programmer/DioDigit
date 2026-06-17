import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/bottom_nav_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedPeriod = '7 Days';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: const AppHeader(title: 'History & Analytics'),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.onPrimary,
        icon: const Icon(Icons.download),
        label: const Text('Export'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.containerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date filter chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['24 Hours', '7 Days', '30 Days', '12 Months'].map((period) {
                final selected = _selectedPeriod == period;
                return GestureDetector(
                  onTap: () => setState(() => _selectedPeriod = period),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.primary : AppTheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      period,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: selected ? AppTheme.onPrimary : AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            // Bento grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.0,
              children: [
                _BentoCard(
                  title: 'Avg Temperature',
                  value: '38.2',
                  unit: '°C',
                  icon: Icons.thermostat,
                  color: AppTheme.primary,
                  trend: '+0.3°',
                  trendUp: true,
                  child: _MiniLineChart(color: AppTheme.primary),
                ),
                _BentoCard(
                  title: 'Methane Flow',
                  value: '64',
                  unit: '%',
                  icon: Icons.gas_meter,
                  color: AppTheme.secondary,
                  trend: '+2.1%',
                  trendUp: true,
                  child: _MiniBarChart(color: AppTheme.secondary),
                ),
                _BentoCard(
                  title: 'Pressure',
                  value: '1.05',
                  unit: 'bar',
                  icon: Icons.speed,
                  color: AppTheme.tertiary,
                  trend: 'Stable',
                  trendUp: true,
                  child: _MiniLineChart(color: AppTheme.tertiary),
                ),
                _BentoCard(
                  title: 'Slurry Level',
                  value: '85',
                  unit: '%',
                  icon: Icons.height,
                  color: const Color(0xFF2E7D32),
                  trend: '-3%',
                  trendUp: false,
                  child: _MiniLineChart(color: const Color(0xFF2E7D32)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Activity log
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Activity Log',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _logEntry(Icons.thermostat, 'Temperature spike recorded', '38.9°C at 14:30', AppTheme.primary),
            _logEntry(Icons.gas_meter, 'Methane output optimized', 'Efficiency +3%', AppTheme.secondary),
            _logEntry(Icons.settings, 'Sensor calibration complete', 'DS18B20 recalibrated', AppTheme.tertiary),
            _logEntry(Icons.height, 'Slurry level adjusted', 'Reduced from 92% to 85%', const Color(0xFF2E7D32)),
            _logEntry(Icons.warning_amber, 'Alert resolved automatically', 'Pressure normalized', const Color(0xFF2E7D32)),
            _logEntry(Icons.bolt, 'Grid export initiated', '2.4 kWh exported', AppTheme.primary),
            _logEntry(Icons.memory, 'ESP32 firmware updated', 'v2.4.1-bf installed', AppTheme.tertiary),
            _logEntry(Icons.cleaning_services, 'MQ-4 sensor cleaned', 'Calibration restored', AppTheme.secondary),
          ],
        ),
      ),
    );
  }

  Widget _logEntry(IconData icon, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.onSurface)),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: AppTheme.outline),
        ],
      ),
    );
  }
}

class _BentoCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final String trend;
  final bool trendUp;
  final Widget child;

  const _BentoCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendUp,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 20, color: color),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: trendUp ? const Color(0xFFE8F5E9) : const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(trend, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: trendUp ? const Color(0xFF1B5E20) : const Color(0xFFF57F17))),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: AppTheme.onSurface)),
              const SizedBox(width: 2),
              Text(unit, style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _MiniLineChart extends StatelessWidget {
  final Color color;
  const _MiniLineChart({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 40),
      painter: _LineChartPainter(color: color),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final Color color;
  _LineChartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final data = [0.3, 0.5, 0.4, 0.7, 0.6, 0.8, 0.75];
    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - data[i] * size.height;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MiniBarChart extends StatelessWidget {
  final Color color;
  const _MiniBarChart({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 40),
      painter: _BarChartPainter(color: color),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final Color color;
  _BarChartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final data = [0.4, 0.6, 0.5, 0.8, 0.7, 0.9, 0.75];
    final barWidth = size.width / data.length - 4;

    for (int i = 0; i < data.length; i++) {
      final x = i * (size.width / data.length) + 2;
      final barHeight = data[i] * size.height;
      paint.color = i == data.length - 1 ? color : color.withOpacity(0.3);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - barHeight, barWidth, barHeight),
          const Radius.circular(3),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
