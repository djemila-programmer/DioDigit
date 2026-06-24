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

import 'widgets/auth_guard.dart';

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
    mainDashboard: (context) => const AuthGuard(child: MainDashboard()),
    liveMonitoring: (context) => const AuthGuard(child: LiveMonitoring()),
    sensorManagement: (context) => const AuthGuard(child: SensorManagement()),
    alerts: (context) => const AuthGuard(child: AlertsScreen()),
    history: (context) => const AuthGuard(child: HistoryScreen()),
    reports: (context) => const AuthGuard(child: ReportsScreen()),
    anomalyDetection: (context) => const AuthGuard(child: AnomalyDetection()),
    notifications: (context) => const AuthGuard(child: NotificationsCenter()),
    farmManagement: (context) => const AuthGuard(child: FarmManagement()),
    userProfile: (context) => const AuthGuard(child: UserProfile()),
    settings: (context) => const AuthGuard(child: SettingsScreen()),
    adminDashboard: (context) =>
        const AuthGuard(role: 'admin', child: AdminDashboard()),
    thresholdManagement: (context) =>
        const AuthGuard(child: ThresholdManagement()),
  };
}
