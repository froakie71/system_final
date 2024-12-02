import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class AuthService {
  static const String userKey = 'user_data';

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/frontend/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        await _saveUserData(userData);
        return userData;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (e.toString().contains('XMLHttpRequest')) {
        throw Exception(
            'Cannot connect to server. Please check your connection.');
      }
      throw Exception('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>?> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/frontend/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final userData = json.decode(response.body);
        await _saveUserData(userData);
        return userData;
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      if (e.toString().contains('XMLHttpRequest')) {
        throw Exception(
            'Cannot connect to server. Please check your connection.');
      }
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(userKey);
    if (userString != null) {
      return json.decode(userString);
    }
    return null;
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', userData['token']);
    await prefs.setString('user_data', json.encode(userData['user']));
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
