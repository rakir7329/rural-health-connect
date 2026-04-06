import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _locationController = TextEditingController();
  final _ageController = TextEditingController();
  final _historyController = TextEditingController();
  String _gender = 'Male';
  String _bloodGroup = 'A+';

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  String _error = '';

  Future<void> _saveProfile(DatabaseService db) async {
    if (_nameController.text.isEmpty || _mobileController.text.isEmpty || _locationController.text.isEmpty) {
      setState(() => _error = 'Please fill out all mandatory fields.');
      return;
    }
    setState(() => _error = '');
    await db.updateUserProfile(
      name: _nameController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      location: _locationController.text.trim(),
      age: int.tryParse(_ageController.text) ?? 0,
      gender: _gender,
      bloodGroup: _bloodGroup,
      medicalHistory: _historyController.text.trim(),
    );
    // Safe completion. StreamBuilder in DashboardScreen intercepts changes and loads the actual app!
  }

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
                    const Text('Complete Profile', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.white),
                      onPressed: () async => await AuthService().signOut(),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Wait! We need some mandatory patient details before you procee.', 
                          style: TextStyle(color: Colors.white70, fontSize: 16), textAlign: TextAlign.center)
                          .animate().fade().slideY(begin: -0.1),
                        const SizedBox(height: 24),
                        
                        const Text('Mandatory Fields', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Full Name *'),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(labelText: 'Mobile Number *'),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _locationController,
                          decoration: const InputDecoration(labelText: 'Location / Pincode *'),
                        ),
                        
                        const SizedBox(height: 32),
                        const Text('Optional Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
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
                        ),
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
                          maxLines: 2,
                          decoration: const InputDecoration(labelText: 'Prior Medical History'),
                        ),
                        
                        const SizedBox(height: 32),
                        if (_error.isNotEmpty) ...[
                          Text(_error, style: const TextStyle(color: Colors.orangeAccent), textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                        ],
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
                          onPressed: () => _saveProfile(db),
                          child: const Text('SAVE & CONTINUE'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
