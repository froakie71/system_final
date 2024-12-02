import 'package:feedback_app/services/hotel_review_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminReviewsScreen extends StatefulWidget {
  const AdminReviewsScreen({super.key});

  @override
  State<AdminReviewsScreen> createState() => _AdminReviewsScreenState();
}

class _AdminReviewsScreenState extends State<AdminReviewsScreen> {
  final _searchController = TextEditingController();
  final _adminSearchController = TextEditingController();
  final _reviewService = HotelReviewService();
  List<dynamic> _reviews = [];
  List<dynamic> _admins = [];
  bool _isLoading = false;
  String? _selectedAdminId;

  @override
  void initState() {
    super.initState();
    _loadReviews();
    _loadAdmins();
  }

  Future<void> _loadAdmins([String? search]) async {
    try {
      final response = await _reviewService.getAdmins(search: search);
      setState(() => _admins = response['data']);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading admins: $e')),
      );
    }
  }

  Future<void> _loadReviews([String? search]) async {
    setState(() => _isLoading = true);
    try {
      final response = await _reviewService.getReviews(
        search: search,
        adminId: _selectedAdminId,
      );
      setState(() => _reviews = response['data']);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading reviews: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hotel Reviews')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Admin Search
                TextField(
                  controller: _adminSearchController,
                  decoration: InputDecoration(
                    hintText: 'Search admins...',
                    prefixIcon: const Icon(Icons.person_search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: _loadAdmins,
                ),
                if (_admins.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedAdminId,
                      hint: const Text('Select admin'),
                      items: _admins.map((admin) {
                        return DropdownMenuItem(
                          value: admin['id'].toString(),
                          child: Text(admin['name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedAdminId = value;
                          _loadReviews();
                        });
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                // Review Search
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search reviews...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => _loadReviews(value),
                ),
              ],
            ),
          ),
          // Existing review list code...
        ],
      ),
    );
  }
}