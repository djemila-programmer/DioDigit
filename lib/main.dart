import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'routes.dart';
import 'services/auth_service.dart';
import 'services/sensor_service.dart';
import 'services/alert_service.dart';
import 'services/farm_service.dart';
import 'services/history_service.dart';
import 'services/anomaly_service.dart';
import 'services/notification_service.dart';
import 'services/pdf_service.dart';
import 'services/cache_service.dart';
import 'services/providers.dart';

bool firebaseReady = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (try, but allow app to run without it for demo)
  try {
    await Firebase.initializeApp();
    firebaseReady = true;
  } catch (e) {
    debugPrint('Firebase not configured — running in demo mode');
    firebaseReady = false;
  }

  // Initialize Hive cache
  final cacheService = CacheService();
  try {
    await cacheService.initialize();
  } catch (e) {
    debugPrint('Cache init skipped: $e');
  }

  // Initialize notification service
  final notificationService = NotificationService();
  try {
    if (firebaseReady) await notificationService.initialize();
  } catch (e) {
    debugPrint('Notifications init skipped: $e');
  }

  runApp(BioSmartApp(
    cacheService: cacheService,
    notificationService: notificationService,
  ));
}

class BioSmartApp extends StatelessWidget {
  final CacheService cacheService;
  final NotificationService notificationService;

  const BioSmartApp({
    super.key,
    required this.cacheService,
    required this.notificationService,
  });

  @override
  Widget build(BuildContext context) {
    // Create service instances
    final authService = AuthService();
    final sensorService = SensorService();
    final alertService = AlertService();
    final farmService = FarmService();
    final historyService = HistoryService();
    final anomalyService = AnomalyService();
    final pdfService = PdfService();

    return MultiProvider(
      providers: [
        // Service singletons available via context
        Provider<AuthService>.value(value: authService),
        Provider<SensorService>.value(value: sensorService),
        Provider<AlertService>.value(value: alertService),
        Provider<FarmService>.value(value: farmService),
        Provider<HistoryService>.value(value: historyService),
        Provider<AnomalyService>.value(value: anomalyService),
        Provider<NotificationService>.value(value: notificationService),
        Provider<PdfService>.value(value: pdfService),
        Provider<CacheService>.value(value: cacheService),

        // State providers
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (_) => SensorProvider(sensorService, historyService, notificationService, cacheService),
        ),
        ChangeNotifierProvider(
          create: (_) => AlertProvider(alertService),
        ),
        ChangeNotifierProvider(
          create: (_) => AnomalyProvider(anomalyService),
        ),
        ChangeNotifierProvider(
          create: (_) => HistoryProvider(historyService),
        ),
        ChangeNotifierProvider(
          create: (_) => ConnectivityProvider()..startListening(),
        ),
      ],
      child: MaterialApp(
        title: 'BioSmart — Monitoring Biodigesteur',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}
