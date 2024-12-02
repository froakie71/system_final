import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/feedback_message.dart';

class FeedbackService {
  static const String feedbackKey = 'feedback_data';

  Future<void> saveFeedback(FeedbackMessage feedback) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final feedbackList = await _getFeedbackList();
      feedbackList.add(feedback.toJson());
      await prefs.setString(feedbackKey, json.encode(feedbackList));
    } catch (e) {
      throw Exception('Failed to save feedback: $e');
    }
  }

  Future<List<FeedbackMessage>> searchFeedback(String query) async {
    try {
      final feedbackList = await _getFeedbackList();
      final messages = feedbackList
          .map((json) => FeedbackMessage.fromJson(json))
          .where((feedback) =>
              feedback.message.toLowerCase().contains(query.toLowerCase()))
          .toList();
      messages.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return messages;
    } catch (e) {
      throw Exception('Failed to search feedback: $e');
    }
  }

  Future<List<dynamic>> _getFeedbackList() async {
    final prefs = await SharedPreferences.getInstance();
    final feedbackString = prefs.getString(feedbackKey);
    if (feedbackString != null) {
      return json.decode(feedbackString);
    }
    return [];
  }
}