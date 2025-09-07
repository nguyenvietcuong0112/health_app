import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/message.dart';
import '../services/ai_api_service.dart';

class ChatViewModel extends ChangeNotifier {
  final AiApiService _aiApiService;
  static const _chatHistoryKey = 'chat_history';

  ChatViewModel(this._aiApiService) {
    _loadChatHistory();
  }

  List<Message> _messages = [];
  bool _isLoading = false;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final chatHistoryJson = prefs.getString(_chatHistoryKey);
    if (chatHistoryJson != null) {
      final List<dynamic> decodedJson = jsonDecode(chatHistoryJson);
      _messages = decodedJson.map((json) => Message.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final chatHistoryJson = jsonEncode(_messages.map((msg) => msg.toJson()).toList());
    await prefs.setString(_chatHistoryKey, chatHistoryJson);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    _messages.add(Message(text: text, sender: MessageSender.user));
    _saveChatHistory(); // Save after adding user message
    
    // Add loading indicator
    _isLoading = true;
    _messages.add(Message(text: '', sender: MessageSender.ai, isLoading: true));
    notifyListeners();

    try {
      // Get AI response
      final aiResponse = await _aiApiService.getChatResponse(text);
      
      // Remove loading indicator and add AI response
      _messages.removeLast(); // Remove the loading message
      _messages.add(Message(text: aiResponse, sender: MessageSender.ai));
      _saveChatHistory(); // Save after getting AI response
    } catch (e) {
      _messages.removeLast();
      _messages.add(Message(text: 'Error: Could not get response.', sender: MessageSender.ai));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearChat() async {
    _messages.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_chatHistoryKey);
    notifyListeners();
  }
}
