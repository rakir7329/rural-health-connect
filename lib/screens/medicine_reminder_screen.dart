import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/database_service.dart';
import '../models/medicine_reminder.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class MedicineReminderScreen extends StatefulWidget {
  const MedicineReminderScreen({super.key});

  @override
  State<MedicineReminderScreen> createState() => _MedicineReminderScreenState();
}

class _MedicineReminderScreenState extends State<MedicineReminderScreen> {
  final _nameController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _addReminder(DatabaseService db) async {
    if (_nameController.text.isNotEmpty) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute);
      await db.addMedicineReminder(MedicineReminder(name: _nameController.text, time: dt));
      _nameController.clear();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reminder Added!')));
    }
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    const BackButton(color: Colors.white),
                    const Text('My Meds', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GlassCard(
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: const InputDecoration(labelText: 'Medicine Name'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(16)),
                              child: Text('Time: ${_selectedTime.format(context)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white.withOpacity(0.9), foregroundColor: AppTheme.primaryBlue, padding: const EdgeInsets.all(16)),
                            onPressed: () => _selectTime(context),
                            child: const Icon(Icons.access_time),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.black),
                          onPressed: () => _addReminder(db),
                          child: const Text('ADD REMINDER'),
                        ),
                      ),
                    ],
                  ),
                ).animate().slideY(begin: -0.2, end: 0, duration: 600.ms),
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Align(alignment: Alignment.centerLeft, child: Text('Timeline', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))),
              ),
              
              Expanded(
                child: StreamBuilder<List<MedicineReminder>>(
                  stream: db.medicineReminders,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.white));
                    
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final rem = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GlassCard(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              leading: const CircleAvatar(
                                backgroundColor: Colors.white24,
                                child: Icon(Icons.medication, color: Colors.orangeAccent),
                              ),
                              title: Text(rem.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                              trailing: Text(DateFormat.jm().format(rem.time), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                            ),
                          ),
                        ).animate().fade(delay: Duration(milliseconds: 100 * index)).slideX();
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
