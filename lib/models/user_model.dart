class UserModel {
  final String uid;
  final String name;
  final int age;
  final String gender;
  final String bloodGroup;
  final String medicalHistory;
  final String mobileNumber;
  final String location;

  UserModel({
    required this.uid,
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    required this.medicalHistory,
    required this.mobileNumber,
    required this.location,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? '',
      bloodGroup: data['bloodGroup'] ?? '',
      medicalHistory: data['medicalHistory'] ?? '',
      mobileNumber: data['mobileNumber'] ?? '',
      location: data['location'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'medicalHistory': medicalHistory,
      'mobileNumber': mobileNumber,
      'location': location,
    };
  }
}
