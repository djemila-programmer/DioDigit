import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    firebaseReady = true;
    debugPrint('Firebase initialized successfully');
  } catch (e) {
    firebaseReady = false;
    debugPrint('Firebase initialization error: $e');
  }

  // Cache initialization
  final cacheService = CacheService();
  try {
    await cacheService.initialize();
  } catch (e) {
    debugPrint('Cache initialization error: $e');
  }

  // Notification initialization
  final notificationService = NotificationService();
  try {
    if (firebaseReady) {
      await notificationService.initialize();
    }
  } catch (e) {
    debugPrint('Notification initialization error: $e');
  }

  debugPrint('Firebase Ready = $firebaseReady');

  runApp(
    BioSmartApp(
      cacheService: cacheService,
      notificationService: notificationService,
    ),
  );
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
    final authService = AuthService();
    final sensorService = SensorService();
    final alertService = AlertService();
    final farmService = FarmService();
    final historyService = HistoryService();
    final anomalyService = AnomalyService();
    final pdfService = PdfService();

    return MultiProvider(
      providers: [
        // Services
        Provider<AuthService>.value(value: authService),
        Provider<SensorService>.value(value: sensorService),
        Provider<AlertService>.value(value: alertService),
        Provider<FarmService>.value(value: farmService),
        Provider<HistoryService>.value(value: historyService),
        Provider<AnomalyService>.value(value: anomalyService),
        Provider<NotificationService>.value(value: notificationService),
        Provider<PdfService>.value(value: pdfService),
        Provider<CacheService>.value(value: cacheService),

        // State Providers
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService),
        ),

        ChangeNotifierProvider(
          create: (_) => SensorProvider(
            sensorService,
            historyService,
            notificationService,
            cacheService,
          ),
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
        debugShowCheckedModeBanner: false,
        title: 'BioSmart Africa',
        theme: AppTheme.theme,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
      ),
    );
  }
}