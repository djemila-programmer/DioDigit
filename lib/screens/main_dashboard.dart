import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../routes.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/common_widgets.dart';
import '../models/sensor_model.dart';
import '../services/providers.dart';
import '../services/sensor_service.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  void initState() {
    super.initState();
    // Start listening to real-time sensor data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SensorProvider>().startListening();
      context.read<AlertProvider>().startListening();
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
            // Hero Greeting
            _buildGreetingSection(),
            const SizedBox(height: 32),

            // Biodigester Visual
            const BiodigesterVisual(height: 220),
            const SizedBox(height: 32),

            // ESP32 Status Card
            const ESP32StatusCard(),
            const SizedBox(height: 12),

            // Firebase Status Card
            const FirebaseStatusCard(),
            const SizedBox(height: 32),

            // Sensor Grid (real-time from SensorProvider)
            Consumer<SensorProvider>(
              builder: (ctx, sensorProv, _) {
                final reading = sensorProv.latestReading;
                if (reading != null && reading.temperature > 0) {
                  return _buildLiveSensorGrid(reading);
                }
                // Fallback to mock data when no live data
                return _buildSensorGrid();
              },
            ),
            const SizedBox(height: 32),

            // Biogas Production Card
            const BiogasProductionCard(),
            const SizedBox(height: 12),

            // Energy Impact Card
            const EnergyImpactCard(),
            const SizedBox(height: 32),

            // Daily Insight
            _buildDailyInsight(context),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        color: AppTheme.surface.withValues(alpha: 0.8),
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

  Widget _buildGreetingSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Bienvenue, Ferme Plateau Central !',
                  style: TextStyle(
                    fontSize: 28,
                    height: 36 / 28,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your energy system is operating optimally.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.wb_sunny, color: AppTheme.secondary, size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ouagadougou, BF',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  Text(
                    '35°C',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSensorGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: DashboardMetric.mockMetrics.length,
      itemBuilder: (context, index) {
        final m = DashboardMetric.mockMetrics[index];
        return MetricCard(
          label: m.label,
          value: m.value,
          unit: m.unit,
          icon: m.icon,
          iconColor: m.color,
          status: m.status,
          progress: m.progress,
          trend: m.trend,
          lastUpdate: m.lastUpdate,
          sensorModel: m.sensorModel,
        );
      },
    );
  }

  Widget _buildLiveSensorGrid(SensorReading reading) {
    final metrics = [
      {
        'label': 'Temperature',
        'value': reading.temperature.toStringAsFixed(1),
        'unit': '°C',
        'icon': Icons.thermostat,
        'color': AppTheme.primary,
        'progress': ((reading.temperature - 25) / 15).clamp(0.0, 1.0),
        'trend': reading.temperatureTrend ?? 'stable',
        'sensor': 'DS18B20',
      },
      {
        'label': 'Pressure',
        'value': reading.pressure.toStringAsFixed(2),
        'unit': 'bar',
        'icon': Icons.speed,
        'color': AppTheme.primary,
        'progress': ((reading.pressure - 0.8) / 0.7).clamp(0.0, 1.0),
        'trend': reading.pressureTrend ?? 'stable',
        'sensor': 'BMP280',
      },
      {
        'label': 'Methane',
        'value': reading.methane.toStringAsFixed(0),
        'unit': 'ppm',
        'icon': Icons.gas_meter,
        'color': AppTheme.secondary,
        'progress': ((reading.methane - 150) / 350).clamp(0.0, 1.0),
        'trend': reading.methaneTrend ?? 'stable',
        'sensor': 'MQ-4',
      },
      {
        'label': 'Level',
        'value': reading.slurryLevel.toStringAsFixed(1),
        'unit': '%',
        'icon': Icons.layers,
        'color': AppTheme.tertiary,
        'progress': (reading.slurryLevel / 100).clamp(0.0, 1.0),
        'trend': reading.slurryTrend ?? 'stable',
        'sensor': 'HC-SR04',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final m = metrics[index];
        return MetricCard(
          label: m['label'] as String,
          value: m['value'] as String,
          unit: m['unit'] as String,
          icon: m['icon'] as IconData,
          iconColor: m['color'] as Color,
          status: 'LIVE',
          progress: m['progress'] as double,
          trend: m['trend'] as String,
          lastUpdate: 'Now',
          sensorModel: m['sensor'] as String,
        );
      },
    );
  }

  Widget _buildDailyInsight(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daily Insight',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.onSurface,
                ),
              ),
              const Icon(Icons.lightbulb, color: AppTheme.primary),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Optimization complete. Methane levels are 5% higher due to adjusted agitation schedule. Slurry output quality is optimal.',
            style: TextStyle(
              fontSize: 16,
              height: 24 / 16,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.reports),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              side: const BorderSide(color: AppTheme.primary, width: 2),
            ),
            child: const Text('View Full Report'),
          ),
        ],
      ),
    );
  }
}
