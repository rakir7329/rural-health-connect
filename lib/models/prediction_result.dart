class PredictionResult {
  final String disease;
  final String severity; // Low, Moderate, Critical
  final String recommendation;
  final List<String> medicines;
  final String doctor;

  PredictionResult({
    required this.disease, 
    required this.severity, 
    required this.recommendation,
    required this.medicines,
    required this.doctor,
  });
}
