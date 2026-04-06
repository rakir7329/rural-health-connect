import 'package:cloud_firestore/cloud_firestore.dart';

class HealthRecord {
  final String? id;
  final String bp;
  final double sugarLevel;
  final double temperature;
  final DateTime timestamp;

  HealthRecord({
    this.id,
    required this.bp,
    required this.sugarLevel,
    required this.temperature,
    required this.timestamp,
  });

  factory HealthRecord.fromMap(Map<String, dynamic> data, String documentId) {
    return HealthRecord(
      id: documentId,
      bp: data['bp'] ?? '',
      sugarLevel: (data['sugarLevel'] ?? 0.0).toDouble(),
      temperature: (data['temperature'] ?? 0.0).toDouble(),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bp': bp,
      'sugarLevel': sugarLevel,
      'temperature': temperature,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
