import '../models/prediction_result.dart';

class DiseaseProfile {
  final String name;
  final String severity;
  final String recommendation;
  final List<String> medicines;
  final String doctor;
  final List<String> primarySymptoms;

  DiseaseProfile({
    required this.name,
    required this.severity,
    required this.recommendation,
    required this.medicines,
    required this.doctor,
    required this.primarySymptoms,
  });
}

class PredictionService {
  static final List<DiseaseProfile> _database = [
    DiseaseProfile(
      name: 'Malaria / Dengue',
      severity: 'High',
      recommendation: 'Seek immediate blood tests. Rest under mosquito net and monitor hydration heavily.',
      medicines: ['Paracetamol', 'ORS (Oral Rehydration Solution)'],
      doctor: 'General Physician / Infectious Disease',
      primarySymptoms: ['fever', 'chills', 'body ache', 'joint pain', 'fatigue', 'sweating', 'nausea'],
    ),
    DiseaseProfile(
      name: 'COVID-19 / Severe Flu',
      severity: 'Critical',
      recommendation: 'Strict isolation. Monitor oxygen levels frequently and hydrate.',
      medicines: ['Paracetamol', 'Cough Syrup', 'Vitamin C', 'Zinc Supplements'],
      doctor: 'Pulmonologist / General Physician',
      primarySymptoms: ['fever', 'cough', 'loss of taste', 'loss of smell', 'shortness of breath', 'sore throat'],
    ),
    DiseaseProfile(
      name: 'Food Poisoning / Gastroenteritis',
      severity: 'Moderate',
      recommendation: 'Focus entirely on replacing lost fluids. Do not eat solid heavy foods until vomiting stops.',
      medicines: ['ORS', 'Antacids', 'Anti-diarrheal (Consult Doctor)'],
      doctor: 'Gastroenterologist',
      primarySymptoms: ['stomach ache', 'vomiting', 'diarrhea', 'nausea', 'cramps', 'weakness'],
    ),
    DiseaseProfile(
      name: 'High Risk Cardiac Event (Angina/Heart Attack)',
      severity: 'CRITICAL EMERGENCY',
      recommendation: 'CALL AMBULANCE IMMEDIATELY. Do not move excessively. Stay calm.',
      medicines: ['Aspirin (Chewed) - ONLY if confirmed cardiac risk'],
      doctor: 'Cardiologist / Emergency Room',
      primarySymptoms: ['chest pain', 'shortness of breath', 'dizziness', 'sweating', 'nausea'],
    ),
    DiseaseProfile(
      name: 'Migraine / Tension Headache',
      severity: 'Moderate',
      recommendation: 'Rest in a dark, quiet room. Apply cold compress to forehead.',
      medicines: ['Ibuprofen', 'Acetaminophen'],
      doctor: 'Neurologist / General Clinic',
      primarySymptoms: ['headache', 'nausea', 'dizziness', 'sensitivity to light', 'fatigue'],
    ),
    DiseaseProfile(
      name: 'Common Cold / Viral Rhinitis',
      severity: 'Low',
      recommendation: 'Inhale steam twice daily. Take plenty of warm fluids.',
      medicines: ['Antihistamines', 'Cough Lozenges', 'Saline Nasal Spray'],
      doctor: 'General Clinic / Local Asha Worker',
      primarySymptoms: ['runny nose', 'sneezing', 'sore throat', 'cough', 'mild fever'],
    ),
    DiseaseProfile(
      name: 'Typhoid Fever',
      severity: 'High',
      recommendation: 'Requires long-term antibiotic treatment. Hydrate well.',
      medicines: ['Specific Antibiotics (Needs Prescription)!'],
      doctor: 'Infectious Disease Specialist',
      primarySymptoms: ['high prolonged fever', 'stomach ache', 'weakness', 'headache', 'diarrhea or constipation'],
    ),
    DiseaseProfile(
      name: 'Dehydration / General Fatigue',
      severity: 'Low',
      recommendation: 'Increase water intake significantly. Rest away from direct sunlight.',
      medicines: ['ORS', 'Electrolyte Solutions'],
      doctor: 'General Clinic',
      primarySymptoms: ['dizziness', 'weakness', 'fatigue', 'muscle cramps', 'dry mouth'],
    ),
  ];

  static PredictionResult predictDisease(List<String> symptoms) {
    if (symptoms.isEmpty) {
      return PredictionResult(
        disease: 'Unknown', 
        severity: 'None', 
        recommendation: 'Please select symptoms for analysis.',
        medicines: [],
        doctor: 'N/A'
      );
    }

    final lowerInput = symptoms.map((e) => e.toLowerCase()).toList();

    DiseaseProfile? bestMatch;
    int highestScore = 0;

    // Scoring Algorithm Engine
    for (var profile in _database) {
      int score = 0;
      for (var sym in lowerInput) {
        if (profile.primarySymptoms.contains(sym)) {
          // Weighted scoring: if it matches a critical symptom, increase score massively.
          if (sym == 'chest pain' && profile.name.contains('Cardiac')) score += 5;
          if ((sym == 'loss of taste' || sym == 'loss of smell') && profile.name.contains('COVID')) score += 5;
          score += 1;
        }
      }

      if (score > highestScore) {
        highestScore = score;
        bestMatch = profile;
      }
    }

    if (bestMatch != null && highestScore > 0) {
      return PredictionResult(
        disease: bestMatch.name,
        severity: bestMatch.severity,
        recommendation: bestMatch.recommendation,
        medicines: bestMatch.medicines,
        doctor: bestMatch.doctor,
      );
    }

    // Fallback if no logical combination is found
    return PredictionResult(
      disease: 'Atypical Viral / General Malaise',
      severity: 'Moderate',
      recommendation: 'Your combination of symptoms is uncommon or complex. Monitor them and visit a clinic if they persist for 48 hours.',
      medicines: ['Paracetamol (for pain/fever)', 'Rest'],
      doctor: 'General Physician',
    );
  }
}
