import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineReminder {
  final String? id;
  final String name;
  final DateTime time;

  MedicineReminder({
    this.id,
    required this.name,
    required this.time,
  });

  factory MedicineReminder.fromMap(Map<String, dynamic> data, String documentId) {
    return MedicineReminder(
      id: documentId,
      name: data['name'] ?? '',
      time: (data['time'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'time': Timestamp.fromDate(time),
    };
  }
}
