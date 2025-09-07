import 'package:firebase_ai/firebase_ai.dart';

class AiApiService {
  final GenerativeModel _model;

  AiApiService(this._model);

  Future<String> generateHealthTip() async {
    try {
      final response = await _model.generateContent([Content.text(
        'Generate a short, actionable health tip of the day. For example: "Don\'t forget to drink at least 8 glasses of water today to stay hydrated."')]);
      return response.text ?? 'Could not generate a health tip at this moment.';
    } catch (e) {
      return 'Error generating health tip: ${e.toString()}';
    }
  }

  Future<String> getChatResponse(String prompt) async {
    if (prompt.isEmpty) {
      return 'Please provide a prompt.';
    }
    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      return response.text ?? 'No response from model.';
    } catch (e) {
      return 'Error getting response: ${e.toString()}';
    }
  }
}
