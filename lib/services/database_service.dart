import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/health_record.dart';
import '../models/medicine_reminder.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> updateUserProfile({
    required String name,
    required int age,
    required String gender,
    required String bloodGroup,
    required String medicalHistory,
    required String mobileNumber,
    required String location,
  }) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'age': age,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'medicalHistory': medicalHistory,
      'mobileNumber': mobileNumber,
      'location': location,
    }, SetOptions(merge: true));
  }

  Stream<UserModel> get userData {
    return userCollection.doc(uid).snapshots().map((snapshot) =>
        UserModel.fromMap(snapshot.data() as Map<String, dynamic>? ?? {}, snapshot.id));
  }

  Future<void> addHealthRecord(HealthRecord record) async {
    await userCollection.doc(uid).collection('health_data').add(record.toMap());
  }

  Stream<List<HealthRecord>> get healthRecords {
    return userCollection.doc(uid).collection('health_data')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => HealthRecord.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addMedicineReminder(MedicineReminder reminder) async {
    await userCollection.doc(uid).collection('medicine_reminders').add(reminder.toMap());
  }

  Stream<List<MedicineReminder>> get medicineReminders {
    return userCollection.doc(uid).collection('medicine_reminders')
        .orderBy('time', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MedicineReminder.fromMap(doc.data(), doc.id)).toList());
  }
}
