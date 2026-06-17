import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/auth_service.dart';
import '../services/sensor_service.dart';
import '../services/alert_service.dart';
import '../services/anomaly_service.dart';
import '../services/history_service.dart';
import '../services/notification_service.dart';
import '../services/cache_service.dart';
import '../models/user_model.dart';

// ═══════════════════════════════════════════════════════════════════════════
// Auth Provider
// ═══════════════════════════════════════════════════════════════════════════

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  StreamSubscription? _authSub;

  AuthProvider(this._authService) {
    _authSub = _authService.authStateChanges.listen((user) async {
      if (user != null) {
        _user = await _authService.getCurrentUserProfile();
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  String? get error => _error;

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _authService.signIn(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String farmName,
    String? biodigesterType,
    double? biodigesterCapacity,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        farmName: farmName,
        biodigesterType: biodigesterType,
        biodigesterCapacity: biodigesterCapacity,
      );
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  Future<void> sendPasswordReset(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _authService.sendPasswordResetEmail(email);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    await _authService.updateUserProfile(updates);
    _user = await _authService.getCurrentUserProfile();
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Sensor Provider (real-time data from ESP32 via Firebase RTDB)
// ═══════════════════════════════════════════════════════════════════════════

class SensorProvider extends ChangeNotifier {
  final SensorService _sensorService;
  final HistoryService _historyService;
  final NotificationService _notificationService;
  final CacheService _cacheService;

  SensorReading? _latestReading;
  Esp32StatusData? _esp32Status;
  StreamSubscription? _sensorSub;
  StreamSubscription? _esp32Sub;
  bool _isLoading = true;
  String? _error;
  bool _isOnline = true;

  SensorProvider(this._sensorService, this._historyService, this._notificationService, this._cacheService);

  SensorReading? get latestReading => _latestReading;
  Esp32StatusData? get esp32Status => _esp32Status;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOnline => _isOnline;

  /// Start listening to real-time sensor data.
  void startListening() {
    _isLoading = true;
    notifyListeners();

    _sensorSub = _sensorService.sensorDataStream().listen(
      (reading) async {
        _latestReading = reading;
        _isLoading = false;
        _error = null;
        _isOnline = true;
        notifyListeners();

        // Cache for offline
        await _cacheService.cacheSensorReading(reading);

        // Log to history
        await _historyService.logReading(reading);

        // Check for critical values and notify
        await _notificationService.checkAndNotify(reading);
      },
      onError: (e) {
        _error = e.toString();
        _isLoading = false;
        _isOnline = false;
        // Fall back to cache
        _latestReading = _cacheService.getLastCachedReading();
        notifyListeners();
      },
    );

    _esp32Sub = _sensorService.esp32StatusStream().listen((status) {
      _esp32Status = status;
      notifyListeners();
    });
  }

  /// Load cached data when offline.
  void loadCached() {
    _latestReading = _cacheService.getLastCachedReading();
    _isOnline = false;
    _isLoading = false;
    notifyListeners();
  }

  void stopListening() {
    _sensorSub?.cancel();
    _esp32Sub?.cancel();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Alert Provider
// ═══════════════════════════════════════════════════════════════════════════

class AlertProvider extends ChangeNotifier {
  final AlertService _alertService;

  List<SmartAlert> _alerts = [];
  Map<String, int> _counts = {'critical': 0, 'warning': 0, 'info': 0};
  StreamSubscription? _alertSub;
  bool _isLoading = true;

  AlertProvider(this._alertService);

  List<SmartAlert> get alerts => _alerts;
  Map<String, int> get counts => _counts;
  int get totalCount => _counts.values.fold(0, (a, b) => a + b);
  bool get isLoading => _isLoading;

  void startListening() {
    _alertSub = _alertService.alertsStream().listen((alerts) {
      _alerts = alerts;
      _isLoading = false;
      _updateCounts();
      notifyListeners();
    });
  }

  void _updateCounts() {
    _counts = {'critical': 0, 'warning': 0, 'info': 0};
    for (final a in _alerts.where((a) => !a.resolved)) {
      if (_counts.containsKey(a.severity)) {
        _counts[a.severity] = _counts[a.severity]! + 1;
      }
    }
  }

  Future<void> acknowledge(String id) async {
    await _alertService.acknowledgeAlert(id);
  }

  Future<void> resolve(String id) async {
    await _alertService.resolveAlert(id);
  }

  void stopListening() {
    _alertSub?.cancel();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Anomaly Provider (real detection engine)
// ═══════════════════════════════════════════════════════════════════════════

class AnomalyProvider extends ChangeNotifier {
  final AnomalyService _anomalyService;

  AnomalyReport? _report;

  AnomalyProvider(this._anomalyService);

  AnomalyReport? get report => _report;

  /// Run anomaly analysis on the latest sensor reading.
  void analyze(SensorReading reading) {
    _report = _anomalyService.analyze(reading);
    notifyListeners();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// History Provider
// ═══════════════════════════════════════════════════════════════════════════

class HistoryProvider extends ChangeNotifier {
  final HistoryService _historyService;

  List<HistoryPoint> _data = [];
  ProductionSummary? _production;
  bool _isLoading = false;
  String _selectedRange = '24h';

  HistoryProvider(this._historyService);

  List<HistoryPoint> get data => _data;
  ProductionSummary? get production => _production;
  bool get isLoading => _isLoading;
  String get selectedRange => _selectedRange;

  Future<void> loadData(String range) async {
    _selectedRange = range;
    _isLoading = true;
    notifyListeners();

    switch (range) {
      case '24h':
        _data = await _historyService.getLast24Hours();
        break;
      case '7d':
        _data = await _historyService.getLast7Days();
        break;
      case '30d':
        _data = await _historyService.getLast30Days();
        break;
      case '12m':
        _data = await _historyService.getLast12Months();
        break;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadProduction(String period) async {
    _production = await _historyService.getProductionSummary(period);
    notifyListeners();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Connectivity Provider
// ═══════════════════════════════════════════════════════════════════════════

class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _sub;
  bool _isOnline = true;

  ConnectivityProvider();

  bool get isOnline => _isOnline;

  void startListening() {
    _sub = _connectivity.onConnectivityChanged.listen((results) {
      _isOnline = results.any((r) => r != ConnectivityResult.none);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
