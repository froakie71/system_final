import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HotelReviewService {
  final String baseUrl = 'http://localhost:8000/api';

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      throw Exception('Not authenticated');
    }
    return token;
  }

  Future<Map<String, dynamic>> getAdmins({String? search}) async {
    try {
      final token = await _getAuthToken();
      print('Debug - Fetching admins with search: $search');
      
      final response = await http.get(
        Uri.parse('$baseUrl/users/admins${search != null ? '?search=$search' : ''}'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Debug - Admin response status: ${response.statusCode}');
      print('Debug - Admin response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to load admins');
      }

      final data = json.decode(response.body);
      print('Debug - Number of admins loaded: ${(data['data'] as List).length}');
      return data;
    } catch (e) {
      print('Debug - Error loading admins: $e');
      throw Exception('Error loading admins: $e');
    }
  }

  Future<Map<String, dynamic>> getReviews(
      {String? search, String? adminId}) async {
    try {
      final token = await _getAuthToken();
      final queryParams = [];
      if (search != null) queryParams.add('search=$search');
      if (adminId != null) queryParams.add('admin_id=$adminId');

      final queryString =
          queryParams.isEmpty ? '' : '?${queryParams.join('&')}';

      final response = await http.get(
        Uri.parse('$baseUrl/reviews$queryString'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load reviews');
      }

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Error loading reviews: $e');
    }
  }

  Future<void> submitReview({
    required String hotelName,
    required String feedbackMessage,
    required int rating,
    required String adminId,
  }) async {
    try {
      final token = await _getAuthToken();
      print('Debug - Sending review data:');
      print('URL: $baseUrl/reviews');
      print('Token: $token');
      print('Data: $hotelName, $rating, $adminId');

      final response = await http.post(
        Uri.parse('$baseUrl/reviews'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'hotel_name': hotelName,
          'feedback_message': feedbackMessage,
          'rating': rating,
          'admin_id': adminId,
        }),
      );

      print('Debug - Response status: ${response.statusCode}');
      print('Debug - Response body: ${response.body}');

      if (response.statusCode == 401) {
        throw Exception('Please login to submit a review');
      }

      if (response.statusCode != 201) {
        final errorBody = json.decode(response.body);
        throw Exception(errorBody['message'] ?? 'Failed to submit review');
      }
    } catch (e) {
      print('Debug - Service error: $e');
      throw Exception('Error submitting review: $e');
    }
  }
}
