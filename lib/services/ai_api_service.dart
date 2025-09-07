
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/services.dart'; // Required for PlatformException

class AiApiService {
  final GenerativeModel _model;

  AiApiService(this._model);

  // A specific error message for quota issues
  static const String quotaExceededMessage =
      'The service is temporarily unavailable due to high demand. Please try again later.';

  Future<String> generateHealthTip() async {
    try {
      final response = await _model.generateContent([Content.text(
          'Generate a short, actionable health tip of the day. For example: "Don\'t forget to drink at least 8 glasses of water today to stay hydrated."')]);
      return response.text ?? 'Could not generate a health tip at this moment.';
    } on PlatformException catch (e) {
      if (e.message?.contains('resource-exhausted') ?? false) {
        return quotaExceededMessage;
      }
      return 'Error generating health tip: ${e.message}';
    }
    catch (e) {
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
    } on PlatformException catch (e) {
      // Check if the error message contains the resource exhausted code.
      if (e.message?.contains('resource-exhausted') ?? false) {
        return quotaExceededMessage;
      }
      return 'Error getting response: ${e.message}';
    }
    catch (e) {
      return 'Error getting response: ${e.toString()}';
    }
  }
}
