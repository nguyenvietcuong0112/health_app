import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import '../models/health_data.dart';
import 'dart:developer' as developer;


class HealthViewModel with ChangeNotifier {
  HealthData _healthData = HealthData(steps: 0, calories: 0, sleepHours: 0);
  List<double> _sleepData = List.filled(7, 0); // Initialize with 0s
  bool _isLoading = false;
  String _aiSuggestion = "Sync your health data to get personalized suggestions.";
  Health? _health;


  HealthData get healthData => _healthData;
  List<double> get sleepData => _sleepData;
  bool get isLoading => _isLoading;
  String get aiSuggestion => _aiSuggestion;

  HealthViewModel() {
    _health = Health();
    fetchHealthData();
  }

  Future<void> fetchHealthData() async {
    _setLoading(true);

    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_IN_BED,
    ];

    final permissions = types.map((e) => HealthDataAccess.READ).toList();

    try {
      bool? authorized = await _health?.requestAuthorization(types, permissions: permissions);

      if (authorized == true) {
        final now = DateTime.now();
        final yesterday = now.subtract(const Duration(days: 1));
        int totalSteps = 0;
        double totalCalories = 0;
        double totalSleepHours = 0;
        List<double> weeklySleep = List.filled(7, 0);

        List<HealthDataPoint> stepsData = await _health?.getHealthDataFromTypes(
              startTime: DateTime(now.year, now.month, now.day),
              endTime: now,
              types: [HealthDataType.STEPS],
            ) ?? [];
        
        totalSteps = stepsData.fold(0, (sum, point) => sum + (point.value as NumericHealthValue).numericValue.toInt());

        List<HealthDataPoint> caloriesData = await _health?.getHealthDataFromTypes(
            startTime: DateTime(now.year, now.month, now.day),
            endTime: now,
            types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        ) ?? [];
        totalCalories = caloriesData.fold(0, (sum, point) => sum + (point.value as NumericHealthValue).numericValue.toDouble());

        List<HealthDataPoint> sleepDataPoints = await _health?.getHealthDataFromTypes(
              startTime: yesterday,
              endTime: now,
              types: [HealthDataType.SLEEP_ASLEEP],
            ) ?? [];
        
        totalSleepHours = sleepDataPoints.fold(0.0, (sum, point) {
            final duration = point.dateTo.difference(point.dateFrom).inMinutes / 60.0;
            return sum + duration;
        });

        for (int i = 0; i < 7; i++) {
            final day = now.subtract(Duration(days: i));
            final startOfDay = DateTime(day.year, day.month, day.day);
            final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59);
            
            final dailySleepPoints = await _health?.getHealthDataFromTypes(
                startTime: startOfDay.subtract(const Duration(hours: 12)),
                endTime: endOfDay,
                types: [HealthDataType.SLEEP_ASLEEP],
            ) ?? [];

            double dailySleepHours = dailySleepPoints.fold(0.0, (sum, point) {
                if (point.dateTo.day == day.day || point.dateFrom.day == day.day) {
                    return sum + point.dateTo.difference(point.dateFrom).inMinutes / 60.0;
                }
                return sum;
            });
            weeklySleep[6 - i] = dailySleepHours; // Fill from right to left
        }


        _healthData = HealthData(
          steps: totalSteps,
          calories: totalCalories.toInt(),
          sleepHours: totalSleepHours,
        );
        _sleepData = weeklySleep;
        _generateAiSuggestion();
        developer.log("Health Data Fetched: Steps: $totalSteps, Sleep: $totalSleepHours hours");
      } else {
        developer.log("Authorization not granted.");
        _aiSuggestion = "Please grant health permissions to sync data.";
      }
    } catch (e, s) {
      developer.log('Error fetching health data', name: 'HealthViewModel', error: e, stackTrace: s);
      _aiSuggestion = "Error syncing health data. Please try again.";
    } finally {
      _setLoading(false);
    }
  }

  void _generateAiSuggestion() {
    if (_healthData.steps > 10000) {
      _aiSuggestion = "Incredible! Over 10,000 steps. You're a star!";
    } else if (_healthData.steps > 5000) {
      _aiSuggestion = "Great job on your steps today! Keep up the momentum!";
    } else {
      _aiSuggestion = "Every step counts. Let's try for a short walk today.";
    }

    if (_healthData.sleepHours < 6) {
      _aiSuggestion += " Aim for a bit more sleep tonight to feel your best.";
    } else if ((_healthData.sleepHours) > 7.5) {
      _aiSuggestion += " You're getting a healthy amount of sleep. Well done!";
    }
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
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
}
