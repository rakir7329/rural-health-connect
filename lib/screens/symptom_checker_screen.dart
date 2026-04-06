import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/prediction_result.dart';
import '../services/prediction_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key});

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  // Expanded Database covering 20+ parameters
  final List<String> _availableSymptoms = [
    'Fever', 'Cough', 'Sore Throat', 'Chest Pain', 'Shortness of Breath', 
    'Fatigue', 'Dizziness', 'Headache', 'Nausea', 'Body Ache', 'Chills',
    'Stomach Ache', 'Vomiting', 'Diarrhea', 'Loss of Taste', 'Loss of Smell',
    'Runny Nose', 'Muscle Cramps', 'Sweating', 'Weakness', 'Sneezing'
  ];
  
  final Set<String> _selectedSymptoms = {};
  PredictionResult? _result;

  void _runPrediction() {
    setState(() {
      _result = PredictionService.predictDisease(_selectedSymptoms.toList());
    });
  }

  void _toggleSymptom(String sys) {
    setState(() {
      if (_selectedSymptoms.contains(sys)) {
        _selectedSymptoms.remove(sys);
      } else {
        _selectedSymptoms.add(sys);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.backgroundGradient,
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('AI Diagnostic Protocol', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GlassCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Select All Experiencing Symptoms:', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _availableSymptoms.map((sys) {
                                final isSelected = _selectedSymptoms.contains(sys);
                                return ChoiceChip(
                                  label: Text(sys, style: TextStyle(color: isSelected ? Colors.white : AppTheme.darkBlue, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                                  selected: isSelected,
                                  onSelected: (_) => _toggleSymptom(sys),
                                  selectedColor: AppTheme.primaryBlue,
                                  backgroundColor: Colors.white.withOpacity(0.8),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
                                onPressed: _selectedSymptoms.isEmpty ? null : _runPrediction,
                                icon: const Icon(Icons.psychology, color: Colors.white),
                                label: const Text('RUN ALGORITHM'),
                              ),
                            )
                          ],
                        ),
                      ).animate().fade().slideY(begin: 0.1),
                      
                      if (_result != null) ...[
                        const SizedBox(height: 32),
                        GlassCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Diagnostic Result', style: TextStyle(color: Colors.white70, fontSize: 16)),
                              const SizedBox(height: 8),
                              Text(_result!.disease, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(_result!.severity.toLowerCase().contains('critical') ? Icons.error_outline : Icons.warning_amber_rounded, 
                                     color: _result!.severity.toLowerCase().contains('critical') ? Colors.redAccent : Colors.orangeAccent),
                                  const SizedBox(width: 8),
                                  Text('Severity: ${_result!.severity}', style: TextStyle(
                                    color: _result!.severity.toLowerCase().contains('critical') ? Colors.redAccent : Colors.orangeAccent, 
                                    fontSize: 16, fontWeight: FontWeight.bold)
                                  ),
                                ],
                              ),
                              const Divider(color: Colors.white24, height: 30),
                              
                              const Text('Action Plan:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                              const SizedBox(height: 4),
                              Text(_result!.recommendation, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4)),
                              const SizedBox(height: 16),

                              const Text('Suggested Relief Medicines:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                              const SizedBox(height: 4),
                              if (_result!.medicines.isEmpty) 
                                const Text('None.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              for (var med in _result!.medicines)
                                Row(
                                  children: [
                                    const Icon(Icons.medication, color: Colors.greenAccent, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(med, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold))),
                                  ],
                                ),
                              const SizedBox(height: 16),

                              const Text('Consult Specialist:', style: TextStyle(color: Colors.white70, fontSize: 14)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.medical_services, color: Colors.lightBlueAccent, size: 18),
                                  const SizedBox(width: 8),
                                  Text(_result!.doctor, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                ],
                              ),

                            ], // result body column
                          ),
                        ).animate().fade().scale(),
                      ],
                      const SizedBox(height: 100), // padding for navbar
                    ],
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
