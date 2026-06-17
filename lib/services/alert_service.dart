import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';

/// Firestore-based alert service for smart alert management.
class AlertService {
  FirebaseFirestore? _firestore;

  FirebaseFirestore? get _fs {
    if (!firebaseReady) return null;
    _firestore ??= FirebaseFirestore.instance;
    return _firestore;
  }

  /// Stream of active alerts (real-time), ordered by timestamp descending.
  Stream<List<SmartAlert>> alertsStream() {
    if (_fs == null) {
      return Stream.value(_demoAlerts());
    }
    return _fs!
        .collection('alerts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => SmartAlert.fromFirestore(doc)).toList());
  }

  /// Get all active alerts (one-shot).
  Future<List<SmartAlert>> getAlerts({int limit = 50}) async {
    if (_fs == null) return _demoAlerts();
    final snapshot = await _fs!
        .collection('alerts')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => SmartAlert.fromFirestore(doc)).toList();
  }

  /// Get alerts by severity.
  Future<List<SmartAlert>> getAlertsBySeverity(String severity) async {
    if (_fs == null) return _demoAlerts().where((a) => a.severity == severity).toList();
    final snapshot = await _fs!
        .collection('alerts')
        .where('severity', isEqualTo: severity)
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) => SmartAlert.fromFirestore(doc)).toList();
  }

  Future<String> createAlert({
    required String title, required String description,
    required String severity, required String sensorId, required String location,
  }) async {
    if (_fs == null) return 'demo-id';
    final docRef = await _fs!.collection('alerts').add({
      'title': title, 'description': description, 'severity': severity,
      'sensorId': sensorId, 'location': location,
      'timestamp': FieldValue.serverTimestamp(),
      'acknowledged': false, 'resolved': false,
    });
    return docRef.id;
  }

  Future<void> acknowledgeAlert(String alertId) async {
    if (_fs == null) return;
    await _fs!.collection('alerts').doc(alertId).update({
      'acknowledged': true, 'acknowledgedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> resolveAlert(String alertId) async {
    if (_fs == null) return;
    await _fs!.collection('alerts').doc(alertId).update({
      'resolved': true, 'resolvedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, int>> getAlertCounts() async {
    if (_fs == null) return {'critical': 2, 'warning': 3, 'info': 2};
    final snapshot = await _fs!.collection('alerts').where('resolved', isEqualTo: false).get();
    int critical = 0, warning = 0, info = 0;
    for (final doc in snapshot.docs) {
      final severity = doc['severity'] as String?;
      if (severity == 'critical') critical++;
      else if (severity == 'warning') warning++;
      else info++;
    }
    return {'critical': critical, 'warning': warning, 'info': info};
  }

  Future<void> generateAlertsFromReading({
    required double temperature, required double pressure,
    required double methane, required double slurryLevel,
  }) async {
    if (_fs == null) return;
    if (temperature > 40) {
      await createAlert(title: 'Température critique: ${temperature.toStringAsFixed(1)}°C',
        description: 'La température a dépassé le seuil maximum de 40°C.',
        severity: 'critical', sensorId: 'DS18B20', location: 'Chambre principale');
    } else if (temperature < 25) {
      await createAlert(title: 'Température basse: ${temperature.toStringAsFixed(1)}°C',
        description: 'La température est en dessous du seuil minimum de 25°C.',
        severity: 'warning', sensorId: 'DS18B20', location: 'Chambre principale');
    }
    if (pressure > 1.5) {
      await createAlert(title: 'Pression critique: ${pressure.toStringAsFixed(2)} bar',
        description: 'La pression a dépassé 1.5 bar. Soupape de sécurité activée.',
        severity: 'critical', sensorId: 'BMP280', location: 'Biodigesteur principal');
    } else if (pressure < 0.8) {
      await createAlert(title: 'Pression basse: ${pressure.toStringAsFixed(2)} bar',
        description: 'La pression est en dessous de 0.8 bar.',
        severity: 'warning', sensorId: 'BMP280', location: 'Biodigesteur principal');
    }
    if (methane > 500) {
      await createAlert(title: 'Méthane élevé: ${methane.toStringAsFixed(0)} ppm',
        description: 'Concentration de méthane au-dessus de 500 ppm. Risque de fuite.',
        severity: 'critical', sensorId: 'MQ-4', location: 'Dôme de gaz');
    } else if (methane < 150) {
      await createAlert(title: 'Méthane bas: ${methane.toStringAsFixed(0)} ppm',
        description: 'Production de méthane insuffisante.',
        severity: 'warning', sensorId: 'MQ-4', location: 'Dôme de gaz');
    }
    if (slurryLevel > 90) {
      await createAlert(title: 'Niveau de lisier critique: ${slurryLevel.toStringAsFixed(1)}%',
        description: 'Le niveau de lisier dépasse 90%. Vidange nécessaire.',
        severity: 'critical', sensorId: 'HC-SR04', location: 'Sortie de lisier');
    } else if (slurryLevel < 20) {
      await createAlert(title: 'Niveau de lisier bas: ${slurryLevel.toStringAsFixed(1)}%',
        description: 'Le niveau de lisier est en dessous de 20%.',
        severity: 'warning', sensorId: 'HC-SR04', location: 'Sortie de lisier');
    }
  }

  List<SmartAlert> _demoAlerts() {
    final now = DateTime.now();
    return [
      SmartAlert(id: '1', title: 'Température élevée: 41.2°C', description: 'La température dépasse le seuil critique.', severity: 'critical', sensorId: 'DS18B20', location: 'Chambre principale', timestamp: now.subtract(const Duration(minutes: 12)), acknowledged: true, resolved: false),
      SmartAlert(id: '2', title: 'Pression instable: 1.52 bar', description: 'Pression au-dessus de la limite.', severity: 'critical', sensorId: 'BMP280', location: 'Biodigesteur principal', timestamp: now.subtract(const Duration(minutes: 35)), acknowledged: false, resolved: false),
      SmartAlert(id: '3', title: 'Méthane bas: 142 ppm', description: 'Production insuffisante.', severity: 'warning', sensorId: 'MQ-4', location: 'Dôme de gaz', timestamp: now.subtract(const Duration(hours: 1)), acknowledged: false, resolved: false),
      SmartAlert(id: '4', title: 'Niveau lisier: 88%', description: 'Approche du seuil maximum.', severity: 'warning', sensorId: 'HC-SR04', location: 'Sortie de lisier', timestamp: now.subtract(const Duration(hours: 2)), acknowledged: true, resolved: false),
      SmartAlert(id: '5', title: 'Calibration DS18B20 requise', description: 'Dérive détectée sur le capteur.', severity: 'info', sensorId: 'DS18B20', location: 'Chambre principale', timestamp: now.subtract(const Duration(hours: 5)), acknowledged: false, resolved: false),
      SmartAlert(id: '6', title: 'Connexion ESP32 rétablie', description: 'Le contrôleur est de nouveau en ligne.', severity: 'info', sensorId: 'ESP32', location: 'Contrôleur principal', timestamp: now.subtract(const Duration(hours: 8)), acknowledged: true, resolved: true),
      SmartAlert(id: '7', title: 'Température basse: 24.1°C', description: 'Température sous le minimum.', severity: 'warning', sensorId: 'DS18B20', location: 'Chambre principale', timestamp: now.subtract(const Duration(hours: 12)), acknowledged: false, resolved: true),
    ];
  }
}

/// Firestore-backed smart alert model.
class SmartAlert {
  final String id;
  final String title;
  final String description;
  final String severity; // critical, warning, info
  final String sensorId;
  final String location;
  final DateTime? timestamp;
  final bool acknowledged;
  final bool resolved;

  const SmartAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.sensorId,
    required this.location,
    this.timestamp,
    this.acknowledged = false,
    this.resolved = false,
  });

  factory SmartAlert.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    DateTime? ts;
    final rawTs = data['timestamp'];
    if (rawTs is Timestamp) {
      ts = rawTs.toDate();
    } else if (rawTs is String) {
      ts = DateTime.tryParse(rawTs);
    }

    return SmartAlert(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      severity: data['severity'] ?? 'info',
      sensorId: data['sensorId'] ?? '',
      location: data['location'] ?? '',
      timestamp: ts,
      acknowledged: data['acknowledged'] == true,
      resolved: data['resolved'] == true,
    );
  }

  Color get severityColor {
    switch (severity) {
      case 'critical':
        return const Color(0xFFBA1A1A);
      case 'warning':
        return const Color(0xFF7A5649);
      default:
        return const Color(0xFF717A6D);
    }
  }

  IconData get icon {
    switch (severity) {
      case 'critical':
        return Icons.error;
      case 'warning':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  String get timeAgo {
    if (timestamp == null) return '';
    final diff = DateTime.now().difference(timestamp!);
    if (diff.inMinutes < 1) return 'Maintenant';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}j';
  }
}
