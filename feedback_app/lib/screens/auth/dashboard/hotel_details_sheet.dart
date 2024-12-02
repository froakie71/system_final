import 'package:flutter/material.dart';
import '../../../models/hotel.dart';
import '../../../services/auth_service.dart';
import '../../../services/hotel_review_service.dart';

class HotelDetailsSheet extends StatefulWidget {
  final Hotel hotel;
  final ScrollController scrollController;

  const HotelDetailsSheet({
    super.key,
    required this.hotel,
    required this.scrollController,
  });

  @override
  State<HotelDetailsSheet> createState() => _HotelDetailsSheetState();
}

class _HotelDetailsSheetState extends State<HotelDetailsSheet> {
  final _feedbackController = TextEditingController();
  final _adminSearchController = TextEditingController();
  final _hotelReviewService = HotelReviewService();
  final _authService = AuthService();
  double _rating = 0;
  bool _isSubmitting = false;
  bool _isLoading = false;
  List<dynamic> _admins = [];
  String? _selectedAdminId;

  @override
  void initState() {
    super.initState();
    _loadAdmins();
  }

  Future<void> _loadAdmins([String? search]) async {
    try {
      final response = await _hotelReviewService.getAdmins(search: search);
      setState(() => _admins = response['data']);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading admins: $e')),
        );
      }
    }
  }

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isEmpty || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please provide both rating and feedback')),
      );
      return;
    }

    if (_selectedAdminId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an admin')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      print('Debug - Starting review submission');
      print('Rating: $_rating');
      print('Admin ID: $_selectedAdminId');
      print('Feedback: ${_feedbackController.text}');

      await _hotelReviewService.submitReview(
        hotelName: widget.hotel.name,
        feedbackMessage: _feedbackController.text.trim(),
        rating: _rating.toInt(),
        adminId: _selectedAdminId!,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Review submitted successfully')),
        );
      }
    } catch (e) {
      print('Debug - Submission error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting review: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.hotel.name,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.hotel.image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.hotel.description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Rate your experience',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 32,
                  ),
                  onPressed: () {
                    setState(() => _rating = index + 1);
                  },
                );
              }),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write your feedback here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 8),
            if (_admins.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No admin users available',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              DropdownButtonFormField<String>(
                value: _selectedAdminId,
                hint: const Text('Select admin'),
                isExpanded: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: _admins.map((admin) {
                  return DropdownMenuItem(
                    value: admin['id'].toString(),
                    child: Text(
                      '${admin['name']} (${admin['email']})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => _selectedAdminId = value);
                },
                validator: (value) {
                  if (value == null) return 'Please select an admin';
                  return null;
                },
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedAdminId == null || _isSubmitting
                    ? null
                    : _submitFeedback,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
