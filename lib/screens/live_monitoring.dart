import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import '../routes.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/common_widgets.dart';
import '../models/biodigester_model.dart';
import '../services/providers.dart';

class LiveMonitoring extends StatefulWidget {
  const LiveMonitoring({super.key});

  @override
  State<LiveMonitoring> createState() => _LiveMonitoringState();
}

class _LiveMonitoringState extends State<LiveMonitoring> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SensorProvider>().startListening();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.containerPadding,
          24,
          AppTheme.containerPadding,
          120,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection Status Bar
            _buildConnectionBar(),
            const SizedBox(height: 12),

            // Firebase Status
            const FirebaseStatusCard(),
            const SizedBox(height: 24),

            // Live Feed Section
            _buildLiveFeed(),
            const SizedBox(height: 24),

            // Gauges Grid
            _buildGaugesGrid(),
            const SizedBox(height: 32),

            // Predictive Maintenance
            _buildPredictiveMaintenance(),
            const SizedBox(height: 32),

            // Sensor Health
            _buildSensorHealth(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        color: AppTheme.surface.withOpacity(0.8),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.containerPadding,
              vertical: AppTheme.baseSpacing,
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.primaryContainer,
                  child: Icon(Icons.eco, color: AppTheme.onPrimary, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'BioDigit',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, AppRoutes.notifications),
                  icon: const Icon(Icons.notifications,
                      color: AppTheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const Icon(Icons.memory, color: AppTheme.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              'ESP32: ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurface,
              ),
            ),
            const Text(
              'Connected',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Container(width: 1, height: 16, color: AppTheme.outlineVariant),
            const SizedBox(width: 16),
            const Icon(Icons.signal_cellular_alt,
                color: AppTheme.primary, size: 18),
            const SizedBox(width: 8),
            const Text(
              'Signal: Excellent',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer.withOpacity(0.1),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.battery_5_bar,
                    color: AppTheme.primary, size: 18),
                const SizedBox(width: 4),
                Text(
                  '92%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildLiveFeed() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.primaryContainer.withOpacity(0.3),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.videocam,
              size: 80,
              color: AppTheme.primary.withOpacity(0.3),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppTheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'LIVE MONITORING',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Central Digester Unit 01',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Active since 04:30 AM',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGaugesGrid() {
    final gauges = [
      _GaugeData('Temperature', '38.5', '°C', AppTheme.primary, Icons.thermostat, 0.50, 'DS18B20', 'rising', '30s ago'),
      _GaugeData('Pressure', '1.2', 'BAR', AppTheme.tertiary, Icons.speed, 0.36, 'BMP280', 'stable', '1 min ago'),
      _GaugeData('Methane', '64', '% CH₄', AppTheme.primaryContainer, Icons.gas_meter, 0.72, 'MQ-4', 'rising', '45s ago'),
      _GaugeData('Filling Level', '82', '% Full', AppTheme.secondary, Icons.inventory_2, 0.82, 'HC-SR04', 'falling', '2 min ago'),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      itemCount: gauges.length,
      itemBuilder: (context, index) {
        return _buildGaugeCard(gauges[index]);
      },
    );
  }

  Widget _buildGaugeCard(_GaugeData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Sensor model badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              data.sensorModel,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppTheme.outline, letterSpacing: 0.5),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(90, 90),
                  painter: _CircularProgressPainter(
                    progress: data.progress,
                    color: data.color,
                    strokeWidth: 7,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.value,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: data.color,
                      ),
                    ),
                    Text(
                      data.unit,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(data.icon, color: data.color, size: 16),
              const SizedBox(width: 4),
              Text(
                data.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.onSurface,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TrendIndicator(trend: data.trend),
              const SizedBox(width: 4),
              Text(
                data.lastUpdate,
                style: const TextStyle(fontSize: 9, color: AppTheme.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPredictiveMaintenance() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Predictive Maintenance',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...MaintenanceItem.mockMaintenance.take(3).map((item) => Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, size: 18, color: item.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
                    ),
                    Text(
                      item.description,
                      style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 10, color: AppTheme.outline),
                        const SizedBox(width: 4),
                        Text(
                          'Due: ${item.dueDate}',
                          style: const TextStyle(fontSize: 10, color: AppTheme.outline),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.priority.toUpperCase(),
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: item.color),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildSensorHealth() {
    final sensors = [
      {'name': 'DS18B20 Temperature Sensor', 'status': 'Normal', 'detail': 'Operational · Vcc: 5.01V · Updated 30s ago', 'icon': Icons.check_circle, 'color': AppTheme.primary},
      {'name': 'MQ-4 Methane Sensor', 'status': 'Normal', 'detail': 'Calibrated · Vcc: 4.98V · Updated 45s ago', 'icon': Icons.check_circle, 'color': AppTheme.primary},
      {'name': 'BMP280 Pressure Sensor', 'status': 'Stable', 'detail': 'Minor noise · Vcc: 3.31V · Updated 1m ago', 'icon': Icons.info, 'color': AppTheme.secondary},
      {'name': 'HC-SR04 Ultrasonic Sensor', 'status': 'Low Battery', 'detail': 'Battery 12% · Replace soon · Updated 2m ago', 'icon': Icons.warning, 'color': AppTheme.error},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sensor Health',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: AppTheme.onSurface,
              ),
            ),
            Text(
              'Updated 2m ago',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...sensors.map((sensor) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (sensor['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(sensor['icon'] as IconData,
                      color: sensor['color'] as Color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sensor['name'] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      Text(
                        sensor['detail'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (sensor['status'] == 'Normal')
                        ? const Color(0xFFE8F5E9)
                        : const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    (sensor['status'] as String).toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: (sensor['status'] == 'Normal')
                          ? const Color(0xFF1B5E20)
                          : const Color(0xFFF57F17),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _GaugeData {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;
  final double progress;
  final String sensorModel;
  final String trend;
  final String lastUpdate;

  const _GaugeData(this.label, this.value, this.unit, this.color, this.icon, this.progress, this.sensorModel, this.trend, this.lastUpdate);
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = AppTheme.surfaceContainerHigh
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
