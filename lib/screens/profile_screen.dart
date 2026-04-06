import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _locationController = TextEditingController();
  final _ageController = TextEditingController();
  final _historyController = TextEditingController();
  String _gender = 'Male';
  String _bloodGroup = 'A+';

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) return const Scaffold();

    final db = DatabaseService(uid: user.uid);

    return Scaffold(
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('My Profile', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () async => await AuthService().signOut(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<UserModel>(
                  stream: db.userData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting && !_initialized) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }
                    if (snapshot.hasData && !_initialized) {
                      final data = snapshot.data!;
                      if (data.name.isNotEmpty) {
                        _nameController.text = data.name;
                        _mobileController.text = data.mobileNumber;
                        _locationController.text = data.location;
                        _ageController.text = data.age.toString();
                        _gender = genders.contains(data.gender) ? data.gender : 'Male';
                        _bloodGroup = bloodGroups.contains(data.bloodGroup) ? data.bloodGroup : 'A+';
                        _historyController.text = data.medicalHistory;
                      }
                      _initialized = true; 
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white24,
                              child: Icon(Icons.account_circle, size: 80, color: Colors.white),
                            ).animate().scale(),
                            const SizedBox(height: 24),
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(labelText: 'Full Name'),
                            ).animate().fade().slideX(begin: 0.1),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: TextField(controller: _mobileController, decoration: const InputDecoration(labelText: 'Mobile Number'), keyboardType: TextInputType.phone)),
                                const SizedBox(width: 16),
                                Expanded(child: TextField(controller: _locationController, decoration: const InputDecoration(labelText: 'Location / Pincode'))),
                              ],
                            ).animate().fade().slideX(begin: 0.1),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(child: TextField(controller: _ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number)),
                                const SizedBox(width: 16),
                                Expanded(child: DropdownButtonFormField<String>(
                                  value: _gender,
                                  decoration: const InputDecoration(labelText: 'Gender'),
                                  items: genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                                  onChanged: (val) => setState(() => _gender = val!),
                                )),
                              ],
                            ).animate().fade().slideX(begin: 0.1),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _bloodGroup,
                              decoration: const InputDecoration(labelText: 'Blood Group'),
                              items: bloodGroups.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                              onChanged: (val) => setState(() => _bloodGroup = val!),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _historyController,
                              maxLines: 3,
                              decoration: const InputDecoration(labelText: 'Prior Medical History (Optional)'),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
                              onPressed: () async {
                                await db.updateUserProfile(
                                  name: _nameController.text,
                                  age: int.tryParse(_ageController.text) ?? 0,
                                  gender: _gender,
                                  bloodGroup: _bloodGroup,
                                  medicalHistory: _historyController.text,
                                  mobileNumber: _mobileController.text,
                                  location: _locationController.text,
                                );
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Saved Successfully!')));
                                }
                              },
                              child: const Text('SAVE PROFILE'),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
