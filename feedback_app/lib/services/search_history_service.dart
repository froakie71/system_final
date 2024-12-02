import 'dart:convert';
import 'package:feedback_app/models/feedback_message.dart';
import 'package:feedback_app/utils/constants.dart';
import 'package:http/http.dart' as http;

class SearchHistoryService {
  final String baseUrl = ApiConstants.baseUrl;

  Future<List<UserSearchHistory>> getSearchHistory() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/search-history'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => UserSearchHistory.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load search history');
    }
  }

  Future<void> saveSearchHistory(String query, String? searchedUserId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/search-history'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'search_query': query,
        'searched_user_id': searchedUserId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to save search history');
    }
  }
}
