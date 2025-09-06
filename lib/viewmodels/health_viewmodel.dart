import 'package:flutter/foundation.dart';
import 'dart:math';

import '../models/health_data.dart';

class HealthViewModel with ChangeNotifier {
  late HealthData _healthData;
  late List<double> _sleepData;

  HealthData get healthData => _healthData;
  List<double> get sleepData => _sleepData;

  HealthViewModel() {
    _fetchInitialHealthData();
  }

  // Simulates fetching initial data
  void _fetchInitialHealthData() {
    final random = Random();
    _healthData = HealthData(
      steps: random.nextInt(10000) + 2000, // Steps between 2,000 and 12,000
      calories: random.nextInt(1000) + 1500, // Calories between 1500 and 2500
      sleepHours: random.nextInt(4) + 6, // Sleep hours between 6 and 10
    );
    _sleepData = List.generate(7, (index) => random.nextDouble() * 4 + 5); // Sleep hours between 5 and 9
  }

  // Example of how you might update data later
  void updateHealthData() {
    final random = Random();
    _healthData = HealthData(
      steps: random.nextInt(10000) + 2000,
      calories: random.nextInt(1000) + 1500,
      sleepHours: random.nextInt(4) + 6, // Sleep hours between 6 and 10
    );
    _sleepData = List.generate(7, (index) => random.nextDouble() * 4 + 5); // Sleep hours between 5 and 9
    notifyListeners(); // Notify UI to rebuild
  }
}
