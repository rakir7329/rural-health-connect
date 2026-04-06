import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import 'health_tracker_screen.dart';
import 'medicine_reminder_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) return const Scaffold();

    final db = DatabaseService(uid: user.uid);

    return Scaffold(
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<UserModel>(
                  stream: db.userData,
                  builder: (context, snapshot) {
                    final name = snapshot.data?.name ?? 'User';
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hello,', style: TextStyle(color: Colors.white70, fontSize: 16)),
                            Text(
                              name.isEmpty ? 'Patient' : name.split(' ')[0], 
                              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)
                            ),
                          ],
                        ).animate().fade(duration: 500.ms).slideX(begin: -0.2, end: 0),
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: const Icon(Icons.person, color: Colors.white, size: 36),
                        ).animate().scale(delay: 200.ms, duration: 400.ms),
                      ],
                    );
                  }
                ),
                const SizedBox(height: 32),
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Rural Health Connect', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('Empowering rural healthcare with AI diagnostics.', style: TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.health_and_safety, color: Colors.white, size: 60),
                    ],
                  ),
                ).animate().fade(delay: 300.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 32),
                const Text('Tools & Tracking', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(child: _buildActionCard(context, 'Vitals Tracker', Icons.monitor_heart, const HealthTrackerScreen(), 400)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildActionCard(context, 'Medications', Icons.medication, const MedicineReminderScreen(), 500)),
                  ],
                ),
                const SizedBox(height: 120), // Padding for nav bar
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Widget destination, int delayMs) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => destination)),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
          ],
        ),
      ),
    ).animate().fade(delay: Duration(milliseconds: delayMs)).scale();
  }
}
