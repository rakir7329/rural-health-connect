import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class HealthTipsScreen extends StatelessWidget {
  const HealthTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Health Awareness')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildPremiumTipCard(
            'Daily Hygiene',
            'Wash hands frequently with soap to prevent diseases like cholera.',
            Icons.wash,
            Colors.blue,
            0
          ),
          _buildPremiumTipCard(
            'Nutrition',
            'Ensure a balanced diet rich in iron and vitamins using local vegetables.',
            Icons.food_bank,
            Colors.green,
            100
          ),
          _buildPremiumTipCard(
            'Safe Drinking Water',
            'Always boil and filter water before drinking, especially during monsoon.',
            Icons.water_drop,
            Colors.teal,
            200
          ),
          _buildPremiumTipCard(
            'Mosquito Prevention',
            'Use mosquito nets and clear stagnant water to prevent Malaria.',
            Icons.pest_control,
            Colors.orange,
            300
          ),
          _buildPremiumTipCard(
            'Regular Check-ups',
            'Visit the local Asha worker or clinic regularly if you feel unwell.',
            Icons.local_hospital,
            Colors.red,
            400
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTipCard(String title, String desc, IconData icon, Color color, int delayMs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8))]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color.withOpacity(0.6), color],
                  ),
                ),
                child: Center(child: Icon(icon, color: Colors.white, size: 40)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                      const SizedBox(height: 8),
                      Text(desc, style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.5)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(delay: Duration(milliseconds: delayMs)).slideX(begin: 0.1, end: 0);
  }
}
