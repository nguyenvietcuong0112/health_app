
import 'package:flutter/material.dart';
import 'package:myapp/services/local_storage_service.dart';

class HealthDataProvider with ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();

  int _calories = 2000;
  int _sleepHours = 8;
  final int _steps = 6578; // Mock data

  int get calories => _calories;
  int get sleepHours => _sleepHours;
  int get steps => _steps;

  HealthDataProvider() {
    loadData();
  }

  Future<void> loadData() async {
    final data = await _storageService.loadData();
    _calories = data['calories']!;
    _sleepHours = data['sleepHours']!;
    notifyListeners();
  }

  Future<void> updateData(int newCalories, int newSleepHours) async {
    _calories = newCalories;
    _sleepHours = newSleepHours;
    await _storageService.saveData(_calories, _sleepHours);
    notifyListeners();
  }
}
