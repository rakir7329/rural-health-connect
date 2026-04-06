import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/database_service.dart';
import '../models/health_record.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class HealthTrackerScreen extends StatefulWidget {
  const HealthTrackerScreen({super.key});

  @override
  State<HealthTrackerScreen> createState() => _HealthTrackerScreenState();
}

class _HealthTrackerScreenState extends State<HealthTrackerScreen> {
  final _bpController = TextEditingController();
  final _sugarController = TextEditingController();
  final _tempController = TextEditingController();

  Widget _buildChart(List<HealthRecord> records) {
    if (records.length < 2) return const Center(child: Text('Add more data to see trends.', style: TextStyle(color: Colors.white70)));

    List<FlSpot> spots = [];
    final sorted = List<HealthRecord>.from(records)..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    
    for (int i = 0; i < sorted.length; i++) {
      spots.add(FlSpot(i.toDouble(), sorted[i].sugarLevel));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: const TextStyle(color: Colors.white70, fontSize: 10)))),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.white,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: Colors.white.withOpacity(0.3)),
          ),
        ],
      ),
    );
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
                    const Text('Detailed Tracker', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              GlassCard(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _sugarController, decoration: const InputDecoration(labelText: 'Sugar (mg/dL)'), keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(child: TextField(controller: _bpController, decoration: const InputDecoration(labelText: 'BP (120/80)'))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _tempController, decoration: const InputDecoration(labelText: 'Temp (°F)'), keyboardType: TextInputType.number)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, foregroundColor: Colors.white),
                            onPressed: () async {
                              if (_bpController.text.isNotEmpty && _sugarController.text.isNotEmpty) {
                                await db.addHealthRecord(HealthRecord(
                                  bp: _bpController.text,
                                  sugarLevel: double.tryParse(_sugarController.text) ?? 0.0,
                                  temperature: double.tryParse(_tempController.text) ?? 0.0,
                                  timestamp: DateTime.now(),
                                ));
                                _bpController.clear(); _sugarController.clear(); _tempController.clear();
                                context.mounted ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vitals Logged!'))) : null;
                              }
                            },
                            child: const Text('LOG'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().slideY(begin: -0.2, end: 0, duration: 500.ms),
              
              Expanded(
                child: StreamBuilder<List<HealthRecord>>(
                  stream: db.healthRecords,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.white));
                    
                    return Column(
                      children: [
                        Container(
                          height: 200,
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: GlassCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text('Sugar Level Trend', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(height: 16),
                                Expanded(child: _buildChart(snapshot.data!)),
                              ],
                            ),
                          ),
                        ).animate().fade(delay: 300.ms),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final r = snapshot.data![index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: GlassCard(
                                  padding: EdgeInsets.zero,
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.white24,
                                      child: Icon(Icons.favorite, color: Colors.white),
                                    ),
                                    title: Text('BP: ${r.bp} | Sugar: ${r.sugarLevel}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                    subtitle: Text(DateFormat('MMM dd, yyyy - HH:mm').format(r.timestamp), style: const TextStyle(fontSize: 12, color: Colors.white70)),
                                    trailing: Text('${r.temperature}°F', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
                                  ),
                                ),
                              ).animate().fade(delay: Duration(milliseconds: 100 * index)).slideX();
                            },
                          ),
                        ),
                      ],
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
