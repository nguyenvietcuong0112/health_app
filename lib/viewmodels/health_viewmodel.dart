import 'package:flutter/foundation.dart';
import 'dart:math';

import '../models/health_data.dart';

class HealthViewModel with ChangeNotifier {
  late HealthData _healthData;
  late List<double> _sleepData;
  bool _isLoading = false;
  String _aiSuggestion = "";

  HealthData get healthData => _healthData;
  List<double> get sleepData => _sleepData;
  bool get isLoading => _isLoading;
  String get aiSuggestion => _aiSuggestion;

  HealthViewModel() {
    _fetchInitialHealthData();
  }

  void _fetchInitialHealthData() {
    _setLoading(true);
    final random = Random();
    _healthData = HealthData(
      steps: random.nextInt(10000) + 2000, 
      calories: random.nextInt(1000) + 1500, 
      sleepHours: random.nextDouble() * 4 + 5, 
    );
    _sleepData = List.generate(7, (index) => random.nextDouble() * 4 + 5); 
    _generateAiSuggestion();
    _setLoading(false);
  }

  void updateHealthData({int? steps, int? calories, double? sleepHours}) {
    _setLoading(true);
    _healthData = HealthData(
      steps: steps ?? _healthData.steps,
      calories: calories ?? _healthData.calories,
      sleepHours: sleepHours ?? _healthData.sleepHours,
    );
    _generateAiSuggestion();
    _setLoading(false);
  }

  void _generateAiSuggestion() {
    final suggestions = [
      "Great job on your steps today! Keep it up!",
      "You're doing great. Remember to drink plenty of water.",
      "A good night's sleep is key. Try to get to bed a little earlier tonight.",
      "Fantastic effort! Your body will thank you.",
      "Every step counts. You're on the right track!"
    ];
    _aiSuggestion = suggestions[Random().nextInt(suggestions.length)];
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
