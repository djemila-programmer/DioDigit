import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/main_dashboard.dart';
import 'screens/live_monitoring.dart';
import 'screens/sensor_management.dart';
import 'screens/alerts_screen.dart';
import 'screens/history_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/anomaly_detection.dart';
import 'screens/notifications_center.dart';
import 'screens/farm_management.dart';
import 'screens/user_profile.dart';
import 'screens/settings_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/threshold_management.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String mainDashboard = '/main-dashboard';
  static const String liveMonitoring = '/live-monitoring';
  static const String sensorManagement = '/sensor-management';
  static const String alerts = '/alerts';
  static const String history = '/history';
  static const String reports = '/reports';
  static const String anomalyDetection = '/anomaly-detection';
  static const String notifications = '/notifications';
  static const String farmManagement = '/farm-management';
  static const String userProfile = '/user-profile';
  static const String settings = '/settings';
  static const String adminDashboard = '/admin-dashboard';
  static const String thresholdManagement = '/threshold-management';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        onboarding: (context) => const OnboardingScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        mainDashboard: (context) => const MainDashboard(),
        liveMonitoring: (context) => const LiveMonitoring(),
        sensorManagement: (context) => const SensorManagement(),
        alerts: (context) => const AlertsScreen(),
        history: (context) => const HistoryScreen(),
        reports: (context) => const ReportsScreen(),
        anomalyDetection: (context) => const AnomalyDetection(),
        notifications: (context) => const NotificationsCenter(),
        farmManagement: (context) => const FarmManagement(),
        userProfile: (context) => const UserProfile(),
        settings: (context) => const SettingsScreen(),
        adminDashboard: (context) => const AdminDashboard(),
        thresholdManagement: (context) => const ThresholdManagement(),
      };
}
