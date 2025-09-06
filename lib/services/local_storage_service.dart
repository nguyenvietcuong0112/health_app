
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> saveData(int calories, int sleepHours) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('calories', calories);
    await prefs.setInt('sleepHours', sleepHours);
  }

  Future<Map<String, int>> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final calories = prefs.getInt('calories') ?? 2000; // Default values
    final sleepHours = prefs.getInt('sleepHours') ?? 8;
    return {'calories': calories, 'sleepHours': sleepHours};
  }
}
